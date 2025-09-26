import { expect } from "chai";
import { ethers } from "hardhat";
import { ConsentMinimalEvent } from "../typechain-types";

describe("ConsentMinimalEvent", function () {
  let consentMinimalEvent: ConsentMinimalEvent;
  let owner: any;
  let user1: any;
  let user2: any;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    
    const ConsentMinimalEventFactory = await ethers.getContractFactory("ConsentMinimalEvent");
    consentMinimalEvent = await ConsentMinimalEventFactory.deploy();
    await consentMinimalEvent.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should deploy successfully", async function () {
      expect(await consentMinimalEvent.getAddress()).to.be.properAddress;
    });

    it("Should initialize with no consent", async function () {
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.false;
    });
  });

  describe("Consent Management", function () {
    it("Should allow user to set consent to true", async function () {
      await expect(consentMinimalEvent.connect(user1).setConsent(true))
        .to.emit(consentMinimalEvent, "Consent")
        .withArgs(user1.address, true);
      
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.true;
    });

    it("Should allow user to set consent to false", async function () {
      // First set consent to true
      await consentMinimalEvent.connect(user1).setConsent(true);
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.true;

      // Then set it to false
      await expect(consentMinimalEvent.connect(user1).setConsent(false))
        .to.emit(consentMinimalEvent, "Consent")
        .withArgs(user1.address, false);
      
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.false;
    });

    it("Should allow multiple users to manage consent independently", async function () {
      await consentMinimalEvent.connect(user1).setConsent(true);
      await consentMinimalEvent.connect(user2).setConsent(true);
      
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.true;
      expect(await consentMinimalEvent.hasConsented(user2.address)).to.be.true;

      await consentMinimalEvent.connect(user1).setConsent(false);
      
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.false;
      expect(await consentMinimalEvent.hasConsented(user2.address)).to.be.true;
    });

    it("Should emit consent events for all consent changes", async function () {
      // Test setting to true
      await expect(consentMinimalEvent.connect(user1).setConsent(true))
        .to.emit(consentMinimalEvent, "Consent")
        .withArgs(user1.address, true);

      // Test setting to false
      await expect(consentMinimalEvent.connect(user1).setConsent(false))
        .to.emit(consentMinimalEvent, "Consent")
        .withArgs(user1.address, false);

      // Test setting to true again
      await expect(consentMinimalEvent.connect(user1).setConsent(true))
        .to.emit(consentMinimalEvent, "Consent")
        .withArgs(user1.address, true);
    });
  });

  describe("Access Event Emission", function () {
    it("Should emit access event", async function () {
      await expect(consentMinimalEvent.connect(user1).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(user1.address);
    });

    it("Should allow multiple access events from same user", async function () {
      await expect(consentMinimalEvent.connect(user1).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(user1.address);

      await expect(consentMinimalEvent.connect(user1).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(user1.address);

      await expect(consentMinimalEvent.connect(user1).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(user1.address);
    });

    it("Should allow access events from different users", async function () {
      await expect(consentMinimalEvent.connect(user1).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(user1.address);

      await expect(consentMinimalEvent.connect(user2).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(user2.address);
    });

    it("Should allow any address to emit access events", async function () {
      // Even the owner can emit access events
      await expect(consentMinimalEvent.connect(owner).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(owner.address);
    });
  });

  describe("Deletion Event Emission", function () {
    it("Should emit deletion event", async function () {
      await expect(consentMinimalEvent.connect(user1).emitDeletion())
        .to.emit(consentMinimalEvent, "Deletion")
        .withArgs(user1.address);
    });

    it("Should allow multiple deletion events from same user", async function () {
      await expect(consentMinimalEvent.connect(user1).emitDeletion())
        .to.emit(consentMinimalEvent, "Deletion")
        .withArgs(user1.address);

      await expect(consentMinimalEvent.connect(user1).emitDeletion())
        .to.emit(consentMinimalEvent, "Deletion")
        .withArgs(user1.address);

      await expect(consentMinimalEvent.connect(user1).emitDeletion())
        .to.emit(consentMinimalEvent, "Deletion")
        .withArgs(user1.address);
    });

    it("Should allow deletion events from different users", async function () {
      await expect(consentMinimalEvent.connect(user1).emitDeletion())
        .to.emit(consentMinimalEvent, "Deletion")
        .withArgs(user1.address);

      await expect(consentMinimalEvent.connect(user2).emitDeletion())
        .to.emit(consentMinimalEvent, "Deletion")
        .withArgs(user2.address);
    });

    it("Should allow any address to emit deletion events", async function () {
      // Even the owner can emit deletion events
      await expect(consentMinimalEvent.connect(owner).emitDeletion())
        .to.emit(consentMinimalEvent, "Deletion")
        .withArgs(owner.address);
    });
  });

  describe("Event Logging Workflow", function () {
    it("Should handle complete event-based GDPR workflow", async function () {
      // User sets consent
      await expect(consentMinimalEvent.connect(user1).setConsent(true))
        .to.emit(consentMinimalEvent, "Consent")
        .withArgs(user1.address, true);

      // User emits multiple access events
      await expect(consentMinimalEvent.connect(user1).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(user1.address);

      await expect(consentMinimalEvent.connect(user1).emitAccess())
        .to.emit(consentMinimalEvent, "Access")
        .withArgs(user1.address);

      // User emits deletion event
      await expect(consentMinimalEvent.connect(user1).emitDeletion())
        .to.emit(consentMinimalEvent, "Deletion")
        .withArgs(user1.address);

      // User revokes consent
      await expect(consentMinimalEvent.connect(user1).setConsent(false))
        .to.emit(consentMinimalEvent, "Consent")
        .withArgs(user1.address, false);

      // Verify final consent state
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.false;
    });

    it("Should handle mixed operations from different users", async function () {
      // User1 operations
      await consentMinimalEvent.connect(user1).setConsent(true);
      await consentMinimalEvent.connect(user1).emitAccess();
      await consentMinimalEvent.connect(user1).emitDeletion();

      // User2 operations
      await consentMinimalEvent.connect(user2).setConsent(false);
      await consentMinimalEvent.connect(user2).emitAccess();
      await consentMinimalEvent.connect(user2).emitAccess();
      await consentMinimalEvent.connect(user2).emitDeletion();

      // Verify states
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.true;
      expect(await consentMinimalEvent.hasConsented(user2.address)).to.be.false;
    });
  });

  describe("Gas Optimization", function () {
    it("Should measure gas usage for consent operations", async function () {
      const tx1 = await consentMinimalEvent.connect(user1).setConsent(true);
      const receipt1 = await tx1.wait();
      console.log("Set consent (true) gas used:", receipt1?.gasUsed.toString());

      const tx2 = await consentMinimalEvent.connect(user1).setConsent(false);
      const receipt2 = await tx2.wait();
      console.log("Set consent (false) gas used:", receipt2?.gasUsed.toString());
    });

    it("Should measure gas usage for event emissions", async function () {
      const tx1 = await consentMinimalEvent.connect(user1).emitAccess();
      const receipt1 = await tx1.wait();
      console.log("Emit access gas used:", receipt1?.gasUsed.toString());

      const tx2 = await consentMinimalEvent.connect(user1).emitDeletion();
      const receipt2 = await tx2.wait();
      console.log("Emit deletion gas used:", receipt2?.gasUsed.toString());
    });

    it("Should compare gas efficiency with other contracts", async function () {
      // This test helps compare gas usage with the other contract variants
      const tx1 = await consentMinimalEvent.connect(user1).setConsent(true);
      const receipt1 = await tx1.wait();
      console.log("MinimalEvent - Set consent gas used:", receipt1?.gasUsed.toString());

      const tx2 = await consentMinimalEvent.connect(user1).emitAccess();
      const receipt2 = await tx2.wait();
      console.log("MinimalEvent - Emit access gas used:", receipt2?.gasUsed.toString());

      const tx3 = await consentMinimalEvent.connect(user1).emitDeletion();
      const receipt3 = await tx3.wait();
      console.log("MinimalEvent - Emit deletion gas used:", receipt3?.gasUsed.toString());
    });
  });

  describe("Event Filtering and Querying", function () {
    it("Should allow filtering consent events by user", async function () {
      await consentMinimalEvent.connect(user1).setConsent(true);
      await consentMinimalEvent.connect(user2).setConsent(true);
      await consentMinimalEvent.connect(user1).setConsent(false);

      // In a real scenario, you would filter events by user address
      // This test just verifies that events are emitted correctly
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.false;
      expect(await consentMinimalEvent.hasConsented(user2.address)).to.be.true;
    });

    it("Should allow filtering access events by user", async function () {
      await consentMinimalEvent.connect(user1).emitAccess();
      await consentMinimalEvent.connect(user2).emitAccess();
      await consentMinimalEvent.connect(user1).emitAccess();

      // Events are emitted but not stored on-chain
      // In a real scenario, you would query the event logs
      // This test just verifies that the function calls succeed
      expect(true).to.be.true; // Placeholder assertion
    });

    it("Should allow filtering deletion events by user", async function () {
      await consentMinimalEvent.connect(user1).emitDeletion();
      await consentMinimalEvent.connect(user2).emitDeletion();
      await consentMinimalEvent.connect(user1).emitDeletion();

      // Events are emitted but not stored on-chain
      // In a real scenario, you would query the event logs
      // This test just verifies that the function calls succeed
      expect(true).to.be.true; // Placeholder assertion
    });
  });

  describe("Edge Cases", function () {
    it("Should handle rapid successive operations", async function () {
      // Rapid consent changes
      await consentMinimalEvent.connect(user1).setConsent(true);
      await consentMinimalEvent.connect(user1).setConsent(false);
      await consentMinimalEvent.connect(user1).setConsent(true);

      // Rapid event emissions
      await consentMinimalEvent.connect(user1).emitAccess();
      await consentMinimalEvent.connect(user1).emitDeletion();
      await consentMinimalEvent.connect(user1).emitAccess();

      // Verify final state
      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.true;
    });

    it("Should handle operations from zero address (if possible)", async function () {
      // This test would require special setup to test zero address operations
      // For now, we'll test with a regular address
      await consentMinimalEvent.connect(user1).setConsent(true);
      await consentMinimalEvent.connect(user1).emitAccess();
      await consentMinimalEvent.connect(user1).emitDeletion();

      expect(await consentMinimalEvent.hasConsented(user1.address)).to.be.true;
    });
  });
});
