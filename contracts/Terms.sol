// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0; 

contract Terms {

    string taskDescription;

    // Unix timestamp for expiry date
    uint256 expiry; 

    // TODO: Support > 1 employers pooling their funds together
    address employerAddr;

    // TODO: Support > 1 contractors receiving payment
    address contractorAddr; 

    PaymentTerms paymentTerms;

    ConsensusType consensusType;

}


/**
    Payment terms is an interface describing how the employee will be paid.
 */
abstract contract PaymentTerms {

    function getPaymentAmount() public virtual view returns(uint);

}

contract FlatFee is PaymentTerms {

    // TODO: How can we generalize this to other tokens and stable coins?
    uint amtInWei;

    function getPaymentAmount() public virtual override view returns(uint) {
        return amtInWei;
    }

}

contract HourlyFee is PaymentTerms {

    uint hoursWorked;

    uint hourlyWageInWei;

    uint maxFeeInWei; 

    // If hoursWorked * hourlyWage > maxFee, then only maxFee will be paid out.
    function getPaymentAmount() public virtual override view returns(uint) {
        uint hourlyFee = hoursWorked * hourlyWageInWei;
        if (hourlyFee > maxFeeInWei) {
            return maxFeeInWei;
        }
        return hourlyFee;
    }

}


/**
    ConsensusType is an interface describing how the job is verified.
 */
abstract contract ConsensusType {

    function agreementReached() public virtual view returns(bool);

}

// If all parties agree on task completion, then the transaction will be paid out.
contract UnanimousVote is ConsensusType {

    bool employerVote = false;

    bool employeeVote = false;

    function setEmployerVote(bool _employerVote) public {
        employerVote = _employerVote;
    }

    function setEmployeeVote(bool _employeeVote) public {
        employeeVote = _employeeVote;
    }

    function agreementReached() public virtual override view returns(bool) {
        return employeeVote && employerVote;
    }
}

// The parties can choose a third party to verify task completion. 
contract ElectedThirdParty is ConsensusType {

    address thirdParty;

    bool thirdPartyVote = false;

    function setThirdPartyVote(bool _thirdPartyVote) public {
        thirdPartyVote = _thirdPartyVote;
    }

    function agreementReached() public virtual override view returns(bool) {
        return thirdPartyVote;
    }

}