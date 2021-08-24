// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0; 

contract Terms {
    // uint256 expiry;

    string taskDescription;
    address payable employerAddr;
    address payable contractorAddr; 
    uint amtInWei;

    constructor(
        string memory _taskDescription,
        address payable _employerAddr,
        address payable _contractorAddr) {
            taskDescription = _taskDescription;
            employerAddr = _employerAddr;
            contractorAddr = _contractorAddr;    
    }

    // Function that allows the employer to stake the max task fee
    function employerDepositMaxTaskFee() public payable {
        require(msg.sender == employerAddr, "Received deposit request from non employer. Only an employer can deposit max fee.");
        require(msg.value == amtInWei, "Employer does not have enough ether to stake");
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function setWorkStatus(bool workCompleted) public {
        require(msg.sender == employerAddr, "Only the employer can confirm if the work is completed");
        if (workCompleted) {
            contractorAddr.transfer(amtInWei);
        } else {
            employerAddr.transfer(amtInWei);
        }
    }

}