// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC4973/ERC4973.sol";
import "./utils/ERC4973Votes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract DGID is
    Initializable,
    AccessControlUpgradeable,
    ERC4973,
    ERC4973Votes
{
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    // soon
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    mapping(address => uint256) private addrToTokenId;

    function initialize(
        string memory name,
        string memory symbol,
        string memory version
    ) public initializer {
        __ERC4973_init(name, symbol, version);
        __AccessControl_init();
    }

    function __initialize_unchained(address _admin) internal initializer {
        _setupRole(GOVERNANCE_ROLE, _admin);
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
    }

    function _setURI(uint256 tokenId, string memory customURI) external {
        require(
            hasRole(GOVERNANCE_ROLE, msg.sender),
            "Not authorized to set URI"
        );
        _setTokenURI(tokenId, customURI);
    }

    function setGovernanceValue(
        address to,
        uint16 governanceIncrement
    ) external {
        require(
            hasRole(GOVERNANCE_ROLE, msg.sender),
            "Not authorized to set governance"
        );
        _setGovernanceValue(to, governanceIncrement);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC4973, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function mint(
        address to,
        string memory tokenURI
    ) external returns (uint256) {
        require(hasRole(GOVERNANCE_ROLE, msg.sender), "Not authorized to mint");
        tokenIds.increment();
        addrToTokenId[to] = tokenIds.current();
        uint256 newItemId = tokenIds.current();
        _mint(to, newItemId, tokenURI);
        return newItemId;
    }

    function viewGovernance(
        address owner
    ) external view virtual returns (uint16) {
        return _governanceValue(owner);
    }

    function viewTotalGovernance() external view virtual returns (uint256) {
        return _getTotalGovernance();
    }

    function viewTokenID(address owner) external view returns (uint256) {
        return addrToTokenId[owner];
    }

    function burn(uint256 tokenId) external {
        require(hasRole(GOVERNANCE_ROLE, msg.sender), "Not authorized to burn");
        _burn(tokenId);
    }
}
