#!/bin/bash

# Which tx in block 257,343 spends the coinbase output of block 256,128?

BITCOIN="bitcoin-cli"

# First, let find the coinbase transaction hash
coinbaseblockhash=$($BITCOIN getblockhash 256128)
coinbaseblockdata=$($BITCOIN getblock $coinbaseblockhash)
coinbasehash=$(echo $coinbaseblockdata | jq -c -r '.tx[0]')

# Get the spending block data and find all transaction hashes
spendingblockhash=$($BITCOIN getblockhash 257343)
spendingblockdata=$($BITCOIN getblock $spendingblockhash)
spendinghashes=$(echo $spendingblockdata | jq -c -r '.tx[]')

# For each transaction in the spending block...
for tx in ${spendinghashes[@]}
do
    # Get transaction data
    spendingrawtransaction=$($BITCOIN getrawtransaction $tx)
    spendingtransactiondata=$($BITCOIN decoderawtransaction $spendingrawtransaction)

    # Search for the coinbase transaction id in the transaction inputs
    filter=$(echo $spendingtransactiondata | jq '.vin[] | select(.txid == "'${coinbasehash}'")')

    # Found the transaction we are looking for: echo it and stop
    if [[ ! -z $filter ]]
    then
        echo $tx
        break
    fi

done
