# ethereum-demo-scripts

This project contains 3 ethereum shell scripts that can be downloaded and executed in a minimal development environment.

The script documentation is intended to help optimize readability, intent, and relevant details where appropriate.

Each script logs to its own logfile, providing a detailed execution log.

__Script 1__: Creates a local ethereum node structure and associated startnode.sh script to start the node.

__Script 2__: Creates, deploys, and tests a smart contract with web3 and nodejs on a local testrpc node.

__Script 3__: Creates, deploys, and tests a smart contract with truffle on a local testrpc node.

The ethereum-demo-scripts were tested in a bash shell on Ubuntu Linux 16.04.3 LTS. The scripts should also run in a Mac terminal, but has not been tested. Prerequisites are listed below.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for
development and testing purposes.

### Prerequisites

curl (latest)
  ```$ sudo apt-get install curl```

node.js (v8.2.1, includes npm)
  ```$ curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  $ sudo apt-get update
  $ sudo apt-get install -y nodejs
  $ node -v  # to test the install
  $ npm -v   # to test the install```

geth (latest)
  . go-ethereum is a cli that can run and operate a full ethereum node
  . Implemented in go
  . Mines blocks
  . Generates ether
  . Deploys, enables interaction with smart contracts
  . Create accounts
  . Transfer funds between accounts
  . Inspect block history
  . Can connect to a private or public network

  ```$ sudo apt-get install software-properties-common 
  $ sudo add-apt-repository -y ppa:ethereum/ethereum
  $ sudo apt-get update
  $ sudo apt-get install ethereum
  $ geth version  # to test the install```

testrpc (latest)
  . Limited, but helpful initial smart contract testing
  . Emulates an Ethereum node
  . Written in nodejs
  . Uses the ethereum.js library
  . Runs in memory only (no disk storage)

  ```$ sudo npm install -g ethereumjs-testrpc
  $ testrpc version  # to test the install```

truffle (v3.4.5)
  . A build framework for smart contract development:
    - write
    - test
    - deploy
  . Doc at http://truffleframework.com

  ```$ sudo npm install -g truffle
  $ truffle --version  # to test the install```

