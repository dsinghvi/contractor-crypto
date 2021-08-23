const fs = require('fs'); // Built-in dependency for file streaming.
const solc = require('solc'); // Our Solidity compiler

const content = fs.readFileSync('contracts/Terms.sol', 'utf-8'); // Read the file...

// Format the input for solc compiler:
const input = {
  language: 'Solidity',
  sources: {
    'contracts/Terms.sol': {
      content, // The imported content
    }
  },
  settings: {
    outputSelection: {
      '*': {
        '*': ['*']
      }
    }
  }
};

const output = JSON.parse(solc.compile(JSON.stringify(input)));

console.log("Logging contract output")
console.log(output); 

console.log("Writing abi for contracts")
for (var contractName in output.contracts['contracts/Terms.sol']) {
    var contractAbi = JSON.stringify(output.contracts['contracts/Terms.sol'][contractName].abi, null, 2)
    fs.writeFile('abi/' + contractName + ".abi", contractAbi, err => {
        if (err) {
          console.error(err)
          return
        }
        //file written successfully
      })
  }