// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.8;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import {EIP712Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";

import {ERC165} from "./ERC165.sol";

import {IERC721Metadata} from "./interfaces/IERC721Metadata.sol";
import {IERC4973} from "./interfaces/IERC4973.sol";

bytes32 constant AGREEMENT_HASH = keccak256(
    "Agreement(address active,address passive,string tokenURI)"
);

contract ERC4973 is
    Initializable,
    EIP712Upgradeable,
    ERC165,
    IERC721Metadata,
    IERC4973
{
    using BitMaps for BitMaps.BitMap;
    BitMaps.BitMap private _usedHashes;

    string private _name;
    string private _symbol;
    uint256 private _totalGovernance;

    mapping(uint256 => address) private _owners;
    mapping(uint256 => string) private _tokenURIs;
    mapping(address => uint16) private _governanceValues;
    mapping(address => uint256) private _balances;

    function __ERC4973_init(
        string memory name_,
        string memory symbol_,
        string memory version
    ) internal onlyInitializing {
        __ERC4973_init_unchained(name_, symbol_, version);
    }

    function __ERC4973_init_unchained(
        string memory name_,
        string memory symbol_,
        string memory version
    ) internal onlyInitializing {
        __EIP712_init(name_, version);
        _name = name_;
        _symbol = symbol_;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC4973).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(_exists(tokenId), "tokenURI: token doesn't exist");
        return _tokenURIs[tokenId];
    }

    function _governanceValue(
        address owner
    ) internal view virtual returns (uint16) {
        require(
            owner != address(0),
            "governanceValue: address zero is not a valid owner"
        );
        return _governanceValues[owner];
    }

    function unequip(uint256 tokenId) public virtual override {
        require(
            msg.sender == ownerOf(tokenId),
            "unequip: sender must be owner"
        );
        _usedHashes.unset(tokenId);
        _burn(tokenId);
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal virtual {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _setGovernanceValue(
        address owner,
        uint16 governanceIncrement
    ) internal virtual {
        require(
            owner != address(0),
            "setGovernanceValue: address zero is not a valid owner"
        );
        _totalGovernance = _totalGovernance + governanceIncrement;

        _governanceValues[owner] =
            _governanceValues[owner] +
            governanceIncrement;
    }

    function _getTotalGovernance() internal view virtual returns (uint256) {
        return _totalGovernance;
    }

    function balanceOf(
        address owner
    ) public view virtual override returns (uint256) {
        require(
            owner != address(0),
            "balanceOf: address zero is not a valid owner"
        );
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ownerOf: token doesn't exist");
        return owner;
    }

    function give(
        address to,
        string calldata uri,
        bytes calldata signature
    ) external virtual returns (uint256) {
        require(msg.sender != to, "give: cannot give from self");
        uint256 tokenId = _safeCheckAgreement(msg.sender, to, uri, signature);
        _mint(to, tokenId, uri);
        _usedHashes.set(tokenId);
        return tokenId;
    }

    function take(
        address from,
        string calldata uri,
        bytes calldata signature
    ) external virtual returns (uint256) {
        require(msg.sender != from, "take: cannot take from self");
        uint256 tokenId = _safeCheckAgreement(msg.sender, from, uri, signature);
        _mint(msg.sender, tokenId, uri);
        _usedHashes.set(tokenId);
        return tokenId;
    }

    function _safeCheckAgreement(
        address active,
        address passive,
        string calldata uri,
        bytes calldata signature
    ) internal virtual returns (uint256) {
        bytes32 hash = _getHash(active, passive, uri);
        uint256 tokenId = uint256(hash);

        require(
            SignatureChecker.isValidSignatureNow(passive, hash, signature),
            "_safeCheckAgreement: invalid signature"
        );
        require(!_usedHashes.get(tokenId), "_safeCheckAgreement: already used");
        return tokenId;
    }

    function _getHash(
        address active,
        address passive,
        string calldata uri
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(AGREEMENT_HASH, active, passive, keccak256(bytes(uri)))
        );
        return _hashTypedDataV4(structHash);
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _mint(
        address to,
        uint256 tokenId,
        string memory uri
    ) internal virtual returns (uint256) {
        require(!_exists(tokenId), "mint: tokenID exists");
        // require(
        //     !_exists(_governanceValues[to]),
        //     "mint: Adress already holds this"
        // );
        _balances[to] += 1;
        _owners[tokenId] = to;
        _tokenURIs[tokenId] = uri;
        _governanceValues[to] = 1;
        _totalGovernance = _totalGovernance + 1;
        emit Transfer(address(0), to, tokenId);
        return tokenId;
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        _balances[owner] -= 1;
        _totalGovernance -= _governanceValues[owner];
        delete _owners[tokenId];
        delete _tokenURIs[tokenId];
        delete _governanceValues[owner];

        emit Transfer(owner, address(0), tokenId);
    }
}
