var StorageChain  = artifacts.require('StorageSupplyChain');
var PharmaChain = artifacts.require('PharmaSupplyChain');



module.exports = function(deployer) {
    deployer.deploy(StorageChain).then(function() {
        return deployer.deploy(PharmaChain, StorageChain.address);
      });
  };


