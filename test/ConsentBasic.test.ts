import { expect } from "chai";
import { ethers } from "hardhat";
import { ConsentBasic } from "../typechain-types";

describe("ConsentBasic", function () {
  let consentBasic: ConsentBasic;
  let owner: any;
  let user1: any;
  let user2: any;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    
    const ConsentBasicFactory = await ethers.getContractFactory("ConsentBasic");
    consentBasic = await ConsentBasicFactory.deploy();
    await consentBasic.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should deploy successfully", async function () {
      expect(await consentBasic.getAddress()).to.be.properAddress;
    });

    it("Should initialize with no consent", async function () {
      expect(await consentBasic.hasConsented(user1.address)).to.be.false;
    });

    it("Should initialize with zero request counts", async function () {
      expect(await consentBasic.accessRequestCount(user1.address)).to.equal(0);
      expect(await consentBasic.deletionRequestCount(user1.address)).to.equal(0);
    });
  });

  describe("Consent Management", function () {
    it("Should allow user to give consent", async function () {
      await expect(consentBasic.connect(user1).giveConsent())
        .to.emit(consentBasic, "ConsentUpdated")
        .withArgs(user1.address, true);
      
      expect(await consentBasic.hasConsented(user1.address)).to.be.true;
    });

    it("Should allow user to revoke consent", async function () {
      // First give consent
      await consentBasic.connect(user1).giveConsent();
      expect(await consentBasic.hasConsented(user1.address)).to.be.true;

      // Then revoke it
      await expect(consentBasic.connect(user1).revokeConsent())
        .to.emit(consentBasic, "ConsentUpdated")
        .withArgs(user1.address, false);
      
      expect(await consentBasic.hasConsented(user1.address)).to.be.false;
    });

    it("Should allow multiple users to manage consent independently", async function () {
      await consentBasic.connect(user1).giveConsent();
      await consentBasic.connect(user2).giveConsent();
      
      expect(await consentBasic.hasConsented(user1.address)).to.be.true;
      expect(await consentBasic.hasConsented(user2.address)).to.be.true;

      await consentBasic.connect(user1).revokeConsent();
      
      expect(await consentBasic.hasConsented(user1.address)).to.be.false;
      expect(await consentBasic.hasConsented(user2.address)).to.be.true;
    });
  });

  describe("Data Access Requests", function () {
    it("Should allow user to request data access", async function () {
      await expect(consentBasic.connect(user1).requestDataAccess())
        .to.emit(consentBasic, "AccessRequested")
        .withArgs(user1.address, 1);
      
      expect(await consentBasic.accessRequestCount(user1.address)).to.equal(1);
    });

    it("Should increment access request count on multiple requests", async function () {
      await consentBasic.connect(user1).requestDataAccess();
      expect(await consentBasic.accessRequestCount(user1.address)).to.equal(1);

      await consentBasic.connect(user1).requestDataAccess();
      expect(await consentBasic.accessRequestCount(user1.address)).to.equal(2);

      await consentBasic.connect(user1).requestDataAccess();
      expect(await consentBasic.accessRequestCount(user1.address)).to.equal(3);
    });

    it("Should track access requests per user independently", async function () {
      await consentBasic.connect(user1).requestDataAccess();
      await consentBasic.connect(user1).requestDataAccess();
      await consentBasic.connect(user2).requestDataAccess();

      expect(await consentBasic.accessRequestCount(user1.address)).to.equal(2);
      expect(await consentBasic.accessRequestCount(user2.address)).to.equal(1);
    });
  });

  describe("Deletion Requests", function () {
    it("Should allow user to request deletion", async function () {
      await expect(consentBasic.connect(user1).requestDeletion())
        .to.emit(consentBasic, "DeletionRequested")
        .withArgs(user1.address, 1);
      
      expect(await consentBasic.deletionRequestCount(user1.address)).to.equal(1);
    });

    it("Should increment deletion request count on multiple requests", async function () {
      await consentBasic.connect(user1).requestDeletion();
      expect(await consentBasic.deletionRequestCount(user1.address)).to.equal(1);

      await consentBasic.connect(user1).requestDeletion();
      expect(await consentBasic.deletionRequestCount(user1.address)).to.equal(2);

      await consentBasic.connect(user1).requestDeletion();
      expect(await consentBasic.deletionRequestCount(user1.address)).to.equal(3);
    });

    it("Should track deletion requests per user independently", async function () {
      await consentBasic.connect(user1).requestDeletion();
      await consentBasic.connect(user1).requestDeletion();
      await consentBasic.connect(user2).requestDeletion();

      expect(await consentBasic.deletionRequestCount(user1.address)).to.equal(2);
      expect(await consentBasic.deletionRequestCount(user2.address)).to.equal(1);
    });
  });

  describe("Complete Workflow", function () {
    it("Should handle complete GDPR workflow", async function () {
      // User gives consent
      await consentBasic.connect(user1).giveConsent();
      expect(await consentBasic.hasConsented(user1.address)).to.be.true;

      // User requests data access multiple times
      await consentBasic.connect(user1).requestDataAccess();
      await consentBasic.connect(user1).requestDataAccess();
      expect(await consentBasic.accessRequestCount(user1.address)).to.equal(2);

      // User requests deletion
      await consentBasic.connect(user1).requestDeletion();
      expect(await consentBasic.deletionRequestCount(user1.address)).to.equal(1);

      // User revokes consent
      await consentBasic.connect(user1).revokeConsent();
      expect(await consentBasic.hasConsented(user1.address)).to.be.false;

      // Counts should remain unchanged after consent revocation
      expect(await consentBasic.accessRequestCount(user1.address)).to.equal(2);
      expect(await consentBasic.deletionRequestCount(user1.address)).to.equal(1);
    });
  });

  describe("Gas Optimization", function () {
    it("Should measure gas usage for consent operations", async function () {
      const tx1 = await consentBasic.connect(user1).giveConsent();
      const receipt1 = await tx1.wait();
      console.log("Give consent gas used:", receipt1?.gasUsed.toString());

      const tx2 = await consentBasic.connect(user1).revokeConsent();
      const receipt2 = await tx2.wait();
      console.log("Revoke consent gas used:", receipt2?.gasUsed.toString());
    });

    it("Should measure gas usage for request operations", async function () {
      const tx1 = await consentBasic.connect(user1).requestDataAccess();
      const receipt1 = await tx1.wait();
      console.log("Request data access gas used:", receipt1?.gasUsed.toString());

      const tx2 = await consentBasic.connect(user1).requestDeletion();
      const receipt2 = await tx2.wait();
      console.log("Request deletion gas used:", receipt2?.gasUsed.toString());
    });
  });
});
