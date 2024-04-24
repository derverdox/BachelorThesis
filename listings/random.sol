    // #### Random Number Functions ###
    function randomNumber (uint256 seed) public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, msg.data, seed)));
    }