// SPDX-License-Identifier: GNU AGPLv3
pragma solidity 0.8.25;
/**
 *  __                  __                      __
 * /  |                /  |                    /  |
 * $$ |____    ______  $$ | __    __  _______  $$/
 * $$      \  /      \ $$ |/  |  /  |/       \ /  |
 * $$$$$$$  | $$$$$$  |$$ |$$ |  $$ |$$$$$$$  |$$ |
 * $$ |  $$ | /    $$ |$$ |$$ |  $$ |$$ |  $$ |$$ |
 * $$ |__$$ |/$$$$$$$ |$$ |$$ \__$$ |$$ |  $$ |$$ |
 * $$    $$/ $$    $$ |$$ |$$    $$/ $$ |  $$ |$$ |
 * $$$$$$$/   $$$$$$$/ $$/  $$$$$$/  $$/   $$/ $$/
 *
 *
 *                  ,-""""-.
 *                ,'      _ `.
 *               /       )_)  \
 *              :              :
 *              \              /
 *               \            /
 *                `.        ,'
 *                  `.    ,'
 *                    `.,'
 *                     /\`.   ,-._
 *                         `-'    \__
 *                              .
 *               s                \
 *                                \\
 *                                 \\
 *                                  >\/7
 *                              _.-(6'  \
 *                             (=___._/` \
 *                                  )  \ |
 *                                 /   / |
 *                                /    > /
 *                               j    < _\
 *                           _.-' :      ``.
 *                           \ r=._\        `.
 */
import '@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';
import './libs/AddressUpgradeable.sol';

interface IRouter {
  function getBpsFee() external view returns (uint256);
}

/**
 * @title BaluniV1Agent
 * @dev This contract represents the BaluniV1Agent contract.
 */
contract BaluniV1Agent {
  using AddressUpgradeable for address payable;

  address public owner;
  address private router;
  address private factory;
  address internal constant _NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  IERC20Metadata internal constant WNATIVE = IERC20Metadata(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);

  uint256 internal constant _DUST = 10;
  uint256 internal constant _BPS_BASE = 10000;

  struct Call {
    address to;
    uint256 value;
    bytes data;
  }

  constructor(address _factory) {
    factory = _factory;
  }

  /**
   * @dev Initializes the contract with the specified owner and router addresses.
   * @param _owner The address of the contract owner.
   * @param _router The address of the router contract.
   */
  function initialize(address _owner, address _router) external {
    require(owner == address(0), 'Already initialized');
    owner = _owner;
    router = _router;
    factory = msg.sender;
  }

  /**
   * @dev Modifier that allows a function to be called only by the router.
   * @notice This modifier checks if the caller is the router contract.
   * @notice If the caller is not the router, the function call will revert.
   */
  modifier onlyRouter() {
    require(msg.sender == router, 'Callable only by the router');
    _;
  }

  /**
   * @dev Executes a batch of calls and performs token operations.
   * @param calls An array of Call structs representing the calls to be executed.
   * @param tokensReturn An array of token addresses to return after the batch call.
   * @notice Only the router contract is allowed to execute this function.
   */
  function execute(Call[] memory calls, address[] memory tokensReturn) external onlyRouter {
    for (uint i = 0; i < calls.length; i++) {
      (bool success, ) = calls[i].to.call{value: calls[i].value}(calls[i].data);
      require(success, 'Batch call failed');
    }
    _chargeFees(tokensReturn);
    _returnTokens(tokensReturn);
  }

  /**
   * @dev Returns the address of the router contract.
   * @return The address of the router contract.
   */
  function getRouter() public view returns (address) {
    return router;
  }

  /**
   * @dev Returns the address of the factory contract.
   * @return The address of the factory contract.
   */
  function getFactory() public view returns (address) {
    return factory;
  }

  /**
   * @dev Internal function to charge fees for the tokens returned.
   * @param tokensReturn The array of tokens to charge fees for.
   */
  function _chargeFees(address[] memory tokensReturn) internal {
    uint256 amount;
    uint256 bpsFee = IRouter(router).getBpsFee();
    for (uint256 i = 0; i < tokensReturn.length; i++) {
      address token = tokensReturn[i];
      if (token == _NATIVE) {
        amount = (address(this).balance * bpsFee) / _BPS_BASE;
        payable(router).sendValue(amount);
      } else {
        uint256 balance = IERC20Metadata(token).balanceOf(address(this));
        amount = (balance * bpsFee) / _BPS_BASE;
        IERC20Metadata(token).transfer(router, amount);
      }
    }
  }

  /**
   * @dev Internal function to return tokens to the owner.
   * @param tokensReturn The array of tokens to return.
   */
  function _returnTokens(address[] memory tokensReturn) internal {
    uint256 tokensReturnLength = tokensReturn.length;
    if (tokensReturnLength > 0) {
      for (uint256 i; i < tokensReturnLength; ) {
        address token = tokensReturn[i];
        if (token == _NATIVE) {
          if (address(this).balance > 0) {
            payable(owner).sendValue(address(this).balance);
          }
        } else {
          uint256 balance = IERC20Metadata(token).balanceOf(address(this));
          if (balance > _DUST) {
            IERC20Metadata(token).transfer(owner, balance);
          }
        }

        unchecked {
          ++i;
        }
      }
    }
  }
}
