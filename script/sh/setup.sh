set -e

cast rpc anvil_impersonateAccount 0x90F79bf6EB2c4f870365E785982E1f101E93b906
cast send 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --from 0x90F79bf6EB2c4f870365E785982E1f101E93b906 "transfer(address,uint256)(bool)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 100000000000000000000
cast rpc anvil_impersonateAccount 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65
cast send 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC --from 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65 "transfer(address,uint256)(bool)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 100000000

forge script script/SetupLocal.s.sol -f http://127.0.0.1:8545 -vvvv --broadcast --slow --skip-simulation --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
