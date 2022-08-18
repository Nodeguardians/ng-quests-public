const parser = require("@solidity-parser/parser");
const chai = require("chai");
const chaiExclude = require('chai-exclude');

chai.use(chaiExclude)

const CONTRACT_DEFINITION_MODIFIED = "Contract top level structure was modified";
const CONTRACT_STATE_MODIFIED = "Contract state variables were modified";
const FUNCTION_DEFINITION_MODIFIED = "Function definition was modified";
const FUNCTION_BODY_STRUCTURE_MODIFIED = "Function template body structure was modified";

function toAst(fileContent) {
  return parser.parse(fileContent);
}

function getContractDefinitionAST(ast) {
  return ast.children.find((children) => children.type == "ContractDefinition");
}

function _getFunctionDefinitionAST(astContract, functionName) {
  switch (functionName) {
    case "constructor":
      return astContract.subNodes.find(
        (x) => x.type == "FunctionDefinition" && x.isConstructor == true
      );
    case "fallback":
      return astContract.subNodes.find(
        (x) => x.type == "FunctionDefinition" && x.isFallback == true
      );
    case "receive":
      return astContract.subNodes.find(
        (x) => x.type == "FunctionDefinition" && x.isReceiveEther == true
      );
    default:
      return astContract.subNodes.find(
        (x) => x.type == "FunctionDefinition" && x.name == functionName
      );
  }
}

function getFunctionDefinitionAST(ast, functionName) {
  const astContract = getContractDefinitionAST(ast);

  if (astContract == undefined) {
    return undefined;
  }

  return _getFunctionDefinitionAST(astContract, functionName);
}

function getAllFunctionDefinitionAST(ast) {
  const astContract = getContractDefinitionAST(ast);
  
  return astContract.subNodes.filter((x) => x.type == "FunctionDefinition");
}

function compareContractsDefinitionAST(contractA_ast, contractB_ast) {
  for (let i = 0; i < contractA_ast.subNodes.length; i++) {
    subNodeA = contractA_ast.subNodes[i];
    subNodeB = contractB_ast.subNodes[i];
    chai.expect(subNodeA, CONTRACT_DEFINITION_MODIFIED).excluding(["operations", "body"]).to.deep.equal(subNodeB);
  }

  return true;
}

function compareContractsStateAST(contractA_ast, contractB_ast) {
    stateA = contractA_ast.subNodes.filter(x => x.type == "StateVariableDeclaration")
    stateB = contractB_ast.subNodes.filter(x => x.type == "StateVariableDeclaration")

    chai.expect(stateA, CONTRACT_STATE_MODIFIED).to.deep.equal(stateB);
}

function compareFunctionsDefinitionAST(functionA_ast, functionB_ast) {
  chai.expect(functionA_ast, FUNCTION_DEFINITION_MODIFIED).excluding(["operations", "body"]).to.deep.equal(functionB_ast)
}

function compareFunctionsBodyAST(functionA_ast, functionB_ast) {
  chai.expect(functionA_ast.body.type, FUNCTION_BODY_STRUCTURE_MODIFIED).to.deep.equal(functionB_ast.body.type)
  chai.expect(functionA_ast.body.statements.length, FUNCTION_BODY_STRUCTURE_MODIFIED).to.equal(functionB_ast.body.statements.length)

  for (let i = 0; i < functionA_ast.body.statements.length; i++) {
      chai.expect(functionA_ast.body.statements[i].type, FUNCTION_BODY_STRUCTURE_MODIFIED).to.deep.equal(functionB_ast.body.statements[i].type)
  }
}

module.exports.toAst = toAst;
module.exports.getFunctionDefinitionAST = getFunctionDefinitionAST;
module.exports.getAllFunctionDefinitionAST = getAllFunctionDefinitionAST;
module.exports.getContractDefinitionAST = getContractDefinitionAST;
module.exports.compareContractsDefinitionAST = compareContractsDefinitionAST;
module.exports.compareFunctionsDefinitionAST = compareFunctionsDefinitionAST;
module.exports.compareFunctionsBodyAST = compareFunctionsBodyAST;
module.exports.compareContractsStateAST = compareContractsStateAST;
