const Freelancer = artifacts.require("Freelancer");

module.exports = async function (deployer, network, accounts) {
    // Deploy base contract
    await deployer.deploy(Freelancer);

    // We can use async/await here to add dependencies between contract events: 
    // https://www.trufflesuite.com/docs/truffle/getting-started/running-migrations

    // TODO: add proposal phase

    // TODO: add accepted phase

    // TODO: add funded phase

    // TODO: add started phase

    // TODO: add approval phase

}