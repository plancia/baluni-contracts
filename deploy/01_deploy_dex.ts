/* eslint-disable @typescript-eslint/no-unused-vars */
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers, upgrades } from "hardhat";
import erc20ABI from "../abis/common/ERC20.json";

/**
 * Deploys a contract named "YourContract" using the deployer account and
 * constructor arguments set to the deployer address
 *
 * @param hre HardhatRuntimeEnvironment object.
 */

/// Deploy -----------------------------------------------------------------------
const USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
const WNATIVE = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270";
const USDT = "0xc2132d05d31c914a87c6611c10748aeb04b58e8f";
const WBTC = "0x1bfd67037b42cf73acf2047067bd4f2c47d9bfd6";
const WETH = "0x7ceb23fd6bc0add59e62ac25578270cff1b9f619";

const oldRebalancer = "0x1CC8A760bb5d714E3290a30044c6f4f4cEc01dac";

const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const BaluniV1PoolFactory = await ethers.getContractFactory("BaluniV1PoolFactory");
  const baluniV1PoolFactory = await upgrades.deployProxy(BaluniV1PoolFactory, [], { kind: "uups" });
  const instancePoolFactory = await baluniV1PoolFactory?.waitForDeployment();
  console.log("BaluniV1PoolFactory deployed to:", instancePoolFactory.target);

  // wait 5 second
  await new Promise(resolve => setTimeout(resolve, 5000));

  await instancePoolFactory.createPool(oldRebalancer, [USDT, USDC], [5000, 5000], 500);
  await instancePoolFactory.createPool(oldRebalancer, [WBTC, USDC], [5000, 5000], 500);
  await instancePoolFactory.createPool(oldRebalancer, [WETH, USDC], [5000, 5000], 500);
  await instancePoolFactory.createPool(oldRebalancer, [WNATIVE, USDC], [5000, 5000], 500);

  const BaluniV1PoolPeriphery = await ethers.getContractFactory("BaluniV1PoolPeriphery");
  const baluniV1PoolPeriphery = await upgrades.deployProxy(
    BaluniV1PoolPeriphery,
    [instancePoolFactory.target], // PoolFactory
    {
      kind: "uups",
    },
  );
  const instancePoolPeriphery = await baluniV1PoolPeriphery?.waitForDeployment();
  console.log("BaluniV1PoolPeriphery deployed to:", instancePoolPeriphery.target);
};

export default deployYourContract;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags YourContract
deployYourContract.tags = ["deploy-dex"];
