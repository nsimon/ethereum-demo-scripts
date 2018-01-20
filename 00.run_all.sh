#!/bin/bash

################################################################################
# Module .... 00.run_all.sh                                                    #
# Author .... Neil Simon                                                       #
# Updated ... 01/18/2018                                                       #
# Desc ...... Runs all of the demo scripts, each logging output to its own log.#
#             See each script for annotated documentation.                     #
################################################################################

run_eth_script ()
    {
    # ex: 01.private.mining.node.sh
    SCRIPTNAME=$1
    printf "$SCRIPTNAME..."

    # Run the script, create output results log
    ./$SCRIPTNAME 2>&1 | tee $SCRIPTNAME.log

    printf "completed.\n\n"
    }

################################################################################

# ex: 01/16/2018 18:06:17
RUN_TIME=$(date '+%m/%d/%Y %H:%M:%S')

# ex: 00.run_all.sh  01/16/2018 18:06:17
printf "[${0:2}]  $RUN_TIME\n\n"

# Run each eth script:
run_eth_script 01.create.private.mining.node.sh
run_eth_script 02.nodejs.web3.solc.testrpc.deploy.test.sh
run_eth_script 03.truffle.testrpc.deploy.test.sh

printf "[${0:2}] end\n"
printf "\n"

