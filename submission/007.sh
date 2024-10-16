#!/bin/bash

# Only one single output remains unspent from block 123,321. What address was it sent to?

BITCOIN="bitcoin-cli"

# Get transaction ids from block 123321
blockhash=$($BITCOIN getblockhash 123321)
blockdata=$($BITCOIN getblock $blockhash)
transactions=$(echo $blockdata | jq -c -r '.tx[]')

# For each transaction...
for tx in ${transactions[@]}
do
    # Get outputs
    raw=$($BITCOIN getrawtransaction $tx)
    decoded=$($BITCOIN decoderawtransaction $raw)
    vouts=$(echo $decoded | jq -c -r '.vout[].n')

    # For each vout, check if it is spent or not
    for vout in ${vouts[@]}
    do
        # Inspect transaction: empty if transaction is spent
        filter=$($BITCOIN gettxout $tx $vout)

        # Found an unspent transaction: echo it and stop
        if [[ ! -z $filter ]]
        then
            address=$(echo $filter | jq -c -r '.scriptPubKey.address')
            echo $address
            break
        fi

    done
done
