#!/bin/bash


################################################################################
# Module .... 01.create.private.mining.node.sh                                 #
# Author .... Neil Simon                                                       #
# Updated ... 01/20/2018                                                       #
# Desc ...... Creates and initializes an ethereum private node folder.         #
#             Creates startnode.sh - to start the node in the foreground.      #
#------------------------------------------------------------------------------#
# Overview:                                                                    #
#   Creates a private node folder                                              #
#   Creates a genesis.json                                                     #
#   Initializes geth with the genesis block                                    #
#   Sets PW for 3 test accounts and saves as password.sec                      #
#   Creates 3 test accounts (coinbase + 2)                                     #
#   Creates password.sec                                                       #
#   Creates startnode.sh - to start the node in the foreground                 #
#   To start the mining node:                                                  #
#     $ cd 01.create.private.mining.node/                                      #
#     $ ./startnode.sh                                                         #
################################################################################

# ex: 01.private.mining.node.sh (remove prepended ./)
SCRIPTNAME=${0:2}

# ex: 01/16/2018 18:06:17
RUN_TIME=$(date '+%m/%d/%Y %H:%M:%S')

printf ">> [$SCRIPTNAME]  $RUN_TIME\n"
printf "\n"

################################################################################
# Script constants                                                             #
################################################################################

DEMO_SCRIPTS_FOLDER=$(pwd)                   # ex: /home/nsimon/ethereum-demo-scripts
NODE_FOLDER=$(basename $SCRIPTNAME .sh)      # ex: 01.create.private.mining.node
DATA_DIR=$DEMO_SCRIPTS_FOLDER/$NODE_FOLDER   # ex: /home/nsimon/ethereum-demo-scripts/01.create.private.mining.node
NETWORK_IDENTIFIER=4224
GETH_RPCPORT=8545
GETH_PORT=30303
GETH_IPCPATH=~/.ethereum/geth.ipc            # ex: /home/nsimon/.ethereum/geth.ipc

printf ">> Script constants:\n"
printf "DEMO_SCRIPTS_FOLDER ... $DEMO_SCRIPTS_FOLDER\n"
printf "NODE_FOLDER ........... $NODE_FOLDER\n"
printf "DATA_DIR .............. $DATA_DIR\n"
printf "NETWORK_IDENTIFIER .... $NETWORK_IDENTIFIER\n"
printf "GETH_RPCPORT .......... $GETH_RPCPORT\n"
printf "GETH_PORT ............. $GETH_PORT\n"
printf "GETH_IPCPATH .......... $GETH_IPCPATH\n"
printf "\n"

################################################################################
# Remove the private node folder (if exists), create, and cd to it             #
################################################################################

printf ">> Removing the private node folder:\n"
printf "rm -rf $NODE_FOLDER\n"
rm -rf $NODE_FOLDER > /dev/null 2>&1
printf "\n"

printf ">> Creating the private node folder:\n"
printf "mkdir $NODE_FOLDER && cd $NODE_FOLDER\n"
printf "\n"
mkdir $NODE_FOLDER && cd $NODE_FOLDER

################################################################################
# Create genesis.json                                                          #
################################################################################

# nonce+mixhash:  used by proof-of-work mechanism to ensure enough computation has been used to validate the block
# difficulty:     used to validate a block (lower value means less computation time)
# alloc:          used to preallocate funds to specific wallet addresses
# coinbase:       in each block, is set to adress of miner that successfully mined the block
# timestamp:      set by the evm to adjust the level of difficulty applied, resulting in consistent times between blocks, serves as the BLOCK SEQUENCE NUMBER
# parentHash:     hash value of the parent block (0 for genesis block)
# extraData:      can be used as meta-data for the blockchain
# gasLimit:       specifies max gas that can be spent per block
#                 limits the size of blocks
#                 set to max value for private node, BUT: need to keep track of gas used by any smart contracts
# chainId:        network id for the private chain
# homesteadBlock: specifies which block miners should start using the "homestead protocol upgrade"
# eip155Block:    0
# eip158Block:    0

