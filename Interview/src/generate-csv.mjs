import { resultsDir, analysisDir } from './common.mjs';
import { Path, Fsp, Yaml, DirectoryExists, _f, _, Csv } from './utilities.mjs';

const headers = [
	'culture',
	'transcription',
	'syllableCount',
	'isAccented',
	'accentPosition',
];
/** @type {Map<string, number>} */
let realizationKeyIndexMap;

Main().catch(err => {
	console.error(err);
});

async function Main() {
	if(!DirectoryExists(resultsDir))
		throw new ReferenceError('No reference directory found.');
	const datumFileNames = (await Fsp.readdir(resultsDir))
		.filter(name => name.endsWith('.yml'));

	const tasks = datumFileNames.map(async fileName => {
		const filePath = Path.resolve(resultsDir, fileName);
		const source = (await Fsp.readFile(filePath)).toString('utf-8');
		return Yaml.parse(source);
	});
	const data = await Promise.all(tasks);

	const realizationKeys = _f.pipe(
		_f.map(datum => _f.pipe(
			_f.entries,
			_f.map(([k, vs]) => vs.map(v => MakeRealizationPair(k, v))),
			_f.flatten,
		)(datum['realization'])),
		arr => _.union(...arr),
	)(data);
	realizationKeyIndexMap = _f.pipe(
		_f.entries,
		_f.map(([i, x]) => [+i, x]),
		_f.map(_.reverse),
		x => new Map(x)
	)(realizationKeys);
	headers.splice(headers.length, 0, ...realizationKeys);
	
	const rows = data.map(DatumToRow);
	const table = [headers].concat(rows);

	const csvOutputPath = Path.resolve(analysisDir, 'formatted-data.csv');
	const csvContent = await new Promise(res => Csv.stringify(table, (err, result) => res(result)));

	await Fsp.writeFile(csvOutputPath, '\ufeff' + csvContent, { encoding: 'utf8' });
	console.log(`Output table is written to ${csvOutputPath}`);
}

function MakeRealizationPair(a, b) {
	return `${a}_${b}`;
}

function IsNumber(x) {
	if(isNaN(x))
		return false;
	if(x === null || x === undefined)
		return false;
	return true;
}

/**
 * @returns {Array}
 */
function DatumToRow(datum) {
	const accentPosition = datum['accent'];
	const isAccented = IsNumber(accentPosition);

	const row = [
		datum['culture'],
		datum['transcription'],
		+datum['syllableCount'],
		isAccented,
		isAccented ? accentPosition : NaN,
	];

	const realizations = Array(realizationKeyIndexMap.size).fill(0);
	for(const key in datum['realization']) {
		for(const v of datum['realization'][key]) {
			const pair = MakeRealizationPair(key, v);
			if(!realizationKeyIndexMap.has(pair)) {
				console.warn(`Realization of "${pair}" is not indexed.`);
				continue;
			}
			const index = realizationKeyIndexMap.get(pair);
			if(!(index in realizations))
				continue;
			++realizations[index];
		}
	}
	row.splice(row.length, 0, ...realizations);

	return row;
}