import { dataDir, resultsDir } from './common.mjs';
import { Path, Fsp, Yaml, DirectoryExists, FileExists, ExtractAudioBas464 } from './utilities.mjs';

Main().catch(err => {
	console.error(err);
});

/** Type definitions
 *
 * @typedef {Object} Interview
 * @property {InterviewMeta} meta
 * @property {Array<DataEntry>} data
 *
 * @typedef {Object} InterviewMeta
 * @property {string} time
 * @property {string} location
 * @property {string?} interview
 *
 * @typedef {Object} DataEntry
 * @property {string} name
 * @property {string} culture
 * @property {string} portraitUrl
 * @property {string} voiceClip
 *
 * @typedef {InterviewMeta} Result
 * @property {string} audioBane
 */

async function Main() {
	if(!DirectoryExists(dataDir))
		throw new ReferenceError('No data directory found.');

	if(!DirectoryExists(resultsDir))
		await Fsp.mkdir(resultsDir);

	for(const fileName of await Fsp.readdir(dataDir)) {
		const content = await Fsp.readFile(Path.resolve(dataDir, fileName));
		/** @type {Interview} */
		const interview = JSON.parse(content.toString('utf-8'));
		for(const [i, entry] of interview.data.entries()) {
			Handle(interview.meta, entry, i).catch(error => console.error(error));
		}
	}
}

/**
 * @param {InterviewMeta} meta
 * @param {DataEntry} entry
 * @param {number} i
 */
async function Handle(meta, entry, i) {
	const baseName = GetResultBaseName(meta, entry, i);
	const entryPath = Path.resolve(resultsDir, baseName + '.yml');
	if(FileExists(entryPath)) {
		console.warn(`${entryPath} already exists, skipping.`);
		return;
	}
	const audioPath = Path.resolve(resultsDir, baseName + '.webm');

	const resultEntry = CreateEmptyResultEntry(meta, entry);
	const audio = Buffer.from(ExtractAudioBas464(entry.voiceClip), 'base64url');

	Fsp.writeFile(entryPath, Yaml.stringify(resultEntry));
	Fsp.writeFile(audioPath, audio);
}

const timeRegex = /^(\d+)-(\d+)-(\d+)[A-Z](\d+):(\d+):(\d+)\.(\d+)[A-Z]$/i;
/**
 * @param {InterviewMeta} meta
 * @param {DataEntry} entry
 * @param {number} i
 * @returns {string}
 */
function GetResultBaseName(meta, entry, i) {
	const time = meta.time;
	const matchResult = timeRegex.exec(time);
	if(matchResult === null)
		throw new TypeError('Malformed time format.');
	const [, year, month, date, hour, minute, second, millisecond] = matchResult;

	return `${year}${month}${date}${hour}${minute}${second}${millisecond}_${i}`;
}

/**
 * @param {InterviewMeta} meta
 * @param {DataEntry} entry
 */
function CreateEmptyResultEntry(meta, entry) {
	const result = {
		name: entry.name,
		culture: entry.culture,
		transcription: '',
	};
	return result;
}