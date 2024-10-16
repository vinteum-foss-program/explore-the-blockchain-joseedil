#!/bin/bash

# Using descriptors, compute the 100th taproot address derived from this extended public key:
#   `xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2`

BITCOIN="bitcoin-cli"

# Get full descriptor
descriptor="tr(xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2/*)"
fulldescriptor=$($BITCOIN getdescriptorinfo $descriptor | jq -cr .descriptor)

# Derive address
address=$($BITCOIN deriveaddresses $fulldescriptor "[100,100]" | jq -cr '.[]')

echo $address
