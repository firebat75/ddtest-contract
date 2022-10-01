var MockERC20 = artifacts.require("MockERC20");

module.exports = function (deployer) {
    // deployment steps
    deployer.deploy(MockERC20);
};