printf ">> Creating file: genesis.json\n"
cat << EOF > genesis.json
{
"nonce":      "0x0000000000000042",
"mixhash":    "0x0000000000000000000000000000000000000000000000000000000000000000",
"difficulty": "0x400",
"alloc": {},
"coinbase":   "0x0000000000000000000000000000000000000000",
"timestamp":  "0x0",
"parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
"extraData":  "0x",
"gasLimit":   "0xffffffff",
"config":
    {
    "chainId":        $NETWORK_IDENTIFIER,
    "homesteadBlock": 0,
    "eip155Block":    0,
    "eip158Block":    0
    }
}
EOF
printf "\n"

################################################################################
# geth:                                                                        #
#   Create the genesis block                                                   #
#   Create the node folder structure                                           #
################################################################################

printf ">> Running: geth --datadir $DATA_DIR init genesis.json\n"
geth --datadir $DATA_DIR init genesis.json
printf "\n"

################################################################################
# Prompt for test accounts password                                            #
################################################################################

printf ">> Setting pw for 3 test accounts:\n"
printf "PW=testpw\n"
printf "\n"
PW=testpw

################################################################################
# Create 3 test accounts:                                                      #
#   Public key AND private key for each                                        #
#   First account is the coinbase                                              #
#   Available to be used by testrpc                                            #
################################################################################

printf ">> Running (1/3): geth: account new --password <(echo {pw})\n"
geth --datadir $DATA_DIR account new --password <(echo $PW)
printf "\n"

printf ">> Running (2/3): geth: account new --password <(echo {pw})\n"
geth --datadir $DATA_DIR account new --password <(echo $PW)
printf "\n"

printf ">> Running (3/3): geth: account new --password <(echo {pw})\n"
geth --datadir $DATA_DIR account new --password <(echo $PW)
printf "\n"

################################################################################
# List the 3 test accounts                                                     #
################################################################################

printf ">> Running: geth --datadir $DATA_DIR account list\n"
geth --datadir $DATA_DIR account list
printf "\n"

################################################################################
# Create startnode.sh                                                          #
################################################################################

printf ">> Creating file: startnode.sh\n"
cat << EOF > startnode.sh
#!/bin/bash

# geth params:
#  --networkid                       # as specified in genesis block
#  --mine                            # start mining at startup
#  --datadir {node folder}           # private node folder root, where to store blockchain data
#  --nodiscover                      # run isloated as peer-to-peer, do not look for network peers
#  --rpc --rpcport {port number}     # enable the http rpc server and listening port
#  --port "30303"                    # the peer-to-peer port -- used by nodes to connect with each other
#  --rpccorsdomain {nodes to allow}  # allow any node to connect to the rpc endpoint
#  --nat {nat ports to allow}        # allow any nat port
#  --rpcapi eth,web3,personal,net    # allow these protocols to make inbound requests
#  --unlock 0                        # mining: keep the 1st account (coinbase) unlocked
#  --password {password.sec file}    # required to start the node
#  --ipcpath {geth.icp file}         # used by mist to detect that a node is running

# Start the node, begin mining
geth --networkid $NETWORK_IDENTIFIER \\
     --mine \\
     --datadir $DATA_DIR \\
     --nodiscover \\
     --rpc \\
     --rpcport $GETH_RPCPORT \\
     --port $GETH_PORT \\
     --rpccorsdomain "*" \\
     --nat "any" \\
     --rpcapi eth,web3,personal,net \\
     --unlock 0 \\
     --password $DATA_DIR/password.sec \\
     --ipcpath $GETH_IPCPATH
EOF

chmod 775 startnode.sh
printf "\n"

################################################################################
# Create password.sec                                                          #
################################################################################

printf ">> Creating file: password.sec\n"
cat << EOF > password.sec
$PW
EOF

chmod 400 password.sec
printf "\n"

################################################################################
# End                                                                          #
################################################################################

printf ">> ***************************************\n"
printf ">> * TO START THE NODE:\n"
printf ">> *   $ cd $NODE_FOLDER/\n"
printf ">> *   $ ./startnode.sh\n"
printf ">> ***************************************\n"
printf "\n"

printf ">> [$SCRIPTNAME] end\n"
printf "\n"

