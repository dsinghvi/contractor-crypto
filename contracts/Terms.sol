// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0; 

contract Terms {

    string taskDescription;

    // Unix timestamp for expiry date
    uint256 expiry; 

    // TODO: Support >1 employers pooling their funds together
    address employerAddr;

    // TODO: Support >1 contractors receiving payment
    address contractorAddr; 

    PaymentTerms paymentTerms;

    ConsensusType consensusType;

}


/**
    Payment terms is an interface describing how the employee will be paid.
 */
contract PaymentTerms {

}

contract FlatFee is PaymentTerms {

    // TODO: How can we generalize this to other tokens and stable coins?
    uint amtInWei;

}

contract HourlyFee is PaymentTerms {

    uint hoursWorked;

    uint hourlyWage;

    // If hoursWorked * hourlyWage > maxFee, then only maxFee will be paid out.
    uint maxFee; 

}


/**
    ConsensusType is an interface describing how the job is verified.
 */
contract ConsensusType {

}

// If all parties agree on task completion, then the transaction will be paid out.
contract UnanimousVote is ConsensusType {

}

// The parties can choose a third party to verify task completion. 
contract ElectedThirdParty is ConsensusType {

    address thirdParty;

}

// Contract creator (us) decides verifies task completion.
contract CentralizedVerification is ConsensusType {

}