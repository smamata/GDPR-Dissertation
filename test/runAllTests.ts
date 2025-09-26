import { ethers } from "hardhat";
import { exec } from "child_process";
import { promisify } from "util";

const execAsync = promisify(exec);

async function runTests() {
  console.log("🧪 Running GDPR Smart Contract Tests");
  console.log("=====================================\n");

  const testFiles = [
    { name: "ConsentBasic", file: "test/ConsentBasic.test.ts" },
    { name: "ConsentOptimized", file: "test/ConsentOptimized.test.ts" },
    { name: "ConsentMinimalEvent", file: "test/ConsentMinimalEvent.test.ts" }
  ];

  let totalTests = 0;
  let passedTests = 0;
  let failedTests = 0;

  for (const test of testFiles) {
    console.log(`📋 Running ${test.name} tests...`);
    try {
      const { stdout, stderr } = await execAsync(`npx hardhat test ${test.file}`);
      
      // Parse test results from output
      const lines = stdout.split('\n');
      const testResults = lines.filter(line => 
        line.includes('passing') || line.includes('failing') || line.includes('✓') || line.includes('✗')
      );
      
      console.log(`✅ ${test.name} tests completed successfully`);
      if (testResults.length > 0) {
        testResults.forEach(result => console.log(`   ${result}`));
      }
      
      passedTests++;
    } catch (error: any) {
      console.log(`❌ ${test.name} tests failed`);
      console.log(`   Error: ${error.message}`);
      failedTests++;
    }
    console.log("");
  }

  // Run gas report
  console.log("⛽ Running gas optimization tests...");
  try {
    const { stdout } = await execAsync("npx hardhat test --gas-report");
    console.log("✅ Gas report generated successfully");
    console.log(stdout);
  } catch (error: any) {
    console.log("❌ Gas report failed");
    console.log(`   Error: ${error.message}`);
  }

  console.log("\n📊 Test Summary");
  console.log("================");
  console.log(`Total test suites: ${testFiles.length}`);
  console.log(`Passed: ${passedTests}`);
  console.log(`Failed: ${failedTests}`);
  
  if (failedTests === 0) {
    console.log("\n🎉 All tests passed successfully!");
  } else {
    console.log(`\n⚠️  ${failedTests} test suite(s) failed. Please check the output above.`);
    process.exit(1);
  }
}

// Run the tests
runTests().catch((error) => {
  console.error("Test runner failed:", error);
  process.exit(1);
});
