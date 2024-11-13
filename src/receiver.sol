// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";

contract Receiver is CCIPReceiver {

   bytes32 private _messageId;
   string private _text;

   /// @notice Constructor - Initializes the contract with the router address.
   /// @param router The address of the router contract.
   constructor(address router) CCIPReceiver(router) {}

   /// @notice Handle a received message
   /// @param message The cross-chain message being received.
   function _ccipReceive(
       Client.Any2EVMMessage memory message
   ) internal override {
       _messageId = message.messageId; // Store the messageId
       _text = abi.decode(message.data, (string)); // Decode and store the message text
   }

    /// @notice Gets the last received message.
    /// @return messageId The ID of the last received message.
    /// @return text The last received text.
    function getMessage()
        external
        view
        returns (bytes32 messageId, string memory text)
    {
        return (_messageId, _text);
    }
}