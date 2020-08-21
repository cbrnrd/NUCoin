# NUCoin
Welcome to NUCoin! NUCoin is a mintable token built on the Ethereum blockchain. This is a proof of concept replacement for my schools "Husky Dollars" and meal swipe program.

## Why even make this?
I really just wanted to experiment with building decentralized applications on the Ethereum blockchain, but I came to realize
that the school would likely save thousands of dollars by implementing this because:

* Instead of paying for servers and constantly having them running, they would only pay per-transaction.
* This system allows for students to exchange NUCoins, which is not supported by Husky Dollars or meal swipes.
* The school has complete control of what and who can create coins.
* The price of coins can be dictated by the people selling it (the authoritative addresses).
* If implemented, it would probably get them some press coverage lol.

## Possible improvements
As of right now, this is a very simple token that is mintable by select addresses (starting with the contract owner). To make it more standard, it could be an [ERC223 token](https://github.com/Dexaran/ERC223-token-standard).

There is also the question of gas fees. As written, each student would pay for gas fees on each transaction. However, if the contract is updated to use the [Gas Station Network (GSN)](https://www.opengsn.org/), the school (or rather, the original authority) would pay for gas on each transaction. This can be offset by charging a small premium on each token.

## How can I use it?
The most recent version of NUCoin is available on the Ropsten testnet at contract address [0x05Eea95162711D88469e825AA574930cE8560F5F](https://ropsten.etherscan.io/address/0x05Eea95162711D88469e825AA574930cE8560F5F).

### TODO
* Add a function that allows for an authoritative address to view the balance of a student's account.
* Implement SafeMath
* Make some graphics for the project. Logo, etc.