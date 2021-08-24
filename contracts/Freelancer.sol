// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Freelancer {
    /* 
    *   1. Clients browse freelancers and suggest work.
    *   2. Freelancers accept work, and propose a plan of work.
    *   3. Clients accept the plan of work, and fund the contract.
    *   4. Freelancers start the work.
    *   5. Clients approve the approved work.
    *   6. Freelancers withdraw funds.
    */
    enum Status { proposal, accepted, funded, started, approved }

    struct Work {
        // client's description of work
        string description;
        // total payout for the work
        uint256 value;
        // status of the work
        Status status;
    }

    // Those who know, know
    Work work;

    // holds funds until work is complete
    uint256 escrow;

    // "payable" vs. "non-payable" addresses are defined at in Solidity at compile time.
    // You can use .transfer(...) and .send(...) on address payable, but not address.
    address payable public freelancer;
    address public client;

    event workProposed(address client);
    event workAccepted(address freelancer);
    // TODO: We can use events and "workStageIds" to manage stage-based work plan + payout
    event workFunded();
    event workStarted();
    event workApproved();

    // TODO: May be useful to initialize some state with contract deployment
    constructor() {}

    modifier onlyFreelancer() {
        require(msg.sender == freelancer);
        _;
    }

    modifier onlyClient() {
        require(msg.sender == client);
        _;
    }

    modifier checkWorkStatus(Status _status) {
        require(work.status == _status);
        _;
    }

    // "_" differentiates between function arguments and global variables
    modifier sufficientFunds(uint256 _value, uint256 _payment) {
        require(_payment == _value);
        _;
    }

    function proposeWork(string memory _description, uint _value) 
        public
        onlyClient
    {
        client = msg.sender;
        work = Work(_description, _value, Status.proposal);
        emit workProposed(client);
    }

    function acceptWork() 
        public
        onlyFreelancer
        checkWorkStatus(Status.proposal)
    {
        freelancer = payable(msg.sender);
        emit workAccepted(freelancer);
    }

    function fundWork() 
        public
        payable
        checkWorkStatus(Status.accepted)
        sufficientFunds(work.value, msg.value)
        onlyClient
    {
        work.status = Status.funded;
        escrow = msg.value;
        emit workFunded();
    }

    function startWork() 
        public
        onlyClient 
        checkWorkStatus(Status.funded)
    {
        work.status = Status.started;
        emit workStarted();
    }

    function approveWork() 
        public
        payable
        checkWorkStatus(Status.started)
        onlyClient
    {
        freelancer.transfer(escrow);
        work.status = Status.approved;
        emit workApproved();
    }
}