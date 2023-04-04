'use strict';

const fs = require('fs');
const path = require('path');
const { ast } = require("@ngquests/test-helpers");

/* Recursively gets all files from a given directory. */
async function getFiles(dir) {
  return (await getFilesRecursive(dir))
    .map(file => path.relative(dir, file));
}

async function getFilesRecursive(dir) {

  if (!fs.existsSync(dir)) return [];
  
  const dirents = fs.readdirSync(dir, { withFileTypes: true });

  const files = await Promise.all(dirents.map((dirent) => {
    const res = path.resolve(dir, dirent.name);
    return dirent.isDirectory() ? getFilesRecursive(res) : res;
  }));

  return Array.prototype.concat(...files);

}

/* Compare two files by content. */
function equalFiles(pathA, pathB) {

  const file1 = fs.readFileSync(pathA);
  const file2 = fs.readFileSync(pathB);

  if (file1.length != file2.length) { return false; }

  return file1.equals(file2);

}

/* Get contract definition AST from a given contract */
function getContractDefinition(contractPath) {

  const contractData = fs.readFileSync(contractPath, { encoding: "utf8" });
  return ast.toAst(contractData);

}

module.exports.getFiles = getFiles;
module.exports.equalFiles = equalFiles;
module.exports.getContractDefinition = getContractDefinition;