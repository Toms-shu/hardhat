// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

// contract AuctionMarket {
//           struct Auction {
//                     address seller;
//                     address nftAddress;
//                     uint256 tokenId;
//                     uint256 endTime;
//                     uint256 highestBid;
//                     address highestBidder;
//                     bool ended;
//           }

//           uint256 public auctionCounter;
//           mapping(uint256=>Auction) public auctions;

//           function createAuction(
//                     address nftAddress,
//                     uint256 tokenId,
//                     uint256 duration
//           ) 
//                     public
//           {
//                     IERC721(nftAddress).transferFrom(
//                               msg.sender,
//                               address(this),
//                               tokenId);
                    
//                     auctions[auctionCounter] = Auction({
//                               seller: msg.sender,
//                               nftAddress: nftAddress,
//                               tokenId: tokenId,
//                               endTime: block.timestamp + duration,
//                               highestBid: 0,
//                               highestBidder: address(0),
//                               ended: false
//                     });
                    
//                     auctionCounter++;


//           }

//           function bid(uint256 auctionId) public payable {
//                     Auction storage auction = auctions[auctionId];

//                     require(block.timestamp < auction.endTime, "Auction ended");

//                     require(msg.value > auction.highestBid, "Bid too low");

//                     if (auction.highestBid > 0) {
//                               payable(auction.highestBidder).transfer(auction.highestBid);
//                     }

//                     auction.highestBid = msg.value;
//                     auction.highestBidder = msg.sender;
//           }

//           function endBid(uint256 tokenId) public {
//                     Auction storage auction = auctions[tokenId];

//                     require(block.timestamp >= auction.endTime, "Auction not ended");

//                     require(!auction.ended, "Already ended");

//                     auction.ended = true;

//                     IERC721(auction.nftAddress).transferFrom(
//                               address(this),
//                               auction.highestBidder, 
//                               tokenId);

//           }
// }

// contract AuctionMarket {
//           using PriceConverter for uint256;

//           struct Auction {
//                     address seller;
//                     address nftAddress;
//                     uint256 tokenId;
//                     uint256 endTime;
//                     uint256 highestBid;
//                     uint256 highestBidUsd;
//                     address highestBidder;
//                     bool ended;
//           }

//           uint256 public auctionCounter;
//           mapping(uint256=>Auction) public auctions;
//           AggregatorV3Interface public priceFeed;

//           constructor(address priceFeedAddress){
//                     priceFeed = AggregatorV3Interface(priceFeedAddress);
//           }

//           function createAuction(
//                     address nftAddress,
//                     uint256 tokenId,
//                     uint256 duration
//           ) 
//           public 
//           {
//                     IERC721(nftAddress).transferFrom(
//                               msg.sender, 
//                               address(this), 
//                               tokenId);
                    
//                     auctions[tokenId] = Auction({
//                               seller: msg.sender,
//                               // nftAddress: nftAddress,
//                               tokenId: tokenId,
//                               paymentToken: ,
//                               endTime: block.timestamp + duration,
//                               highestBid: 0,
//                               // highestBidUsd: 0,
//                               highestBidder:address(0),
//                               ended: false
//                     });

//                     auctionCounter++;
//           } 

//           function bid(uint256 tokenId) 
//           public 
//           payable
//           {
//                     Auction storage auction = auctions[tokenId];

//                     require(block.timestamp < auction.endTime, "Auction ended");

//                     require(msg.value > auction.highestBid, "Bid too low");

//                     if (auction.highestBid > 0) {
//                               payable(auction.highestBidder).transfer(auction.highestBid);
//                     }

//                     uint256 usdValue = msg.value.getConversionRate(priceFeed);

//                     auction.highestBid = msg.value;
//                     auction.highestBidUsd = usdValue;
//                     auction.highestBidder = msg.sender;

//           }

//           function endAuction(uint256 auctionId) 
//           public
//           {
//                     Auction storage auction = auctions[auctionId];

//                     require(block.timestamp >= auction.endTime, "Auction ended");
//                     require(!auction.ended, "Already ended");

//                     auction.ended = true;

//                     IERC721(auction.nftAddress).transferFrom(
//                               address(this), 
//                               auction.highestBidder, 
//                               auction.tokenId
//                               );

