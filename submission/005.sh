#!/bin/bash

# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`

BITCOIN="bitcoin-cli"

txid=37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517

# Get transaction data
rawtransaction=$($BITCOIN getrawtransaction $txid)
decodedtransaction=$($BITCOIN decoderawtransaction $rawtransaction)
txins=$(echo $decodedtransaction | jq -cr '.vin[]')

# Manual inspection shows it consists of 4 p2wpkh inputs. Thus, second witness
# field must be the pubkeys.
pubkeys=$(echo $txins | jq -c '.txinwitness[1]')

# Build the argument for bitcoin-cli
ks="["
for key in ${pubkeys[@]}
do
    ks+=$key","
done
ks=${ks%","}"]"  # Remove trailing ',' and add closing ']'

# Now build the multisig address
multisig=$($BITCOIN createmultisig 1 "$ks")
multisigaddress=$(echo $multisig | jq -cr '.address')

echo $multisigaddress
