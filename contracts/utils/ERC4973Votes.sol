// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ERC4973} from "../ERC4973/ERC4973.sol";
import {IVotesUpgradeable} from "./IVotesUpgradeable.sol";

abstract contract ERC4973Votes is ERC4973, IVotesUpgradeable {
    function getVotes(address owner) external view virtual returns (uint256) {
        return _governanceValue(owner);
    }

    function totalSupply() external view virtual override returns (uint256) {
        return _getTotalGovernance();
    }
}
