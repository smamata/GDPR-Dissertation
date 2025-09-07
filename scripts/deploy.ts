
import { ethers } from "hardhat";

async function main() {
  const variant = process.env.VARIANT || "basic"; // basic | optimized | minimal

  let contractName = "ConsentBasic";
  if (variant === "optimized") contractName = "ConsentOptimized";
  if (variant === "minimal") contractName = "ConsentMinimalEvent";

  const Factory = await ethers.getContractFactory(contractName);
  const contract = await Factory.deploy();
  await contract.waitForDeployment();

  const address = await contract.getAddress();
  console.log(`Deployed ${contractName} at`, address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});



