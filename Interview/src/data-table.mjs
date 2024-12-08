import { _f, _ } from './utilities.mjs';

export class DataTable {
	constructor(entries) {
		if(entries)
			this.AddColumns(entries);
	}

	columns = {};

	/**
	 * @param {string} name
	 * @param {any} defaultValue
	 */
	AddColumn(name, defaultValue = '') {
		this.columns[name] = defaultValue;
	}

	RemoveColumn(name) {
		delete this.columns[name];
		for(const row of this.rows)
			delete row[name];
	}

	AddColumns(entries) {
		for(const [k, v] of Object.entries(entries))
			this.AddColumn(k, v);
	}

	SortColumns(predicate = (a, b) => a < b) {
		this.columns = _f.pipe(
			_f.toPairs,
			x => x.sort((a, b) => predicate(a[0], b[0])),
			_f.fromPairs
		)(this.columns);
	}

	rows = [];

	AddRow(row) {
		this.rows.push(row);

		for(const [k, v] of Object.entries(row)) {
			if(k in this.columns)
				continue;
			this.AddColumn(k);
		}
	}

	Get(colname, row) {
		if(colname in row)
			return row[colname];
		else
			return this.columns[colname];
	}

	/** @readonly */
	AsArray() {
		const array = [];

		const header = Array.from(Object.keys(this.columns));
		array.push(header);

		for(const row of this.rows) {
			_f.pipe(
				_f.map(colname => this.Get(colname, row)),
				Array.prototype.push.bind(array)
			)(header);
		}

		return array;
	}
}