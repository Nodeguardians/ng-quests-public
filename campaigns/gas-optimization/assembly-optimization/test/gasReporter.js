const Table = require("cli-table");

exports.logTable = function(gasConsumed, { padding = 0}) {

  const gasReport = new Table({
    style: {head: ['cyan']},
    head: ['Test', 'Gas Consumed'],
    colWidths: [19, 15]
  });

  totalGas = 0;

  for (let i = 0; i < gasConsumed.length; i++) {
    gasReport.push([`Public Test ${i + 1}`, gasConsumed[i]]);
    totalGas += gasConsumed[i].toNumber();
  }

  gasReport.push(["  --TOTAL GAS--  ", totalGas])
  const pad = " ".repeat(padding);

  console.log(pad + gasReport.toString().replace(/\n/g, `\n${pad}`));

};
