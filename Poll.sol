// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Poll {
    address public owner;
    string public pollName;
    string[] public options;
    mapping(address => uint256) public votes;
    mapping(string => uint256) public voteCounts;
    bool public pollOpen;

    event VoteCast(address indexed voter, string option);

    constructor(string memory _pollName, string[] memory _options) {
        owner = msg.sender;
        pollName = _pollName;
        options = _options;
        pollOpen = true;
    }

    function vote(string memory _option) public {
        require(pollOpen, "Poll is closed.");
        require(votes[msg.sender] == 0, "You have already voted.");

        bool optionFound = false;
        for (uint256 i = 0; i < options.length; i++) {
            if (keccak256(bytes(_option)) == keccak256(bytes(options[i]))) {
                optionFound = true;
                break;
            }
        }
        require(optionFound, "Invalid option.");

        votes[msg.sender] = 1;
        voteCounts[_option]++;
        emit VoteCast(msg.sender, _option);
    }

    function closePoll() public {
        require(msg.sender == owner, "Only the owner can close the poll.");
        pollOpen = false;
    }

    function getVoteCount(string memory _option) public view returns (uint256) {
        return voteCounts[_option];
    }

    function getOptions() public view returns (string[] memory) {
        return options;
    }
}