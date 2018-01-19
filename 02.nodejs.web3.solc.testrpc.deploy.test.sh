#!/bin/bash

################################################################################
# Module .... 02.nodejs.web3.solc.testrpc.deploy.test.sh                       #
# Author .... Neil Simon                                                       #
# Updated ... 01/18/2018                                                       #
# Desc ...... Creates and deploys smart contract, updates state                #
#------------------------------------------------------------------------------#
# Overview:                                                                    #
#   Creates new contract folder structure on each run                          #
#   $ npm init                                                                 #
#   $ npm install web3@0.20.0                                                  #
#   $ npm install solc                                                         #
#   $ npm install system-sleep                                                 #
#   Creates smart contract: announcement.sol                                   #
#   $ testrpc &                                                                #
#   Creates node command file: announcement.node.commands.js                   #
#   $ node announcement.node.commands.js                                       #
#   $ kill -9 {testrpc pid}                                                    #
################################################################################

# ex: 02.nodejs.web3.solc.testrpc.deploy.test.sh (remove prepended ./)
SCRIPTNAME=${0:2}

# ex: 01/16/2018 18:06:17
RUN_TIME=$(date '+%m/%d/%Y %H:%M:%S')

printf ">> [$SCRIPTNAME]  $RUN_TIME\n"
printf "\n"

################################################################################
# Script constants                                                             #
################################################################################

DEV_FOLDER=~/ethererum.dev
CONTRACT_FOLDER=02.nodejs.web3.solc.testrpc.deploy.test

printf ">> Script constants:\n"
printf "DEV_FOLDER ............ $DEV_FOLDER\n"
printf "CONTRACT_FOLDER ....... $CONTRACT_FOLDER\n"
printf "\n"

################################################################################
# Remove the contract folder (if exists), create, and cd to it                 #
################################################################################

printf ">> Removing the contract folder:\n"
printf "rm -rf $CONTRACT_FOLDER\n"
printf "\n"
rm -rf $CONTRACT_FOLDER > /dev/null 2>&1

printf ">> Creating the contract folder, cd to it:\n"
printf "mkdir $CONTRACT_FOLDER && cd $CONTRACT_FOLDER\n"
printf "\n"
mkdir $CONTRACT_FOLDER && cd $CONTRACT_FOLDER

################################################################################
# Create package.json                                                          #
################################################################################

printf ">> Running: npm init -f (to create package.json)\n"
printf "npm init -f\n"
printf "\n"
npm init -f

################################################################################
# Install npm dependency: web3 (v0.20.0)                                       #
################################################################################

printf ">> Running: npm install web3@0.20.0\n"
printf "npm install web3@0.20.0\n"
npm install web3@0.20.0
printf "\n"

################################################################################
# Install npm dependency: solc                                                 #
################################################################################

printf ">> Running: npm install solc\n"
printf "npm install solc\n"
npm install solc
printf "\n"

################################################################################
# Install npm dependency: system-sleep                                         #
################################################################################

printf ">> Running: npm install system-sleep\n"
printf "npm install system-sleep\n"
npm install system-sleep
printf "\n"

################################################################################
# Create announcement.sol                                                      #
################################################################################

printf ">> Creating smart contract: announcement.sol\n"
cat << EOF > announcement.sol
// solidity compiler must be at least v0.4.11
pragma solidity ^0.4.11;

contract announcement {
    // Variable length
    string message;

    // Constructor
    // - Uses gas
    // - Called once, when first added to the blockchain
    function announcement () public {
        message = "Welcome to the npm/testrpc automated test.";
    }

    // Setter (can be called from any other contract)
    // - Uses gas
    // - Creates a transaction
    function setAnnouncement (string _message) public {
        message = _message;
    }

    // Getter
    // - No gas needed
    function getAnnouncement () public constant returns (string) {
        return message;
    }
}

EOF
printf "\n"

################################################################################
# Start testrpc as a background task                                           #
################################################################################

printf ">> Starting testrpc as a background task:\n"
printf "testrpc &\n"
printf "\n"
testrpc &
TESTRPC_PID=$!

printf ">> Allow testrpc to fully load:\n"
printf "sleep 3s\n"
printf "\n"
sleep 3s
printf "\n"

################################################################################
# Create announcement.node.commands.js                                         #
################################################################################

printf ">> Creating node commands file: announcement.node.commands.js\n"
cat << EOF > announcement.node.commands.js
#!/usr/bin/env node

// Load node_module: web3
Web3 = require ("web3")
console.log ("===================================")
console.log ("Web3:")
console.log ("===================================")
console.log (Web3)
console.log ()

