import Web3 from 'web3';

var fs = require('fs');
var jsonFile = "abi/Terms.abi";
var parsed= JSON.parse(fs.readFileSync(jsonFile));
var contract_abi = parsed.abi;

const web3 = new Web3(window.ethereum);
await window.ethereum.enable();

const NameContract = web3.eth.Contract(contract_abi, contract_address);

