// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";

contract Sender is OwnerIsCreator {

   IRouterClient private router;
   IERC20 private linkToken;

   /// @notice Initializes the contract with the router and LINK token address.
   /// @param _router The address of the router contract.
   /// @param _link The address of the link contract.
   constructor(address _router, address _link) {
       router = IRouterClient(_router);
       linkToken = IERC20(_link);
   }

   /// @notice Sends data to receiver on the destination chain.
   /// @param destinationChainSelector The identifier (aka selector) for the destination blockchain.
   /// @param receiver The address of the recipient on the destination blockchain.
   /// @param text The string text to be sent.
   /// @return messageId The ID of the message that was sent.
   function sendMessage(
       uint64 destinationChainSelector,
       address receiver,
       string calldata text
   ) external onlyOwner returns (bytes32 messageId) {
       Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
           receiver: abi.encode(receiver), // Encode receiver address
           data: abi.encode(text), // Encode text to send
           tokenAmounts: new Client.EVMTokenAmount[](0), // Empty array indicating no tokens are being sent
           extraArgs: Client._argsToBytes(
               Client.EVMExtraArgsV1({gasLimit: 200_000}) // Set gas limit
           ),
           feeToken: address(linkToken) // Set the LINK as the feeToken address
       });

       // Get the fee required to send the message
       uint256 fees = router.getFee(
           destinationChainSelector,
           message
       );

       // Revert if contract does not have enough LINK tokens for sending a message
       require(linkToken.balanceOf(address(this)) > fees, "Not enough LINK balance");

       // Approve the Router to transfer LINK tokens on contract's behalf in order to pay for fees in LINK
       linkToken.approve(address(router), fees);

       // Send the message through the router
       messageId = router.ccipSend(destinationChainSelector, message);

       // Return the messageId
       return messageId;
   }
}