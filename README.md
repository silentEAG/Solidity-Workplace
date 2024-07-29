# My Solidity Environment

hardhat + forge + viem + web3js

## Setup

1. setup hardhat and forge
2. set `nodeLinker: node-modules` in `.yarnrc.yml` if using yarn v2.
3. add your private key to `.secret` file for interacting.

## Usage

expected workflow:

1. copy challenge code to `contracts/`
2. write solver contract and test with forge & hardhat in `tests/`
3. do remote interaction with hardhat & web3js in `scripts/`