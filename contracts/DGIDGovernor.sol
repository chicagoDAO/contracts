// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts-upgradeable/governance/GovernorUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorCountingSimpleUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorSettingsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {IVotesUpgradeable} from "./utils/IVotesUpgradeable.sol";
import {GovernorVotesUpgradeable} from "./utils/GovernorVotesUpgradeable.sol";
import {GovernorVotesQuorumFractionUpgradeable} from "./utils/GovernorVotesQuorumFractionUpgradeable.sol";

import {ERC4973} from "./ERC4973/ERC4973.sol";

contract DGIDGovernor is
    Initializable,
    GovernorUpgradeable,
    GovernorCountingSimpleUpgradeable,
    GovernorVotesUpgradeable,
    GovernorSettingsUpgradeable,
    GovernorVotesQuorumFractionUpgradeable
{
    function initialize(
        string memory name,
        IVotesUpgradeable _token
    ) public initializer {
        __Governor_init(name);
        __GovernorVotes_init(_token);
        __GovernorSettings_init(0, 45818, 100);
        __GovernorVotesQuorumFraction_init(67);
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function votingDelay()
        public
        view
        override(IGovernorUpgradeable, GovernorSettingsUpgradeable)
        returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
        public
        view
        override(IGovernorUpgradeable, GovernorSettingsUpgradeable)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    function proposalThreshold()
        public
        view
        override(GovernorUpgradeable, GovernorSettingsUpgradeable)
        returns (uint256)
    {
        return super.proposalThreshold();
    }

    function quorum(
        uint256 blockNumber
    )
        public
        view
        override(IGovernorUpgradeable, GovernorVotesQuorumFractionUpgradeable)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function getVotes(
        address account,
        uint256 blockNumber
    ) public view override returns (uint256) {
        return super.getVotes(account, blockNumber);
    }
}
