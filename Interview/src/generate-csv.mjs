import { resultsDir, analysisDir } from './common.mjs';
import { Path, Fsp, Yaml, DirectoryExists, _f, _, Csv } from './utilities.mjs';
import { DataTable } from './data-table.mjs';

const accentTable = new DataTable({
	culture: '',
	totalCount: 0,
	ratio: 0,
	accentedCount: 0,
	positionSum: 0,
	avgPosition: 0,
});
const vowelTable = new DataTable({
	culture: '',
});
const consonantTable = new DataTable({
	culture: '',
});

Main().catch(err => {
	console.error(err);
});

async function Main() {
	if(!DirectoryExists(resultsDir))
		throw new ReferenceError('No reference directory found.');

	const resultFileNames = (await Fsp.readdir(resultsDir))
		.filter(name => name.endsWith('.yml'));

	for(const fn of resultFileNames) {
		const path = Path.resolve(resultsDir, fn);
		await ProcessResultFile(path);
	}

	PostProcessAccent();
	_f.forEach(x => MergeCultures(x))([vowelTable, consonantTable]);
	_f.forEach(x => TrimPhonemeTable(x))([vowelTable, consonantTable]);
	_f.forEach(x => x.SortColumns(KeySort))([vowelTable, consonantTable]);

	WriteCsvTable(accentTable, 'accent.csv');
	WriteCsvTable(vowelTable, 'vowel.csv');
	WriteCsvTable(consonantTable, 'consonant.csv');
}

async function WriteCsvTable(table, filename) {
	const path = Path.resolve(analysisDir, filename);
	const content = await new Promise(res => Csv.stringify(table.AsArray(), (err, result) => res(result)));

	await Fsp.writeFile(path, '\ufeff' + content, { encoding: 'utf8' });
	console.log(`Output to ${path}`);
}

const encoding = 'utf-8';
async function ProcessResultFile(resultFilePath) {
	const content = await Fsp.readFile(resultFilePath);
	const result = Yaml.parse(content.toString(encoding));
	result.name = result.name.toLowerCase();
	const speech = ParseResult(result);

	ProcessAccent(result, speech);
	ProcessVowel(result, speech);
	ProcessConsonant(result, speech);
}

function KeySort(a, b) {
	if(a === 'culture')
		return -1;
	if(b === 'culture')
		return 1;
	return a < b ? -1 : 1;
}

const vowels = 'aæɐɑαᴂᴀeəɛɜʚɘœɶᴇuɯʊʌɷʉᵾiɪɩɨᵻᵼoɒɔøɵɞɤʏyɥʮʯ';
/**
 * @param {string} letters
 * @param {string} phonemes
 */
function MakePhoneRecord(letters, phonemes) {
	const record = {
		letters: letters,
		phonemes: phonemes.replace('\'', ''),
		isAccented: phonemes.includes('\''),
		isVowel: Array.prototype.some.call(phonemes, p => vowels.includes(p)),
	};
	return record;
}

const syllablePrototype = {
	__proto__: Array.prototype,
	get hasVowel() {
		return this.some(p => p.isVowel);
	},
	get isAccented() {
		return this.some(p => p.isAccented);
	},
	toString() {
		return this.map(x => x.letters).join('');
	},
};

function ParseResult(result) {
	const polygrams = result.name.split('/');
	const phonemes = result.transcription.split('/');
	if(polygrams.length !== phonemes.length)
		throw `The section amount of "${result.name}" and [${result.transcription}] are not equal.`;

	const pairs = Array(polygrams.length).fill(0)
		.map((_, i) => MakePhoneRecord(polygrams[i], phonemes[i]));

	const syllables = [];
	for(let i = 0; i < pairs.length; ++i) {
		const s = [];
		s.__proto__ = syllablePrototype;
		for(let vowelled = false; i < pairs.length; ++i) {
			let curr = pairs[i];
			if(vowelled) {
				if(curr.isAccented || !curr.isVowel)
					break;
			}
			if(curr.isVowel)
					vowelled = true;
			s.push(curr);
		}
		--i;
		syllables.push(s);
	}

	// Merge the trailing consonants to previous syllables.
	while(syllables.length > 1 && !syllables[syllables.length - 1].hasVowel) {
		const secondToLast = syllables[syllables.length - 2];
		const last = syllables.pop();
		secondToLast.splice(secondToLast.length, 0, ...last);
	}

	return { pairs, syllables, };
}

