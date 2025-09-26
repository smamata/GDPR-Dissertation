# GDPR Smart Contract Test Suite

This directory contains comprehensive test files for the GDPR compliance smart contracts.

## Test Files

### 1. ConsentBasic.test.ts
Tests for the baseline GDPR contract with straightforward storage:
- ✅ Consent management (give/revoke consent)
- ✅ Data access request tracking
- ✅ Deletion request tracking
- ✅ Event emission verification
- ✅ Gas usage measurement
- ✅ Complete workflow testing

### 2. ConsentOptimized.test.ts
Tests for the gas-optimized contract with packed storage and batch operations:
- ✅ Consent management with packed storage
- ✅ Batch access recording operations
- ✅ Batch deletion recording operations
- ✅ User state management
- ✅ Gas efficiency comparisons
- ✅ Edge cases and overflow handling

### 3. ConsentMinimalEvent.test.ts
Tests for the minimal storage contract using events as primary logs:
- ✅ Consent management with minimal storage
- ✅ Event emission for access requests
- ✅ Event emission for deletion requests
- ✅ Event filtering and querying capabilities
- ✅ Gas optimization measurements
- ✅ Rapid operation handling

## Running Tests

### Prerequisites
Make sure you have installed all dependencies:
```bash
npm install
```

### Compile Contracts
Before running tests, compile the contracts:
```bash
npm run build
```

### Run All Tests
```bash
# Run all test files
npm test

# Run with gas reporting
npm run test:gas

# Run comprehensive test suite with reporting
npm run test:all
```

### Run Individual Test Files
```bash
# Test ConsentBasic contract
npm run test:basic

# Test ConsentOptimized contract
npm run test:optimized

# Test ConsentMinimalEvent contract
npm run test:minimal
```

### Run Specific Test Suites
```bash
# Run only deployment tests
npx hardhat test --grep "Deployment"

# Run only gas optimization tests
npx hardhat test --grep "Gas Optimization"

# Run with verbose output
npx hardhat test --verbose
```

## Test Coverage

Each test file covers:

### Core Functionality
- ✅ Contract deployment and initialization
- ✅ Basic CRUD operations
- ✅ Event emission verification
- ✅ State management

### Edge Cases
- ✅ Multiple user interactions
- ✅ Rapid successive operations
- ✅ Empty batch operations
- ✅ Duplicate address handling
- ✅ Overflow scenarios

### Gas Optimization
- ✅ Gas usage measurement
- ✅ Batch operation efficiency
- ✅ Storage optimization verification
- ✅ Comparison between contract variants

### GDPR Compliance
- ✅ Consent management workflows
- ✅ Data access request tracking
- ✅ Deletion request handling
- ✅ Complete user journey testing

## Test Structure

Each test file follows this structure:
```typescript
describe("ContractName", function () {
  // Setup and deployment
  beforeEach(async function () {
    // Deploy contract and get signers
  });

  describe("Feature Group", function () {
    it("Should test specific functionality", async function () {
      // Test implementation
    });
  });
});
```

## Gas Reporting

The test suite includes gas usage measurements to help optimize contract performance:

- **ConsentBasic**: Baseline gas usage for comparison
- **ConsentOptimized**: Packed storage and batch operation efficiency
- **ConsentMinimalEvent**: Minimal storage with event-based logging

Run `npm run test:gas` to see detailed gas reports for all contracts.

## Continuous Integration

These tests are designed to run in CI/CD pipelines:
- No external dependencies required
- Deterministic test results
- Comprehensive error handling
- Clear test output and reporting

## Troubleshooting

### Common Issues

1. **Compilation Errors**: Run `npm run build` first
2. **Type Errors**: Ensure TypeScript types are generated with `npx hardhat compile`
3. **Gas Estimation Failures**: Check network configuration in hardhat.config.ts

### Debug Mode
Run tests with debug output:
```bash
DEBUG=hardhat:* npx hardhat test
```

## Contributing

When adding new tests:
1. Follow the existing test structure
2. Include both positive and negative test cases
3. Add gas usage measurements where relevant
4. Update this README with new test coverage
5. Ensure tests pass in CI environment
