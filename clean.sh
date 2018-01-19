#!/bin/bash

################################################################################
# Module .... clean.sh                                                         #
# Author .... Neil Simon                                                       #
# Updated ... 01/18/2018                                                       #
# Desc ...... Removes all output created by the eth scripts.                   #
################################################################################

# rm all output folders
rm -rf 01.create.private.mining.node
rm -rf 02.nodejs.web3.solc.testrpc.deploy.test
rm -rf 03.truffle.testrpc.deploy.test

# rm all output logs
rm *.log

