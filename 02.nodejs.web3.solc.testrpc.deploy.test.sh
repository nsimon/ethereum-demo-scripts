#!/bin/bash

################################################################################
# Module .... 02.nodejs.web3.solc.testrpc.deploy.test.sh                       #
# Author .... Neil Simon                                                       #
# Updated ... 02/12/2018                                                       #
# Desc ...... Creates and deploys smart contract, updates state                #
#------------------------------------------------------------------------------#
# Overview:                                                                    #
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

CONTRACT_FOLDER=$(basename $SCRIPTNAME .sh)  # ex: 02.nodejs.web3.solc.testrpc.deploy.test

printf ">> Script constants:\n"
printf "CONTRACT_FOLDER ... $CONTRACT_FOLDER\n"
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
        message = "Welcome to the automated test";
    }

    // Setter (can be called from any other contract)
    // - Uses gas
    // - Creates a transaction
    function setAnnouncement (string _message) public {
        message = _message;
    }

    // Getter
    // - No gas used
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

function main () {
    // Display script name and date/time
    const now  = new Date ();
    const path = require ("path");
    filename   = path.basename (__filename);
    console.log (filename + ".  " + now + ".");
    console.log ();

    // Load web3
    const Web3 = require ("web3");
    display_results ("Web3", Web3);

    // Load solc
    const solc = require ("solc");
    display_results ("solc", solc);

    // Load fs
    const fs = require ("fs");
    display_results ("fs", fs);

    // Load system-sleep
    const sleep = require ("system-sleep");
    display_results ("sleep", sleep);

    // Create new instance of the Web3 object
    const web3 = new Web3 (new Web3.providers.HttpProvider ("http://localhost:8545"));
    display_results ("web3", web3);

    // Display the 10 testrpc accounts
    const accounts = web3.eth.accounts;
    display_results ("accounts", accounts);

    // Load the smart contact source
    const sourceCode = fs.readFileSync ("announcement.sol").toString();
    display_results ("sourceCode", sourceCode);

    // Compile the smart contract source
    const compiledCode = solc.compile (sourceCode);
    display_results ("compiledCode", compiledCode);

    // Extract the smart contract "application binary interface" (it's api)
    const contractABI = JSON.parse (compiledCode.contracts [":announcement"].interface);
    display_results ("contractABI", contractABI);

    // Extract the smart contact byteCode
    const byteCode = compiledCode.contracts [":announcement"].bytecode;
    display_results ("byteCode", byteCode);

    // Instantiate the smart contract object
    const announcementContract = web3.eth.contract (contractABI);
    display_results ("announcementContract", announcementContract);

    // Deploy the smart contract to the testrpc blockchain
    const announcementDeployed = announcementContract.new ({data: byteCode, from: web3.eth.accounts [0], gas: 4700000});
    display_results ("announcementDeployed", announcementDeployed);

    // Allow the smart contract to fully deploy before continuing
    sleep (3000);
    console.log ();

    // Deployed contract address
    const deployedAddress = announcementDeployed.address;
    display_results ("deployedAddress", deployedAddress);

    // Announcement instance
    const announcementInstance = announcementContract.at (deployedAddress);
    display_results ("announcementInstance", announcementInstance);

    // Current value of announcement
    display_results ("getAnnouncement()", announcementInstance.getAnnouncement());

    // Update the announcement
    const newAnnouncement = "Goodbye from the automated test";
    const fromAccount     = web3.eth.accounts [0];
    display_results ("setAnnouncement()", newAnnouncement);
    const tx              = announcementInstance.setAnnouncement (newAnnouncement, {from: fromAccount});
    display_results ("tx", tx);

    // Updated value of announcement
    display_results ("getAnnouncement()", announcementInstance.getAnnouncement());

    console.log ("<end>");
    console.log ();
}

function display_results (varname, varvalue) {
    if (typeof varvalue == "object") {
        console.log ("===================================");
        console.log ("%s:", varname);
        console.log ("===================================");
        str = JSON.stringify (varvalue, null, 4);
        console.log ("%s", str);
        console.log ();
    }
    else {
        console.log ("===================================");
        console.log ("%s:", varname);
        console.log ("===================================");
        console.log ("%s", varvalue);
        console.log ();
    }
}

if (require.main == module) {
    main ();
}
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

