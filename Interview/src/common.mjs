import * as Path from 'path';
import * as Url from 'url';

const thisScriptPath = Url.fileURLToPath(import.meta.url);
export const rootDir = Path.resolve(Path.dirname(thisScriptPath), '..');

export const dataDir = Path.resolve(rootDir, 'data');
export const resultsDir = Path.resolve(rootDir, 'results');