export * as Path from 'path';
export * as Fsp from 'fs/promises';
export * as Fs from 'fs';

import * as Fs from 'fs';

/**
 * @param {string} path
 */
export function DirectoryExists(path) {
	return Fs.existsSync(path) && Fs.statSync(path).isDirectory();
}

/**
 * @param {string} path
 */
export function FileExists(path) {
	return Fs.existsSync(path) && Fs.statSync(path).isFile();
}

/**
 * @param {string} input 
 * @returns {string}
 */
export function ExtractAudioBas464(input) {
	return input.split(',')[1];
}

export { default as _f } from 'lodash/fp.js';
export { default as _ } from 'lodash';

export * as Csv from 'csv';
export * as Yaml from 'yaml';