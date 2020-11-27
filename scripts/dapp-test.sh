#!/usr/bin/env bash
set -e

oops() {
    echo "$0:" "$@" >&2
    exit 1
}

export ETH_RPC_URL="https://fee7372b6e224441b747bf1fde15b2bd.eth.rpc.rivet.cloud/"

export DAPP_SRC=./contracts
export DAPP_SOLC_VERSION=0.6.12
export SOLC_FLAGS="--optimize --optimize-runs 50000"

dapp build

block=$(seth block latest)

export DAPP_TEST_TIMESTAMP=$(seth --field timestamp <<< "$block")
export DAPP_TEST_NUMBER=$(seth --field number <<< "$block")
export DAPP_TEST_ORIGIN="0x683A78bA1f6b25E29fbBC9Cd1BFA29A51520De84"
export DAPP_TEST_CHAINED=99
export DAPP_TEST_ADDRESS="0x683A78bA1f6b25E29fbBC9Cd1BFA29A51520De84"
printf 'Running test for address %s\n' "$DAPP_TEST_ADDRESS"
LANG=C.UTF-8 dapp test --rpc-url "https://fee7372b6e224441b747bf1fde15b2bd.eth.rpc.rivet.cloud/" -v --match test_tm_sushibar_wrap_adapter #test_streamLifeCycle #test_kill #test_FullProp #test_LPVotingPower #test_LPVotingGov3 #test_newgov3 #test_helpers #test_rebaser #test_newgov3 #test_proposal_scenario

