// SPDX-License-Identifier: GNU AGPLv3
pragma solidity 0.8.25;

import './BaluniV1Pool.sol';

contract BaluniV1PoolFactory {
  // Array to keep track of all pools created
  BaluniV1Pool[] public allPools;

  // Mapping to keep track of all pools for a specific pair of assets
  mapping(address => mapping(address => BaluniV1Pool)) public getPool;

  // Event to emit when a new pool is created
  event PoolCreated(
    address indexed pool,
    address indexed asset1,
    address indexed asset2,
    address oracle,
    address rebalancer
  );

  function createPool(address oracle, address rebalancer, address asset1, address asset2) external returns (address) {
    require(oracle != address(0), 'Oracle address cannot be zero');
    require(rebalancer != address(0), 'Rebalancer address cannot be zero');
    require(asset1 != address(0) && asset2 != address(0), 'Asset addresses cannot be zero');
    require(asset1 != asset2, 'Assets cannot be the same');

    // Check if a pool already exists for this pair of assets
    require(address(getPool[asset1][asset2]) == address(0), 'Pool already exists for this pair');

    // Create a new pool instance
    BaluniV1Pool newPool = new BaluniV1Pool();
    newPool.initialize(oracle, rebalancer, asset1, asset2);

    // Update the pool tracking
    allPools.push(newPool);
    getPool[asset1][asset2] = newPool;
    getPool[asset2][asset1] = newPool; // To ensure both asset1-asset2 and asset2-asset1 point to the same pool

    emit PoolCreated(address(newPool), asset1, asset2, oracle, rebalancer);

    return address(newPool);
  }

  function getAllPools() external view returns (BaluniV1Pool[] memory) {
    return allPools;
  }

  function getPoolsCount() external view returns (uint256) {
    return allPools.length;
  }

  function getPoolAssets(address poolAddress) external view returns (address, address) {
    BaluniV1Pool pool = BaluniV1Pool(poolAddress);
    return (address(pool.asset1()), address(pool.asset2()));
  }
}
