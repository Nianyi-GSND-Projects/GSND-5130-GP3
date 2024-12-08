import { resultsDir } from './common.mjs';
import { Path, Fsp, Yaml, DirectoryExists, _f, _ } from './utilities.mjs';

Main().catch(err => {
	console.error(err);
});

async function Main() {
	if(!DirectoryExists(resultsDir))
		throw new ReferenceError('No reference directory found.');

	const resultFileNames = (await Fsp.readdir(resultsDir))
		.filter(name => name.endsWith('.yml'));
	for(const resultFileName of resultFileNames) {
		HandleResultFile(Path.resolve(resultsDir, resultFileName));
	}
}

const encoding = 'utf-8';
async function HandleResultFile(resultFilePath) {
	const readBuffer = await Fsp.readFile(resultFilePath);
	const result = Yaml.parse(readBuffer.toString(encoding));
	ProcessResult(result);
	Fsp.writeFile(resultFilePath, Yaml.stringify(result), { encoding });
}

function ProcessResult(result) {
	// Clear deprecated fields.
	delete result['syllableCount'];
	delete result['accent'];
	delete result['realization'];
}