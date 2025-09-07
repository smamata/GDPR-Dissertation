"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const hardhat_1 = require("hardhat");
async function deploy(variant) {
    const name = variant === "basic" ? "ConsentBasic" : variant === "optimized" ? "ConsentOptimized" : "ConsentMinimalEvent";
    const Factory = await hardhat_1.ethers.getContractFactory(name);
    const contract = await Factory.deploy();
    await contract.waitForDeployment();
    return { name, address: await contract.getAddress(), instance: contract };
}
async function measureGas(fn) {
    const tx = await fn();
    const receipt = await tx.wait();
    return receipt && receipt.gasUsed ? receipt.gasUsed.toString() : "0";
}
async function run() {
    const users = Number(process.env.NUM_USERS || 100);
    const variant = (process.env.VARIANT || "basic");
    const { name, address, instance } = await deploy(variant);
    console.log(`Variant ${name} deployed at ${address}`);
    const [signer, ...others] = await hardhat_1.ethers.getSigners();
    const sample = others.slice(0, users);
    if (variant === "basic") {
        const gasConsent = await measureGas(() => instance.connect(signer).giveConsent());
        const gasAccess = await measureGas(() => instance.connect(signer).requestDataAccess());
        const gasDeletion = await measureGas(() => instance.connect(signer).requestDeletion());
        console.log(JSON.stringify({ variant: name, gas: { consent: gasConsent, access: gasAccess, deletion: gasDeletion } }));
    }
    else if (variant === "optimized") {
        const gasConsent = await measureGas(() => instance.connect(signer).setConsent(true));
        const addresses = sample.map((s) => s.address);
        const gasAccessBatch = await measureGas(() => instance.connect(signer).batchRecordAccess(addresses));
        const gasDeletionBatch = await measureGas(() => instance.connect(signer).batchRecordDeletion(addresses));
        console.log(JSON.stringify({ variant: name, gas: { consent: gasConsent, accessBatch: gasAccessBatch, deletionBatch: gasDeletionBatch }, batchSize: addresses.length }));
    }
    else {
        const gasConsent = await measureGas(() => instance.connect(signer).setConsent(true));
        const gasAccess = await measureGas(() => instance.connect(signer).emitAccess());
        const gasDeletion = await measureGas(() => instance.connect(signer).emitDeletion());
        console.log(JSON.stringify({ variant: name, gas: { consent: gasConsent, access: gasAccess, deletion: gasDeletion } }));
    }
}
run().catch((e) => {
    console.error(e);
    process.exit(1);
});
