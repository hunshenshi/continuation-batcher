#! /bin/bash

params_dir="./params"
output_dir="./output"

if [ ! -d "$params_dir" ]; then
    # If it doesn't exist, create it
    mkdir -p "$params_dir"
else
    echo "./params exists"
fi

if [ ! -d "$output_dir" ]; then
    # If it doesn't exist, create it
    mkdir -p "$output_dir"
else
    echo "./output exists"
fi

# Get the resource ready for tests
cargo test --release 

# verify generated proof for test circuits
cargo run --release -- --params ./params --output ./output verify --challenge poseidon --info output/test_circuit.loadinfo.json

# batch test proofs
cargo run --release -- --params ./params --output ./output batch -k 21 --openschema shplonk --challenge keccak --accumulator use-hash --info output/test_circuit.loadinfo.json --name batchsample --commits sample/batchinfo_empty.json

# verify generated proof for test circuits
cargo run --release -- --params ./params --output ./output verify --challenge keccak --info output/batchsample.loadinfo.json

# generate solidity
cargo run --release -- --params ./params --output ./output solidity -k 21 --challenge keccak --info output/batchsample.loadinfo.json
