# ethereum-demo-scripts

This project contains 3 ethereum shell scripts that can be downloaded and executed in a minimal development environment.

The script documentation is intended to help optimize readability, intent, and relevant details where appropriate.

Each script logs to its own logfile, providing a detailed execution log.

**Script 1**: Creates a local ethereum node structure and associated startnode.sh script to start the node.

**Script 2**: Creates, deploys, and tests a smart contract with web3 and nodejs on a local testrpc node.

**Script 3**: Creates, deploys, and tests a smart contract with truffle on a local testrpc node.

These ethereum-demo-scripts were tested in a bash shell on Ubuntu Linux 16.04.3 LTS. The scripts should also run in a Mac terminal, but has not been tested. Prerequisites are listed below.

### Prerequisites

curl (v7.47.0 tested)
  ```
  $ sudo apt-get install curl
  ```

node.js (v8.9.0 tested)
  * Server javascript platform.
  * Includes npm - node package manager.
  * Doc: [npm](https://docs.npmjs.com)
  * Doc: [node.js](https://nodejs.org/dist/latest-v8.x/docs/api)
  ```
  $ curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  $ sudo apt-get update
  $ sudo apt-get install -y nodejs
  $ node -v    # verify the version
  $ npm -v     # verify the version
  ```

geth (v1.7.2 tested)
  * A cli that can run and operate a full ethereum node.
  * Implemented in go.
  * Mines blocks.
  * Generates ether.
  * Deploys and enables interaction with smart contracts.
  * Creates accounts.
  * Transfer funds between accounts.
  * Inspect block history.
  * Can connect to a private or public network.
  * Doc: [geth](https://github.com/ethereum/go-ethereum/wiki/geth)
  * Doc: [geth console](https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console)

  ```
  $ sudo apt-get install software-properties-common 
  $ sudo add-apt-repository -y ppa:ethereum/ethereum
  $ sudo apt-get update
  $ sudo apt-get install ethereum
  $ geth version  # verify the version
  ```

testrpc (v4.1.3 tested)
  * Limited, but helpful smart contract testing.
  * Emulates an Ethereum node.
  * Written in nodejs.
  * Uses the ethereum.js library.
  * Runs in memory only (no disk storage).
  * Doc: [testrpc](https://www.npmjs.com/package/ethereumjs-testrpc)

  ```
  $ sudo npm install -g ethereumjs-testrpc
  $ testrpc version  # verify the version
  ```

truffle framework (v3.4.5 tested)
  * A build framework for smart contract development:
    * Write
    * Test
    * Deploy
  * Doc: [truffle framework](http://truffleframework.com)

  ```
  $ sudo npm install -g truffle
  $ truffle --version  # verify the version
  ```

### Installation

Install to any folder.

To install under your home folder: e.g. **~/ethereum-demo-scripts-master/**:
```
$ cd ~
$ wget https://github.com/nsimon/ethereum-demo-scripts/archive/master.zip
$ unzip master.zip
$ rm master.zip
```

## Demo scripts overview

### `01.create.private.mining.node.sh`

Creates a local ethereum node structure and associated startnode.sh script to start the node.

Progress and output detail is logged.

Overview:
  * Creates a private node folder.
  * Creates genesis.json.
  * Runs geth to create the genesis-block chaindata.
  * Sets a test password for 3 test accounts and saves as password.sec.
  * Runs geth to create 3 test accounts (coinbase + 2).
  * Creates password.sec.
  * Creates startnode.sh that starts the node as a foreground task that mines ether.

### `02.nodejs.web3.solc.testrpc.deploy.test.sh`

Creates, deploys, and tests a smart contract with **web3 and nodejs** on a local testrpc node.

Progress and output detail is logged.

Creates and runs a nodejs script that:
  * Loads module web3.
  * Loads module solc.
  * Creates a new instance of the web3 object.
  * Displays the 10 default testrpc accounts.
  * Loads the **announcement** smart contact source.
  * Compiles the smart contract to json.
  * Extract from the json: the smart contract ABI **application binary interface** (it's api).
  * Extract from the json: the smart contact byteCode, used to deploy the smart contract.
  * Instantiate the smart contract object ABI.
  * Deploy the smart contract to the testrpc blockchain.
    * Runs the smart contract constructor which sets the announcement message.
  * Displays the address of the deployed contract.
  * Gets a pointer to an instance of the deployed contract.
  * Contract call: getAnnouncement():
    * Retrieves the original message that was set by the contructor.
    * No transaction.
    * Gets the state the current message value.
  * Contract call: setAnnouncement():
    * Updates the message with a new string.
    * Creates transactions.
    * Uses gas.
  * Contract call: getAnnouncement():
    * Retrieves the updated message.
    * No transaction.
    * Gets the state the current message value.

### `03.truffle.testrpc.deploy.test.sh`

Creates, deploys, and tests a smart contract with **truffle** on a local testrpc node.

Progress and output detail is logged.

Overview:
  * Runs truffle init to initialize the project.
  * Removes unnecssary truffle boilerplate.
  * Creates smart contract: announcement.sol.
  * Adds the smart contract to migrations/2_deploy_contracts.js.
  * Runs testrpc as a background task.
  * Runs truffle migrate to deploy the smart contact.
  * Creates and runs a truffle exec script that:
    * Gets a pointer to the deployed contract.
    * Displays the contract address.
    * Displays the 10 default testrpc accounts.
    * Gets a pointer to the deployed contract instance.
      * Contract call: getAnnouncement():
        * Retrieves the original message that was set by the contructor.
      * Contract call: setAnnouncement():
        * Updates the message with a new string.
      * Contract call: getAnnouncement():
        * Retrieves the updated message.
  * Stops the testrpc background task.

### `00.run_all.sh`

Runs all of the demo scripts in order: 01, 02, and 03, each logging output to its own log file.

Annotated documentation is included in each script.

To run all scripts in succession:

```
$ ./00.run_all.sh
```

### `clean.sh`

Removes all folders and log files created by the ethereum-demo-scripts.

To run the clean script:

```
$ ./clean.sh
```

## Author

* Neil Simon

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

Inspired by [Getting Started with Ethereum Solidity Development](https://www.udemy.com/getting-started-with-ethereum-solidity-development) by [Sebastien Arbogast](https://www.udemy.com/user/sebastienarbogast3).

