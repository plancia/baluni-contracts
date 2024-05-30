// SPDX-License-Identifier: GNU AGPLv3
pragma solidity 0.8.25;

import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import './interfaces/IBaluniV1Registry.sol';

contract BaluniV1Registry is Initializable, OwnableUpgradeable, UUPSUpgradeable, IBaluniV1Registry {
    address public uniswapFactory;
    address public uniswapRouter;
    address public baluniAgentFactory;
    address public baluniPoolPeriphery;
    address public baluniPoolFactory;
    address public baluniRebalancer;
    address public baluniRouter;
    address public baluniRegistry;
    address public treasury;
    address public WNATIVE;
    address public USDC;
    address public _1inchSpotAgg;
    uint256 public _MAX_BPS_FEE;
    uint256 public _BPS_FEE;
    uint256 public _BPS_BASE;

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        _MAX_BPS_FEE = 100;
        _BPS_FEE = 30;
        _BPS_BASE = 10000;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function setTreasury(address _treasury) external override onlyOwner {
        treasury = _treasury;
    }

    function setUniswapFactory(address _uniswapFactory) external override onlyOwner {
        uniswapFactory = _uniswapFactory;
    }

    function setUniswapRouter(address _uniswapRouter) external override onlyOwner {
        uniswapRouter = _uniswapRouter;
    }

    function setBaluniAgentFactory(address _baluniAgentFactory) external override onlyOwner {
        baluniAgentFactory = _baluniAgentFactory;
    }

    function setBaluniPoolPeriphery(address _baluniPoolPeriphery) external override onlyOwner {
        baluniPoolPeriphery = _baluniPoolPeriphery;
    }

    function setBaluniPoolFactory(address _baluniPoolFactory) external override onlyOwner {
        baluniPoolFactory = _baluniPoolFactory;
    }

    function setBaluniRebalancer(address _baluniRebalancer) external override onlyOwner {
        baluniRebalancer = _baluniRebalancer;
    }

    function setBaluniRouter(address _baluniRouter) external override onlyOwner {
        baluniRouter = _baluniRouter;
    }

    function setBaluniRegistry(address _baluniRegistry) external override onlyOwner {
        baluniRegistry = _baluniRegistry;
    }

    function setWNATIVE(address _WNATIVE) external override onlyOwner {
        WNATIVE = _WNATIVE;
    }

    function setUSDC(address _USDC) external override onlyOwner {
        USDC = _USDC;
    }

    function set1inchSpotAgg(address __1inchSpotAgg) external override onlyOwner {
        _1inchSpotAgg = __1inchSpotAgg;
    }

    function setBPS_FEE(uint256 __BPS_FEE) external override onlyOwner {
        _BPS_FEE = __BPS_FEE;
    }

    function getUniswapFactory() external view override returns (address) {
        return uniswapFactory;
    }

    function getUniswapRouter() external view override returns (address) {
        return uniswapRouter;
    }

    function getBaluniAgentFactory() external view override returns (address) {
        return baluniAgentFactory;
    }

    function getBaluniPoolPeriphery() external view override returns (address) {
        return baluniPoolPeriphery;
    }

    function getBaluniPoolFactory() external view override returns (address) {
        return baluniPoolFactory;
    }

    function getBaluniRebalancer() external view override returns (address) {
        return baluniRebalancer;
    }

    function getBaluniRouter() external view override returns (address) {
        return baluniRouter;
    }

    function getBaluniRegistry() external view override returns (address) {
        return baluniRegistry;
    }

    function getWNATIVE() external view override returns (address) {
        return WNATIVE;
    }

    function getUSDC() external view override returns (address) {
        return USDC;
    }

    function get1inchSpotAgg() external view override returns (address) {
        return _1inchSpotAgg;
    }

    function getBPS_FEE() external view override returns (uint256) {
        return _BPS_FEE;
    }

    function getMAX_BPS_FEE() external view override returns (uint256) {
        return _MAX_BPS_FEE;
    }

    function getBPS_BASE() external view override returns (uint256) {
        return _BPS_BASE;
    }

    function getTreasury() external view override returns (address) {
        return treasury;
    }
}
