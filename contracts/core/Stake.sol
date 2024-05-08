// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Stake {
	IERC20 public immutable stakingToken;
	IERC20 public immutable rewardToken;

	mapping(address => uint256) public balanceStakedOf;
	uint256 public supply;

	uint256 private constant MULTIPLIER = 1e18;
	uint256 private rewardIndex;
	mapping(address => uint256) private rewardIndexOf;
	mapping(address => uint256) private earned;

	constructor(address _stakingToken, address _rewardToken) {
		stakingToken = IERC20(_stakingToken);
		rewardToken = IERC20(_rewardToken);
	}

	function updateRewardIndex(uint256 reward) public {
		//rewardToken.transferFrom(msg.sender, address(this), reward);
		rewardIndex += (reward * MULTIPLIER) / supply;
	}

	function _calculateRewards(address account) private view returns (uint256) {
		uint256 shares = balanceStakedOf[account];
		return (shares * (rewardIndex - rewardIndexOf[account])) / MULTIPLIER;
	}

	function calculateRewardsEarned(
		address account
	) external view returns (uint256) {
		return earned[account] + _calculateRewards(account);
	}

	function _updateRewards(address account) internal {
		earned[account] += _calculateRewards(account);
		rewardIndexOf[account] = rewardIndex;
	}

	function stake(uint256 amount) external {
		_updateRewards(msg.sender);

		balanceStakedOf[msg.sender] += amount;
		supply += amount;

		stakingToken.transferFrom(msg.sender, address(this), amount);
	}

	function unstake(uint256 amount) external {
		_updateRewards(msg.sender);

		balanceStakedOf[msg.sender] -= amount;
		supply -= amount;

		stakingToken.transfer(msg.sender, amount);
	}

	function claim() external returns (uint256) {
		_updateRewards(msg.sender);

		uint256 reward = earned[msg.sender];
		if (reward > 0) {
			earned[msg.sender] = 0;
			rewardToken.transfer(msg.sender, reward);
		}

		return reward;
	}

	function claimTo(address _to) public returns (uint256) {
		_updateRewards(_to);

		uint256 reward = earned[msg.sender];
		if (reward > 0) {
			earned[msg.sender] = 0;
			rewardToken.transfer(_to, reward);
		}

		return reward;
	}
}
