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

export * as Path from 'path';
export * as Fsp from 'fs/promises';
export * as Fs from 'fs';
export * as Yaml from 'yaml';

/**
 * @param {string} input 
 * @returns {string}
 */
export function ExtractAudioBas464(input) {
	return input.split(',')[1];
}