// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import {TestBaseUltra} from "./TestBaseUltra.sol";
import {Add2UltraVerifier} from "../../src/ultra/instance/Add2UltraVerifier.sol";
import {DifferentialFuzzer} from "../base/DifferentialFuzzer.sol";
import {IVerifier} from "../../src/interfaces/IVerifier.sol";

contract Add2UltraTest is TestBaseUltra {
    function setUp() public override(TestBaseUltra) {
        super.setUp();

        verifier = IVerifier(address(new Add2UltraVerifier()));
        fuzzer = fuzzer.with_circuit_flavour(DifferentialFuzzer.CircuitFlavour.Add2);

        PUBLIC_INPUT_COUNT = 2;

        // Add default inputs to the fuzzer (we will override these in fuzz test)
        uint256[] memory defaultInputs = new uint256[](3);
        defaultInputs[0] = 5;
        defaultInputs[1] = 10;
        defaultInputs[2] = 15;

        fuzzer = fuzzer.with_inputs(defaultInputs);
    }

    function testFuzzProof(uint128 input1, uint128 input2) public {
        uint256[] memory inputs = new uint256[](3);
        inputs[0] = uint256(input1);
        inputs[1] = uint256(input2);
        inputs[2] = inputs[0] + inputs[1];

        bytes memory proofData = fuzzer.with_inputs(inputs).generate_proof();

        assertTrue(verifier.verify(proofData), "The proof is not valid");
    }
}
