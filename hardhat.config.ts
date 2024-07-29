import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import "@nomicfoundation/hardhat-foundry";
import "@nomicfoundation/hardhat-web3-v4";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
};

export default config;
