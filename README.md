# Cross-Chain Messaging DApp

This project demonstrates a cross-chain messaging system using two smart contracts: `Sender` and `Receiver`. The `Sender` contract, deployed on the Fuji testnet, initiates cross-chain messages, while the `Receiver` contract, deployed on the Polygon testnet, receives these messages. This setup allows seamless communication between two separate blockchain networks.

## Prerequisites

1. **Foundry**: Ensure Foundry is installed for compiling and deploying smart contracts.
2. **cast**: A CLI tool used to interact with the deployed smart contracts.
3. **Environment Variables**:
   - `FUJI_RPC`: RPC URL for the Fuji testnet.
   - `POL_RPC`: RPC URL for the Polygon testnet.
   - `FUJI_ROUTER_ADDRESS`: Address of the cross-chain router on the Fuji network.
   - `FUJI_LINK_ADDRESS`: Address of the LINK token on the Fuji network.
   - `POL_ROUTER_ADDRESS`: Address of the cross-chain router on the Polygon network.
   - `POL_CHAIN_SELECTOR`: Chain selector code for the Polygon network.

## Setting Up

Before deploying and using the contracts, import your deployer wallet:

cast wallet import deployer –interactive

This command will prompt you to input your wallet details, enabling `cast` to interact with your deployed contracts.

## Deployment Instructions

### 1. Deploy the `Sender` Contract on Fuji Network

Deploy the `Sender` contract on Fuji with the required constructor arguments:

forge create ./src/sender.sol:Sender –rpc-url $FUJI_RPC –constructor-args $FUJI_ROUTER_ADDRESS $FUJI_LINK_ADDRESS –account deployer

- **Contract**: `Sender`
- **Network**: Fuji
- **Arguments**: Router address and LINK token address on Fuji

### 2. Deploy the `Receiver` Contract on Polygon Network

Deploy the `Receiver` contract on Polygon with the necessary constructor argument:

forge create ./src/receiver.sol:Receiver –rpc-url $POL_RPC –constructor-args $POL_ROUTER_ADDRESS –account deployer

- **Contract**: `Receiver`
- **Network**: Polygon
- **Arguments**: Router address on Polygon

## Funding the `Sender` Contract

To fund the `Sender` contract on Fuji with LINK tokens for cross-chain communication fees, execute:

cast send $FUJI_LINK_ADDRESS –rpc-url $FUJI_RPC “transfer(address,uint256)” 0xbe193dEFf77a69f52c8bC12502C584dBc95d7465 5 –account deployer

- **Token**: LINK
- **Amount**: 5 LINK tokens
- **Recipient**: `Sender` contract address on Fuji

## Sending a Cross-Chain Message

To send a message from the `Sender` contract on Fuji to the `Receiver` contract on Polygon:

cast send 0xbe193dEFf77a69f52c8bC12502C584dBc95d7465 –rpc-url $FUJI_RPC “sendMessage(uint64, address, string)” $POL_CHAIN_SELECTOR 0x7B5b39bA736453B8cf87BeE6B883e3B09152afEc “CrossChain_by_Harsh” –account deployer

- **Message**: `"CrossChain_by_Harsh"`
- **Target Contract**: `Receiver` contract address on Polygon
- **Selector**: `POL_CHAIN_SELECTOR`

## Retrieving the Message on Polygon

To retrieve and view the message received by the `Receiver` contract on Polygon:

cast send 0x7B5b39bA736453B8cf87BeE6B883e3B09152afEc –rpc-url $POL_RPC “getMessage()” –account deployer

This command calls the `getMessage` function, allowing you to view the message sent from Fuji.

## Summary of Contract Addresses

- **Sender Contract on Fuji**: `0xbe193dEFf77a69f52c8bC12502C584dBc95d7465`
- **Receiver Contract on Polygon**: `0x7B5b39bA736453B8cf87BeE6B883e3B09152afEc`

## Notes

- Ensure sufficient LINK tokens are available in the `Sender` contract for cross-chain communication costs.
- Update `rpc-url`, contract addresses, and chain selectors as necessary for production use.
- Refer to individual chain documentation for additional RPC or configuration requirements.

## License

This project is open-sourced for educational and experimental purposes. Adjust code and values according to your project needs.