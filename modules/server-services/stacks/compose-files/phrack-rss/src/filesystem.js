const fs = require('fs');
const util = require('util');
const mkdirp = require('mkdirp');
const { DATA_DIR } = require('./config');

mkdirp.sync(DATA_DIR);

exports.existsSync = fs.existsSync;
exports.readFileSync = fs.readFileSync;
exports.readFile = util.promisify(fs.readFile);
exports.writeFileSync = fs.writeFileSync;
exports.writeFile = util.promisify(fs.writeFile);
