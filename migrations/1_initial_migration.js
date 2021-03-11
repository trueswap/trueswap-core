const TronWeb = require('tronweb')
const HttpProvider = TronWeb.providers.HttpProvider;
const fullNode = new HttpProvider("https://api.shasta.trongrid.io");
const solidityNode = new HttpProvider("https://api.shasta.trongrid.io");
const eventServer = new HttpProvider("https://api.shasta.trongrid.io");
const privateKey = "";
const tronWeb = new TronWeb(fullNode,solidityNode,eventServer,privateKey);
const TrueswapFactory = artifacts.require('TrueswapFactory')
// const TrueswapERC20 = artifacts.require('TrueswapERC20')
// const TrueswapPair = artifacts.require('TrueswapPair')

module.exports = async function(deployer) {
  const accounts_root = await tronWeb.defaultAddress.base58
  const feeToSetter = accounts_root
  console.log(`feeToSetter = ${feeToSetter}`)
  const Factory = await deployer.deploy(TrueswapFactory, ...[feeToSetter])
  // console.log(Factory.address)
  // const TRC20 = await deployer.deploy(TrueswapERC20)
  // console.log(TRC20.address)
  // const Pair = await deployer.deploy(TrueswapPair)
};
