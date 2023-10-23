// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const votingContract = await hre.ethers.getContractFactory("voting");
  const deployedVotingContarct = await votingContract.deploy();

  console.log(`Contaract Address deployed: ${deployedVotingContarct.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//Contaract Address deployed: 0x245a9700861335158d2fA7fEE2fB2085d7A4837F
//https://mumbai.polygonscan.com/address/0x245a9700861335158d2fA7fEE2fB2085d7A4837F#code