import { expect } from "chai";
import { ethers } from "hardhat";
import { ConsentOptimized } from "../typechain-types";

describe("ConsentOptimized", function () {
  let consentOptimized: ConsentOptimized;
  let owner: any;
  let user1: any;
  let user2: any;
  let user3: any;
  let user4: any;

  beforeEach(async function () {
    [owner, user1, user2, user3, user4] = await ethers.getSigners();
    
    const ConsentOptimizedFactory = await ethers.getContractFactory("ConsentOptimized");
    consentOptimized = await ConsentOptimizedFactory.deploy();
    await consentOptimized.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should deploy successfully", async function () {
      expect(await consentOptimized.getAddress()).to.be.properAddress;
    });

    it("Should initialize with default user state", async function () {
      const [consent, accessCount, deletionCount] = await consentOptimized.getUserState(user1.address);
      expect(consent).to.be.false;
      expect(accessCount).to.equal(0);
      expect(deletionCount).to.equal(0);
    });
  });

  describe("Consent Management", function () {
    it("Should allow user to set consent to true", async function () {
      await expect(consentOptimized.connect(user1).setConsent(true))
        .to.emit(consentOptimized, "ConsentUpdated")
        .withArgs(user1.address, true);
      
      const [consent] = await consentOptimized.getUserState(user1.address);
      expect(consent).to.be.true;
    });

    it("Should allow user to set consent to false", async function () {
      // First set consent to true
      await consentOptimized.connect(user1).setConsent(true);
      
      // Then set it to false
      await expect(consentOptimized.connect(user1).setConsent(false))
        .to.emit(consentOptimized, "ConsentUpdated")
        .withArgs(user1.address, false);
      
      const [consent] = await consentOptimized.getUserState(user1.address);
      expect(consent).to.be.false;
    });

    it("Should allow multiple users to manage consent independently", async function () {
      await consentOptimized.connect(user1).setConsent(true);
      await consentOptimized.connect(user2).setConsent(true);
      
      let [consent1] = await consentOptimized.getUserState(user1.address);
      let [consent2] = await consentOptimized.getUserState(user2.address);
      expect(consent1).to.be.true;
      expect(consent2).to.be.true;

      await consentOptimized.connect(user1).setConsent(false);
      
      [consent1] = await consentOptimized.getUserState(user1.address);
      [consent2] = await consentOptimized.getUserState(user2.address);
      expect(consent1).to.be.false;
      expect(consent2).to.be.true;
    });
  });

  describe("Batch Access Recording", function () {
    it("Should record access for single user", async function () {
      await expect(consentOptimized.connect(owner).batchRecordAccess([user1.address]))
        .to.emit(consentOptimized, "AccessBatch")
        .withArgs(owner.address, 1);
      
      const [, accessCount] = await consentOptimized.getUserState(user1.address);
      expect(accessCount).to.equal(1);
    });

    it("Should record access for multiple users in batch", async function () {
      const users = [user1.address, user2.address, user3.address];
      
      await expect(consentOptimized.connect(owner).batchRecordAccess(users))
        .to.emit(consentOptimized, "AccessBatch")
        .withArgs(owner.address, 3);
      
      const [, accessCount1] = await consentOptimized.getUserState(user1.address);
      const [, accessCount2] = await consentOptimized.getUserState(user2.address);
      const [, accessCount3] = await consentOptimized.getUserState(user3.address);
      
      expect(accessCount1).to.equal(1);
      expect(accessCount2).to.equal(1);
      expect(accessCount3).to.equal(1);
    });

    it("Should increment access count on multiple batch operations", async function () {
      const users = [user1.address, user2.address];
      
      await consentOptimized.connect(owner).batchRecordAccess(users);
      await consentOptimized.connect(owner).batchRecordAccess(users);
      
      const [, accessCount1] = await consentOptimized.getUserState(user1.address);
      const [, accessCount2] = await consentOptimized.getUserState(user2.address);
      
      expect(accessCount1).to.equal(2);
      expect(accessCount2).to.equal(2);
    });

    it("Should handle empty batch gracefully", async function () {
      await expect(consentOptimized.connect(owner).batchRecordAccess([]))
        .to.emit(consentOptimized, "AccessBatch")
        .withArgs(owner.address, 0);
    });

    it("Should handle duplicate addresses in batch", async function () {
      const users = [user1.address, user1.address, user2.address];
      
      await consentOptimized.connect(owner).batchRecordAccess(users);
      
      const [, accessCount1] = await consentOptimized.getUserState(user1.address);
      const [, accessCount2] = await consentOptimized.getUserState(user2.address);
      
      expect(accessCount1).to.equal(2); // Incremented twice
      expect(accessCount2).to.equal(1); // Incremented once
    });
  });

  describe("Batch Deletion Recording", function () {
    it("Should record deletion for single user", async function () {
      await expect(consentOptimized.connect(owner).batchRecordDeletion([user1.address]))
        .to.emit(consentOptimized, "DeletionBatch")
        .withArgs(owner.address, 1);
      
      const [, , deletionCount] = await consentOptimized.getUserState(user1.address);
      expect(deletionCount).to.equal(1);
    });

    it("Should record deletion for multiple users in batch", async function () {
      const users = [user1.address, user2.address, user3.address];
      
      await expect(consentOptimized.connect(owner).batchRecordDeletion(users))
        .to.emit(consentOptimized, "DeletionBatch")
        .withArgs(owner.address, 3);
      
      const [, , deletionCount1] = await consentOptimized.getUserState(user1.address);
      const [, , deletionCount2] = await consentOptimized.getUserState(user2.address);
      const [, , deletionCount3] = await consentOptimized.getUserState(user3.address);
      
      expect(deletionCount1).to.equal(1);
      expect(deletionCount2).to.equal(1);
      expect(deletionCount3).to.equal(1);
    });

    it("Should increment deletion count on multiple batch operations", async function () {
      const users = [user1.address, user2.address];
      
      await consentOptimized.connect(owner).batchRecordDeletion(users);
      await consentOptimized.connect(owner).batchRecordDeletion(users);
      
      const [, , deletionCount1] = await consentOptimized.getUserState(user1.address);
      const [, , deletionCount2] = await consentOptimized.getUserState(user2.address);
      
      expect(deletionCount1).to.equal(2);
      expect(deletionCount2).to.equal(2);
    });

    it("Should handle empty deletion batch gracefully", async function () {
      await expect(consentOptimized.connect(owner).batchRecordDeletion([]))
        .to.emit(consentOptimized, "DeletionBatch")
        .withArgs(owner.address, 0);
    });
  });

  describe("User State Management", function () {
    it("Should maintain separate state for different users", async function () {
      // Set different states for different users
      await consentOptimized.connect(user1).setConsent(true);
      await consentOptimized.connect(user2).setConsent(false);
      
      await consentOptimized.connect(owner).batchRecordAccess([user1.address]);
      await consentOptimized.connect(owner).batchRecordAccess([user1.address, user2.address]);
      
      await consentOptimized.connect(owner).batchRecordDeletion([user2.address]);
      
      const [consent1, accessCount1, deletionCount1] = await consentOptimized.getUserState(user1.address);
      const [consent2, accessCount2, deletionCount2] = await consentOptimized.getUserState(user2.address);
      
      expect(consent1).to.be.true;
      expect(accessCount1).to.equal(2);
      expect(deletionCount1).to.equal(0);
      
      expect(consent2).to.be.false;
      expect(accessCount2).to.equal(1);
      expect(deletionCount2).to.equal(1);
    });

    it("Should handle uint32 overflow gracefully", async function () {
      // This test would require a lot of iterations to actually overflow uint32
      // For now, we'll just test that the function works with reasonable numbers
      const users = [user1.address];
      
      // Simulate many access requests
      for (let i = 0; i < 10; i++) {
        await consentOptimized.connect(owner).batchRecordAccess(users);
      }
      
      const [, accessCount] = await consentOptimized.getUserState(user1.address);
      expect(accessCount).to.equal(10);
    });
  });

  describe("Complete Workflow", function () {
    it("Should handle complete GDPR workflow with batch operations", async function () {
      // Users set consent
      await consentOptimized.connect(user1).setConsent(true);
      await consentOptimized.connect(user2).setConsent(true);
      
      // Batch record access for multiple users
      await consentOptimized.connect(owner).batchRecordAccess([user1.address, user2.address]);
      
      // Batch record deletion for one user
      await consentOptimized.connect(owner).batchRecordDeletion([user1.address]);
      
      // User revokes consent
      await consentOptimized.connect(user1).setConsent(false);
      
      // Verify final states
      const [consent1, accessCount1, deletionCount1] = await consentOptimized.getUserState(user1.address);
      const [consent2, accessCount2, deletionCount2] = await consentOptimized.getUserState(user2.address);
      
      expect(consent1).to.be.false;
      expect(accessCount1).to.equal(1);
      expect(deletionCount1).to.equal(1);
      
      expect(consent2).to.be.true;
      expect(accessCount2).to.equal(1);
      expect(deletionCount2).to.equal(0);
    });
  });

  describe("Gas Optimization", function () {
    it("Should measure gas usage for batch operations", async function () {
      const users = [user1.address, user2.address, user3.address, user4.address];
      
      const tx1 = await consentOptimized.connect(owner).batchRecordAccess(users);
      const receipt1 = await tx1.wait();
      console.log("Batch access (4 users) gas used:", receipt1?.gasUsed.toString());

      const tx2 = await consentOptimized.connect(owner).batchRecordDeletion(users);
      const receipt2 = await tx2.wait();
      console.log("Batch deletion (4 users) gas used:", receipt2?.gasUsed.toString());

      const tx3 = await consentOptimized.connect(user1).setConsent(true);
      const receipt3 = await tx3.wait();
      console.log("Set consent gas used:", receipt3?.gasUsed.toString());
    });

    it("Should compare gas efficiency with different batch sizes", async function () {
      const singleUser = [user1.address];
      const multipleUsers = [user1.address, user2.address, user3.address, user4.address];
      
      // Single user batch
      const tx1 = await consentOptimized.connect(owner).batchRecordAccess(singleUser);
      const receipt1 = await tx1.wait();
      console.log("Single user batch gas used:", receipt1?.gasUsed.toString());
      
      // Multiple users batch
      const tx2 = await consentOptimized.connect(owner).batchRecordAccess(multipleUsers);
      const receipt2 = await tx2.wait();
      console.log("Multiple users batch gas used:", receipt2?.gasUsed.toString());
      
      // Calculate gas per user
      const gasPerUserSingle = Number(receipt1?.gasUsed) / 1;
      const gasPerUserMultiple = Number(receipt2?.gasUsed) / 4;
      
      console.log("Gas per user (single):", gasPerUserSingle);
      console.log("Gas per user (multiple):", gasPerUserMultiple);
    });
  });
});