//                     payable(auction.seller).transfer(auction.highestBid);
//           }

//           function getLatestPrice() 
//           public 
//           view 
//           returns(uint256) 
//           {
//                     return PriceConverter.getPrice(priceFeed);
//           }
// }


contract AuctionMarket {
          using PriceConverter for uint256;

          struct Auction {
                    address seller;
                    address nftAddress;
                    uint256 tokenId;
                    address paymentToken;
                    uint256 endTime;
                    uint256 highestBid;
                    uint256 highestBidUsd;
                    address highestBidder;
                    bool ended;
          }

          uint256 public auctionCounter;
          mapping(uint256=>Auction) public auctions;
          AggregatorV3Interface public priceFeed;
          mapping(address=>AggregatorV3Interface) public tokenPriceFeeds;

          constructor(address priceFeedAddress){
                    priceFeed = AggregatorV3Interface(priceFeedAddress);
          }

          function setTokenPriceFeed(address token, address feed) public {
                    tokenPriceFeeds[token] = AggregatorV3Interface(feed);
          }

          function createAuction(
                    address nftAddress,
                    uint256 tokenId,
                    uint256 duration,
                    address paymentToken
          ) 
          public 
          {
                    IERC721(nftAddress).transferFrom(
                              msg.sender, 
                              address(this), 
                              tokenId);
                    
                    auctions[tokenId] = Auction({
                              seller: msg.sender,
                              nftAddress: nftAddress,
                              tokenId: tokenId,
                              paymentToken: paymentToken,
                              endTime: block.timestamp + duration,
                              highestBid: 0,
                              highestBidUsd: 0,
                              highestBidder:address(0),
                              ended: false
                    });

                    auctionCounter++;
          } 

          function bid(uint256 tokenId, uint256 amount) 
          public 
          payable
          {
                    Auction storage auction = auctions[tokenId];
                    bool isETHAuction = auction.paymentToken == address(0);

                    require(block.timestamp < auction.endTime, "Auction ended");

                    uint256 bidAmount;

                    if (isETHAuction) {
                              bidAmount = msg.value;
                    } else {
                              bidAmount = amount;
                    }
                    require(bidAmount > auction.highestBid, "Bid too low");

                    // 退款
                    if (auction.highestBid > 0) {
                              if (isETHAuction) {
                                        payable(auction.highestBidder).transfer(auction.highestBid);
                              } else {
                                        IERC20(auction.paymentToken).transfer(auction.highestBidder, auction.highestBid);
                              }

                    }

                    // uint256 usdValue = msg.value.getConversionRate(priceFeed);
                    uint256 usdValue;
                    // 转账
                    if (isETHAuction) {
                              // 如果是原生ETH，使用预言机，进行置换等量的USDT，因为ETH在调用函数的时候已经发生转账了，所以这里不需要转账
                              usdValue = msg.value.getConversionRate(priceFeed);
                    } else {
                              // 如果是代币，这里需要进行授权转账
                              IERC20(auction.paymentToken).transferFrom(msg.sender, address(this), bidAmount);
                              // usdValue = bidAmount;
                              //使用预言机，正儿八经的做一下ERC20价格转换
                              AggregatorV3Interface tokenFeed = tokenPriceFeeds[auction.paymentToken];
                              usdValue = bidAmount.getConversionRate(tokenFeed);
                    }

                    auction.highestBid = bidAmount;
                    auction.highestBidUsd = usdValue;
                    auction.highestBidder = msg.sender;

          }

          function endAuction(uint256 auctionId) 
          public
          {
                    Auction storage auction = auctions[auctionId];

                    require(block.timestamp >= auction.endTime, "Auction ended");
                    require(!auction.ended, "Already ended");

                    auction.ended = true;

                    IERC721(auction.nftAddress).transferFrom(
                              address(this), 
                              auction.highestBidder, 
                              auction.tokenId
                              );
                    
                    if (auction.paymentToken == address(0)) {
                              payable(auction.seller).transfer(auction.highestBid);
                    } else {
                              IERC20(auction.paymentToken).transfer(auction.seller, auction.highestBid);
                    }
          }

          function getLatestPrice() 
          public 
          view 
          returns(uint256) 
          {
                    return PriceConverter.getPrice(priceFeed);
          }
}