// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Agreement
 */

/*const { EAC, Util } = require('@ethereum-alarm-clock/lib');
const moment = require('moment');
const eac = new EAC(web3);*/

contract Agreement {

    //uint256 expirydays;
    
    
    address payable private employer;
    address payable private employee;
    uint256 private contractamount;
    mapping (address => string) ConfirmationValues;
    // declare an event
    event ConfirmationEvent(address sendconfirmationto);
    event ResolutionEvent(address employee, address employer, string message);
    event Transfer(address from_address, address to_address, uint256 value);
    string resMessage = "Employer and Employee do not agree on final decision of the job. It needs more time for resolution.";


    /**
     * triggers the confirmation for the task
     * expirytime in number of days
     
    async function triggersConfirmation(uint256 expirydays) public {
        const receipt = await eac.schedule({
            toAddress: '0xe87529A6123a74320e13A6Dabf3606630683C029',
            windowStart: moment().add(expirydays, 'day').unix() // 1 day from now
    });

    console.log(receipt);
        
    }*/
    
    constructor(address payable employeeAdr, uint256 amount) public {
      employee =   employeeAdr;
      employer = payable(msg.sender);
      contractamount  = amount;
      assert (employer.balance > contractamount);
   }
   
   function initiateContract () external payable{
       // need to transfer the contract and gas money
      emit Transfer(employer, address(this), contractamount);
   }
    

    function Completionconfirmation(address triggeraddress, bool completed) public {
        if (triggeraddress == employer) {
            if (completed) {
                // trigger a transaction to employee
                employee.transfer(contractamount);
                emit Transfer(employer, employee, contractamount);
            }
            else if (retrieve(employee)){
                if (keccak256(bytes(ConfirmationValues[employee])) == keccak256(bytes("Completed"))){
                        emit ResolutionEvent(employee, employer, resMessage);
                    }
                    else {
                        employer.transfer(contractamount);
                    }
            }
            else{
                emit ConfirmationEvent(employee);
            }
        }
        else if (triggeraddress == employee) {
            if (! completed){
                // trigger transaction back to employer
                employer.transfer(contractamount);
            }
            else if (retrieve(employer)){
                    if (keccak256(bytes(ConfirmationValues[employer])) == keccak256(bytes("Not Completed"))){
                        employee.transfer(contractamount);
                        emit Transfer(employer, employee, contractamount);
                    }
                    else {
                        emit ResolutionEvent(employee, employer, resMessage);
                    }
            }
            else{
                emit ConfirmationEvent(employer);
            }
        }
        
    }

    /**
     * @dev Return value 
     * @return if address confirmation present in the
     */
    function retrieve(address addressOfInterest) public view returns (bool){
        if(keccak256(bytes(ConfirmationValues[addressOfInterest])) == keccak256(bytes("Not Completed")) || 
        keccak256(bytes(ConfirmationValues[addressOfInterest])) == keccak256(bytes("Completed"))){
            return true;
        }
        return false;
    }
}