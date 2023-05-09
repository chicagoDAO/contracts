// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC4973/ERC4973.sol";
import "./utils/ERC4973Votes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract DGID is Initializable, ERC4973, ERC4973Votes, OwnableUpgradeable {
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    mapping(address => uint256) private addrToTokenId;

    function initialize(
        string memory name,
        string memory symbol,
        string memory version
    ) public initializer {
        __ERC4973_init(name, symbol, version);
    }

    function setURI(uint256 tokenId, string memory customURI) public onlyOwner {
        _setTokenURI(tokenId, customURI);
    }

    function setGovernanceValue(
        address to,
        uint16 governanceIncrement
    ) public onlyOwner {
        _setGovernanceValue(to, governanceIncrement);
    }

    function mint(
        address to,
        string memory tokenURI
    ) public onlyOwner returns (uint256) {
        tokenIds.increment();
        addrToTokenId[to] = tokenIds.current();
        uint256 newItemId = tokenIds.current();
        _mint(to, newItemId, tokenURI);
        return newItemId;
    }

    function viewGovernance(
        address owner
    ) internal view virtual returns (uint16) {
        return _governanceValue(owner);
    }

    function viewTotalGovernance() internal view virtual returns (uint256) {
        return _getTotalGovernance();
    }

    function viewTokenID(address owner) public view returns (uint256) {
        return addrToTokenId[owner];
    }

    function burn(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
    }
}
