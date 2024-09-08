// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MydNFT is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    /// @notice ipfs uri of the metadata of 3 images
    string[] IpfsUri = [
        "ipfs://QmbpMPYs9sszz3D4Wr9FpM3T8sGXRQBkEotjJ18tsvqjtx/1.json", 
        "ipfs://QmbpMPYs9sszz3D4Wr9FpM3T8sGXRQBkEotjJ18tsvqjtx/2.json", 
        "ipfs://QmbpMPYs9sszz3D4Wr9FpM3T8sGXRQBkEotjJ18tsvqjtx/3.json"];

    /// @dev keeps track of last timestamp
    uint256 lastTimestamp;
    /// @dev keeps track of time since last timestamp
    uint256 interval;

    /**
     * 
     * @param tokenName name of the token to mint
     * @param tokenSym symbol of the token to mint
     * @param _interval time since last timestamp
     */
    constructor(
        string memory tokenName,
        string memory tokenSym,
        uint _interval
    ) ERC721(tokenName, tokenSym) {
        interval = _interval;
        lastTimestamp = block.timestamp;
    }

    /// 
    /// @param to receiver address of the dNFT
    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, IpfsUri[0]);
    }

    /// 
    /// @param _tokenId token id to change metadata to
    function dynamicNft(uint256 _tokenId) public {
        uint256 currentStage = NftStage(_tokenId);
        // Determine the next stage (loop back to the first stage if the current stage is at its maximum)
        uint256 nextStage = currentStage >= 2 ? 0 : currentStage + 1;

        // Get the URI for the next stage
        string memory newUri = IpfsUri[nextStage];

        // Update the URI
        _setTokenURI(_tokenId, newUri);
    }

    /// 
    /// @param _tokenId token id of the dNFT
    function NftStage(uint256 _tokenId) public view returns (uint256) {
        string memory _uri = tokenURI(_tokenId);
        if (compareStrings(_uri, IpfsUri[0])) {
            return 0;
        }
        if (compareStrings(_uri, IpfsUri[1])) {
            return 1;
        }
        return 2;
    }

    function compareStrings(
        string memory a,
        string memory b
    ) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function checkUpkeep()
        external
        view
        returns (bool upkeepNeeded) // parameter removed: bytes memory performData
    {
        upkeepNeeded = (block.timestamp - lastTimestamp) > interval;
    }

    function performUpkeep() external {
        if ((block.timestamp - lastTimestamp) > interval) {
            lastTimestamp = block.timestamp;
            dynamicNft(0);
        }
    }
}
