// SPDX-License-Identifier: GNU AGPLv3
pragma solidity 0.8.25;

/**
 * @title IBaluniV1Registry
 * @dev Interface for the BaluniV1Registry contract.
 */
interface IBaluniV1Registry {
    function setUniswapFactory(address _uniswapFactory) external;

    function setUniswapRouter(address _uniswapRouter) external;

    function setBaluniAgentFactory(address _baluniAgentFactory) external;

    function setBaluniPoolPeriphery(address _baluniPoolPeriphery) external;

    function setBaluniSwapper(address _baluniSwapper) external;

    function setBaluniOracle(address _baluniOracle) external;

    function setBaluniPoolFactory(address _baluniPoolFactory) external;

    function setBaluniRebalancer(address _baluniRebalancer) external;

    function setBaluniRouter(address _baluniRouter) external;

    function setBaluniRegistry(address _baluniRegistry) external;

    function setWNATIVE(address _WNATIVE) external;

    function setUSDC(address _USDC) external;

    function setTreasury(address _treasury) external;

    function set1inchSpotAgg(address __1inchSpotAgg) external;

    function setBPS_FEE(uint256 __BPS_FEE) external;

    function getUniswapFactory() external view returns (address);

    function getUniswapRouter() external view returns (address);

    function getBaluniSwapper() external view returns (address);

    function getBaluniOracle() external view returns (address);

    function getBaluniAgentFactory() external view returns (address);

    function getBaluniPoolPeriphery() external view returns (address);

    function getBaluniPoolFactory() external view returns (address);

    function getBaluniRebalancer() external view returns (address);

    function getBaluniRouter() external view returns (address);

    function getBaluniRegistry() external view returns (address);

    function getWNATIVE() external view returns (address);

    function getUSDC() external view returns (address);

    function get1inchSpotAgg() external view returns (address);

    function getBPS_FEE() external view returns (uint256);

    function getMAX_BPS_FEE() external view returns (uint256);

    function getBPS_BASE() external view returns (uint256);

    function getTreasury() external view returns (address);

    function setStaticOracle(address _staticOracle) external;

    function getStaticOracle() external view returns (address);
}