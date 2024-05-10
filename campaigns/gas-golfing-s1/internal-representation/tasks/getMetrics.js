const { measureChallenge } = require("../test/hardhat/testsuites/testChallenge");
const { history, metrics } = require("@node-guardians/ng-quests-helpers");

async function main() {

  // Measure the gas consumption of each PUBLIC test input
  // True ranks are computed against the PRIVATE test inputs
  let testInputs;
  try {
    testInputs = require("../test/data/private/moreInputs.json");
  } catch (e) {
    testInputs = require("../test/data/inputs.json");
  }

  const gasConsumption = await measureChallenge(testInputs);

  // Measure the bytecode size of the contract
  const artifact = require("../artifacts/contracts/Challenge.sol/Challenge.json");
  const bytecode = artifact.deployedBytecode;
  const bytecodeSize = (bytecode.length - 2) / 2;

  // Save the metrics to the history file
  const _history = await history.getHistory();
  let metricEntries = [
    {
      metric: metrics.GAS_CONSUMPTION,
      value: gasConsumption,
    },
    {
      metric: metrics.BYTECODE_SIZE,
      value: bytecodeSize,
    },
  ];

  history.updateHistory(_history, metricEntries);

  await history.saveHistory(_history);
  await metrics.saveMetrics(metricEntries);

  process.exit(0);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
