项目简介：
NFT Auction Marketplace based on Hardhat.
Supports:
- ERC721 NFT auctions
- ETH bidding
- ERC20 bidding
- Chainlink price feeds
- UUPS upgradeability

技术栈：
- Solidity
- Hardhat
- OpenZeppelin
- Chainlink
- Ethers.js

功能：
- Mint NFT
- Create Auction
- Bid with ETH
- Bid with ERC20
- Convert bid price to USD
- Upgrade contract through UUPS

测试覆盖率：
- npx hardhat coverage

部署步骤：
npm install
npx hardhat compile
npx hardhat test
npx hardhat run scripts/deploy.js --network sepolia

sepolia部署地址：0x11c0a4eD709f94F0392781eCbD5b06BE87116F25