function ProcessAccent(result, speech) {
	const merger = FindCultureMerger(result.culture);
	if(!merger)
		return;

	const row = AddRowToTable(accentTable, merger);
	IncreaseOnRow(row, 'totalCount');

	const isAccented = result.transcription.includes('\'');
	if(isAccented) {
		IncreaseOnRow(row, 'accentedCount');
		const position = speech.syllables.findIndex(s => s.isAccented);
		IncreaseOnRow(row, 'positionSum', position / speech.syllables.length);
	}
}

function PostProcessAccent() {
	for(const row of accentTable.rows) {
		row.avgPosition = row.positionSum /row.accentedCount;
		row.ratio = row.accentedCount / row.totalCount;
	}

	accentTable.RemoveColumn('totalCount');
	accentTable.RemoveColumn('accentedCount');
	accentTable.RemoveColumn('positionSum');
}

function AddRowToTable(table, culture) {
	const existing = table.rows.find(row => row.culture === culture);
	if(existing)
		return existing;
	const newRow = { culture };
	table.AddRow(newRow);
	return newRow;
}

function IncreaseOnRow(row, key, n = 1) {
	if(!(key in row))
		row[key] = 0;
	row[key] += n;
}

function ProcessPhoneme(result, speech, table, predicate) {
	const row = AddRowToTable(table, result.culture);

	for(const pair of speech.pairs) {
		if(!predicate(pair))
			continue;
		if(!(pair.letters && pair.phonemes))
			continue;

		const key = `${pair.letters}_${pair.phonemes}`;
		table.AddColumn(key, 0);
		IncreaseOnRow(row, key);
	}
}

function ProcessVowel(result, speech) {
	ProcessPhoneme(result, speech, vowelTable, p => p.isVowel);
}

function ProcessConsonant(result, speech) {
	ProcessPhoneme(result, speech, consonantTable, p => !p.isVowel);
}

const cultureMerger = {
	'Asia': ['Turkic', 'Indian', 'Chinese', 'Japanese'],
	'Central and Eastern Europe': ['Serbo-Croatian', 'German', 'Russian'],
	'Southern Europe': ['Spanish', 'Portuguese', 'Italian'],
	'Middle East': ['Arabic', 'Persian', 'Iranian', 'Hebrew'],
};

function FindCultureMerger(culture) {
	return _f.pipe(
		_f.entries,
		_f.find(([, v]) => v.includes(culture)),
		_f.get(0),
	)(cultureMerger);
}

/**
 * @param {DataTable} table
 */
function MergeCultures(table) {
	const cultures = _f.pipe(
		_f.map(r => r.culture),
		_f.union(_f.id),
	)(table.rows);
	for(const culture of cultures) {
		const ri = table.rows.findIndex(r => r.culture === culture);
		const row = table.rows[ri];
		table.rows.splice(ri, 1);

		const merger = FindCultureMerger(culture);
		if(merger) {
			const mergerRow = AddRowToTable(table, merger);
			for(const [k, v] of _f.pipe(_f.omit(['culture']), _f.entries)(row))
				IncreaseOnRow(mergerRow, k, v);
		}
	}
}

/**
 * @param {DataTable} table
 */
function TrimPhonemeTable(table, occurrenceThreshold = 2) {
	// Trim all records that have only few occurrence.
	const fewOccurrencePairs = _f.pipe(
		Array.from,
		_f.filter(key => {
			let occurrence = 0;
			for(const row of table.rows)
				occurrence += table.Get(key, row);
			return occurrence <= occurrenceThreshold;
		}),
	)(Object.keys(table.columns))
	for(const k of fewOccurrencePairs)
		table.RemoveColumn(k);

	// Trim all the phonemes lacking contrast.

	const pairs = _f.pipe(
		Array.from,
		arr => arr.slice(1), // Remove the culture column.
		_f.map(p => [p.split('_'), p]),
	)(Object.keys(table.columns));

	const lackingContrastPairs = pairs.filter(
		([[l]], i) => !pairs.some(([[l_]], i_) => i_ !== i && l_ === l)
	);

	for(const [, k] of lackingContrastPairs)
		table.RemoveColumn(k);
}