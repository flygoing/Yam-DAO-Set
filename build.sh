#!/usr/bin/env bash
set -e

oops() {
    echo "$0:" "$@" >&2
    exit 1
}

[[ "$ETH_RPC_URL" ]] || oops "Please set a mainnet ETH_RPC_URL envar (such as http://localhost:8545)"

export DAPP_SRC=./contracts
export DAPP_SOLC_VERSION=0.6.12
export SOLC_FLAGS="--optimize --optimize-runs 50000"

dapp build

export ETH_RPC_URL=https://fee7372b6e224441b747bf1fde15b2bd.eth.rpc.rivet.cloud/

block=$(seth block latest)

export DAPP_TEST_TIMESTAMP=$(seth --field timestamp <<< "$block")
export DAPP_TEST_NUMBER=$(seth --field number <<< "$block")

export DAPP_TEST_ADDRESS="0x683A78bA1f6b25E29fbBC9Cd1BFA29A51520De84"
printf 'Running test for address %s\n' "0x683A78bA1f6b25E29fbBC9Cd1BFA29A51520De84"
LANG=C.UTF-8 hevm dapp-test --rpc="$ETH_RPC_URL"
