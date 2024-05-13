// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface IBaluniV1AgentFactory {
  function getAgentAddress(address user) external view returns (address);

  function getOrCreateAgent(address user) external returns (address);
}