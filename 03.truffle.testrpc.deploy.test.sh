#!/bin/bash

################################################################################
# Module .... 03.truffle.testrpc.deploy.test.sh                                #
# Author .... Neil Simon                                                       #
# Updated ... 01/20/2018                                                       #
# Desc ...... Creates and deploys smart contract, updates state                #
#------------------------------------------------------------------------------#
# Overview:                                                                    #
#   Creates new contract folder structure on each run                          #
#   $ truffle init                                                             #
#   Removes unnecssary boilerplate                                             #
#   Creates smart contract: announcement.sol                                   #
#   Adds to migrations/2_deploy_contracts.js                                   #
#   $ testrpc &                                                                #
#   $ truffle migrate                                                          #
#   Creates truffle command file: announcement.truffle.commands.js             #
#   $ truffle exec announcement.truffle.commands.js  // RESULTS -> stdout      #
#   $ kill -9 {testrpc pid}                                                    #
################################################################################

# ex: 03.truffle.testrpc.deploy.test.sh (remove prepended ./)
SCRIPTNAME=${0:2}

# ex: 01/16/2018 18:06:17
RUN_TIME=$(date '+%m/%d/%Y %H:%M:%S')

printf ">> [$SCRIPTNAME]  $RUN_TIME\n"
printf "\n"

################################################################################
# Script constants                                                             #
################################################################################

CONTRACT_FOLDER=$(basename $SCRIPTNAME .sh)  # ex: 03.truffle.testrpc.deploy.test

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
# Create truffle project                                                       #
################################################################################

printf ">> Creating a new truffle project:\n"
printf "truffle init\n"
printf "\n"
truffle init

################################################################################
# Remove unnecessary boilerplate                                               #
################################################################################

printf ">> Removing unnecessary truffle boilerplate:\n"

printf "rm contracts/ConvertLib.sol\n"
rm contracts/ConvertLib.sol

printf "rm contracts/MetaCoin.sol\n"
rm contracts/MetaCoin.sol

printf "rm test/metacoin.js\n"
rm test/metacoin.js

printf "rm test/TestMetacoin.sol\n"
rm test/TestMetacoin.sol

printf "\n"

################################################################################
# Create contracts/announcement.sol                                            #
################################################################################

printf ">> Creating smart contract: contracts/announcement.sol\n"
cat << EOF > contracts/announcement.sol
// solidity compiler must be at least v0.4.11
pragma solidity ^0.4.11;

contract announcement {
    // Variable length
    string message;

    // Constructor
    // - Uses gas
    // - Called once, when first added to the blockchain
    function announcement () public {
        message = "Welcome to the automated test: $SCRIPTNAME";
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
# Overwrite migrations/2_deploy_contracts.js                                   #
################################################################################

printf ">> Modifing contract file: migrations/2_deploy_contracts.js (to deploy announcement.sol)\n"
cat << EOF > migrations/2_deploy_contracts.js
var announcement = artifacts.require ("./announcement.sol")

module.exports = function (deployer) {
    deployer.deploy (announcement);
};

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
# Run truffle migrate to deploy the contracts                                  #
################################################################################

printf ">> Running truffle migrate to deploy contracts: Migrations.sol and announcement.sol\n"
printf ">> Generates 4 transactions:\n"
printf ">>   1: contract deployment: Migrations.sol\n"
printf ">>   2: updated state:       number of the 1st script\n"
printf ">>   3: contract deployment: announcement.sol\n"
printf ">>   4: updated state:       the migration contract state (again)\n"
printf "truffle migrate\n"
printf "\n"
truffle migrate

printf "\n"
printf ">> Allow truffle to fully deploy the contracts:\n"
printf "sleep 3s\n"
printf "\n"
sleep 3s

################################################################################
# Create announcement.truffle.commands.js                                      #
################################################################################

printf ">> Creating truffle commands file: announcement.truffle.commands.js\n"
cat << EOF > announcement.truffle.commands.js
// Module: announcement.truffle.commands.js
// Desc:   suite of commands to test the deployed "announcement.sol", display some account stats
module.exports = function (done) {
    // Get pointer to the contract
    var announcement = artifacts.require ("announcement");

    // Display the contract address
    announcementAddress = announcement.address;
    console.log ();
    console.log ("[truffle] announcement.address:");
    console.log (announcementAddress);
    console.log ();

    // Display the 10 testrpc accounts
    accounts = web3.eth.accounts;
    console.log ();
    console.log ("[truffle] web3.eth.accounts:");
    console.log (accounts);
    console.log ();

    // Get pointer (app) to the deployed instance
    announcement.deployed().then (function (instance) {
        // Display app instance (json)
        var app = instance;
        console.log ();
        console.log ("[truffle] app instance:");
        console.log (app);
        console.log ();

        // Get current message
        app.getAnnouncement ().then (function (message) {
            // Display current message
            console.log ();
            console.log ("[truffle] app.getAnnouncement():");
            console.log (message);
            console.log ();
        });

        // Set message
        app.setAnnouncement ("Goodbye from the automated test: $SCRIPTNAME", {from: web3.eth.accounts [0]}).then (function () {
            console.log ();
            console.log ("[truffle] app.setAnnouncement ('Goodbye from the automated test: $SCRIPTNAME', {from: web3.eth.accounts [0]})");
            console.log ();

            // Get current (updated) message
            app.getAnnouncement ().then (function (message) {
                // Display current (updated) message
                console.log ();
                console.log ("[truffle] app.GetAnnouncement():");
                console.log (message);
                console.log ();
            });
        });
    });
}

EOF
printf "\n"

################################################################################
# Run announcement.truffle.commands.js                                         #
################################################################################

printf ">> Running announcement.truffle.commands.js:\n"
printf "truffle exec announcement.truffle.commands.js\n"
printf "\n"
truffle exec announcement.truffle.commands.js

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

