var Player = artifacts.require("Player");

module.exports = function (deployer) {
    // deployment steps
    deployer.deploy(Player);
};