// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVotesUpgradeable {
    function getVotes(address owner) external view returns (uint256);

    function totalSupply() external view returns (uint256);
}
