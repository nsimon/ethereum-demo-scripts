# ethereum-demo-scripts

This project contains 3 ethereum shell scripts that can be downloaded and executed in a minimal development environment.

The script documentation is intended to help optimize readability, intent, and relevant details where appropriate.

Each script logs to its own logfile, providing a detailed execution log.

__Script 1__: Creates a local ethereum node structure and associated startnode.sh script to start the node.

__Script 2__: Creates, deploys, and tests a smart contract with web3 and nodejs on a local testrpc node.

__Script 3__: Creates, deploys, and tests a smart contract with truffle on a local testrpc node.

The ethereum-demo-scripts were tested in a bash shell on Ubuntu Linux 16.04.3 LTS. The scripts should also run in a Mac terminal, but has not been tested. Prerequisites are listed below.

## Getting Started

These instructions will help you get the project up and running on your local machine for development and testing purposes.

### Prerequisites

curl (latest)
  ```
  $ sudo apt-get install curl
  ```

node.js (v8.2.1 tested)
  * Server javascript platform.
  * Includes npm - node package manager.
  ```
  $ curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  $ sudo apt-get update
  $ sudo apt-get install -y nodejs
  $ node -v    # verify the version
  $ npm -v     # verify the version
  ```

geth (latest)
  * A cli that can run and operate a full ethereum node.
  * Implemented in go.
  * Mines blocks.
  * Generates ether.
  * Deploys, enables interaction with smart contracts.
  * Create accounts.
  * Transfer funds between accounts.
  * Inspect block history.
  * Can connect to a private or public network.

  ```
  $ sudo apt-get install software-properties-common 
  $ sudo add-apt-repository -y ppa:ethereum/ethereum
  $ sudo apt-get update
  $ sudo apt-get install ethereum
  $ geth version  # verify the version
  ```

testrpc (latest)
  * Limited, but helpful smart contract testing.
  * Emulates an Ethereum node.
  * Written in nodejs.
  * Uses the ethereum.js library.
  * Runs in memory only (no disk storage).

  ```
  $ sudo npm install -g ethereumjs-testrpc
  $ testrpc version  # verify the version
  ```

truffle (v3.4.5 tested)
  * A build framework for smart contract development:
    * Write
    * Test
    * Deploy

  ```
  $ sudo npm install -g truffle
  $ truffle --version  # verify the version
  ```

### Installing

Install to any folder.

To install under your home folder into new folder **~/ethereum-demo-scripts-master/**:
```
$ cd ~
$ wget https://github.com/nsimon/ethereum-demo-scripts/archive/master.zip
$ unzip master.zip
$ rm master.zip
```
## Running the end-to-end tests

## Built with

* [Geth](https://maven.apache.org) - Dependency Management
* [Truffle](http://truffleframework.com)

## Authors

* **Neil Simon** - *Initial work* - [nsimon](https://github.com/nsimon).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Inspired by [Getting Started with Ethereum Solidity Development](https://www.udemy.com/getting-started-with-ethereum-solidity-development) by [Sebastien Arbogast](https://www.udemy.com/user/sebastienarbogast3).