// Load node_module: solc
solc = require ("solc")
console.log ("===================================")
console.log ("solc:")
console.log ("===================================")
console.log (solc)
console.log ()

// Load (core) node_module: fs
fs = require ("fs")
console.log ("===================================")
console.log ("fs:")
console.log ("===================================")
console.log (fs)
console.log ()

// Load node_module: system-sleep
sleep = require ("system-sleep")
console.log ("===================================")
console.log ("sleep:")
console.log ("===================================")
console.log (sleep)
console.log ()

// Create a new instance of the Web3 object
web3 = new Web3 (new Web3.providers.HttpProvider ("http://localhost:8545"))
console.log ("===================================")
console.log ("web3:")
console.log ("===================================")
console.log (web3)
console.log ()

// Test the web3 object, by displaying the 10 testrpc accounts
console.log ("===================================")
console.log ("accounts:")
console.log ("===================================")
accounts = web3.eth.accounts
console.log ()
console.log (accounts)
console.log ()

// Load the smart contact source
sourceCode = fs.readFileSync ("announcement.sol").toString()
console.log ("===================================")
console.log ("sourceCode:")
console.log ("===================================")
console.log (sourceCode)

// Compile the smart contract source - result is a json object with many fields
compiledCode = solc.compile (sourceCode)
console.log ("===================================")
console.log ("compiledCode:")
console.log ("===================================")
console.log (compiledCode)
console.log ()

// Extract the smart contract "application binary interface" (it's api)
contractABI = JSON.parse (compiledCode.contracts [":announcement"].interface)
console.log ("===================================")
console.log ("contractABI:")
console.log ("===================================")
console.log (contractABI)
console.log ()

// Extract the smart contact byteCode - used to deploy the smart contract
byteCode = compiledCode.contracts [":announcement"].bytecode
console.log ("===================================")
console.log ("byteCode:")
console.log ("===================================")
console.log (byteCode)
console.log ()

// Instantiate the smart contract object
announcementContract = web3.eth.contract (contractABI)
console.log ("===================================")
console.log ("announcementContract:")
console.log ("===================================")
console.log (announcementContract)
console.log ()

// Deploy the smart contract to the testrpc blockchain
console.log ("===================================")
console.log ("announcementDeployed:")
console.log ("===================================")
announcementDeployed = announcementContract.new ({data: byteCode, from: web3.eth.accounts [0], gas: 4700000})
console.log (announcementDeployed)
console.log ()

// Allow the smart contract to fully deploy before continuing
sleep (3000)
console.log ()

// Display the address of the deployed contract
console.log ("===================================")
console.log ("announcementDeployed.address:")
console.log ("===================================")
announcementDeployed.address
console.log (announcementDeployed.address)
console.log ()

// Get an instance of the deployed contract
console.log ("===================================")
console.log ("announcementInstance:")
console.log ("===================================")
announcementInstance = announcementContract.at (announcementDeployed.address)
console.log (announcementInstance)
console.log ()

// Retrieve the original message (and see that the contructor has run)
// no transaction -- only getting the state
console.log ("===================================")
console.log ("getAnnouncement():")
console.log ("===================================")
message = announcementInstance.getAnnouncement()
console.log ()
console.log ("message: " + message)
console.log ()

// Update the message
console.log ("===================================")
console.log ("setAnnouncement():")
console.log ("===================================")
tx = announcementInstance.setAnnouncement ("Good-bye from the npm/testrpc automated test.", {from: web3.eth.accounts [0]})
console.log ("tx: " + tx)
console.log ()

// Retrieve the updated message
// no transaction -- only getting the state
console.log ("===================================")
console.log ("getAnnouncement():")
console.log ("===================================")
message = announcementInstance.getAnnouncement()
console.log ()
console.log ("message: " + message)

EOF

chmod 775 announcement.node.commands.js
printf "\n"

################################################################################
# Run announcement.node.commands.js                                            #
################################################################################

printf ">> Running announcement.node.commands.js:\n"
printf "node announcement.node.commands.js\n"
printf "\n"
node announcement.node.commands.js
printf "\n"

################################################################################
# Kill the testrpc running in the background                                   #
################################################################################

printf ">> Killing the testrpc background task:\n"
printf "kill -9 $TESTRPC_PID\n"
printf "\n"
kill -9 $TESTRPC_PID

################################################################################
# End                                                                          #
################################################################################

printf ">> [$SCRIPTNAME] end\n"
printf "\n"

