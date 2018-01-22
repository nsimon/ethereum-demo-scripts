#!/bin/bash

################################################################################
# Module .... clean.sh                                                         #
# Author .... Neil Simon                                                       #
# Updated ... 01/21/2018                                                       #
# Desc ...... Removes all folders and log files created by the                 #
#             ethereum-demo-scripts.                                           #
################################################################################

# rm all output folders
rm -rf 01.create.private.mining.node
rm -rf 02.nodejs.web3.solc.testrpc.deploy.test
rm -rf 03.truffle.testrpc.deploy.test

# rm all output logs
rm *.log > /dev/null 2>&1

