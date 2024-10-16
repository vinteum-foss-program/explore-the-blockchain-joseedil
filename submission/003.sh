#!/bin/bash

# How many new outputs were created by block 123,456?

BITCOIN="bitcoin-cli"

# Get block data
height=123456
blockhash=$($BITCOIN getblockhash $height)
blockdata=$($BITCOIN getblock $blockhash)

# Get transactions hashes from block data
txhashes=$(echo $blockdata | jq -c -r '.tx[]')

# Initialize counter
COUNTER=0

# Iterate over transaction hashes
for tx in ${txhashes[@]}
do
    # Get transaction outputs
    rawtransaction=$($BITCOIN getrawtransaction $tx)
    decodedtransaction=$($BITCOIN decoderawtransaction $rawtransaction)
    voutn=$(echo $decodedtransaction | jq -c -r '.vout[].n')

    # Iterate over transaction outputs counting them
    for n in ${voutn[@]}
    do
        let COUNTER++
    done
done

# Output result
echo $COUNTER
