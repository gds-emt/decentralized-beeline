pragma solidity ^0.4.0;

contract Beeline {
  address owner; // dapp owner

  uint constant FEE = 0.5 ether;
  uint constant MIN_OCCUPANCY_PCT = 50;
  uint constant SETTLEMENT_PERIOD = 3 days;

  struct Route {
    address operator;
    string title; // description
    uint collateral; // after fee
    uint price;
    uint settlementStarts;
    bool successful;   // Whether the route is successfully carried out (default: true)
    bool processed;    // Whether this route's payment has been processed (default: false)
    uint8 seats;
    uint8 sold;
    uint8 state; // 1: open, 2: boarding, 3: settlement, 4: final
  }

  mapping (uint => Route) public routes;
  mapping (uint => address[]) public ticketHolders; // for refund
  mapping (address => mapping (uint => bool)) public hasTicket;
  mapping (address => uint) public balances; // Withdraw-able user balances
  uint public routesCount = 0;
  uint feesCollected = 0;

  /**
   * -----------------
   * Events
   * -----------------
   */
  event RouteUpdated(uint id);

  /**
   * -----------------
   * Modifiers
   * -----------------
   */
  modifier onlyOwner {
    if (msg.sender != owner) {
      throw;
    }
    _;
  }

  modifier onlyOperator(uint _id) {
    if (msg.sender != routes[_id].operator) {
      throw;
    }
    _;
  }

  function Beeline() public {
    owner = msg.sender;
  }

  /**
   * Withdraw any funds in user withdraw-able balances
   */
  function withdraw(uint _amount) public {
    if (_amount == 0) {
      _amount = balances[msg.sender];
    }
    if (_amount > balances[msg.sender]) {
      throw;
    }

    balances[msg.sender] -= _amount;
    if (!msg.sender.call.value(_amount)()) {
      throw;
    }
  }

/**
 * ---------------
 * For customers
 * ---------------
 */
  function buyTicket(uint _id) public payable {
    if (
      msg.value != routes[_id].price ||      // Only accept exact same price because no change is provided
      routes[_id].state != 1 ||  // Open state
      hasTicket[msg.sender][_id] != true || // Not yet owning a ticket
      routes[_id].seats <= routes[_id].sold  // Seats available
    ) {
      throw;
    }

    routes[_id].sold++;
    hasTicket[msg.sender][_id] = true;
    ticketHolders[_id].push(msg.sender); // for refund
  }

/**
 * ---------------
 * For operators
 * ---------------
 */

  function addRoute(string _title, uint _price, uint8 _seats) public payable {
    if (_price == 0 || _seats == 0) {
      throw;
    }
    if (msg.value < FEE + _price * _seats * MIN_OCCUPANCY_PCT / 100) {
      throw; // not enough for collateral
    }

    uint id = routesCount;
    routes[id] = Route({
      operator: msg.sender,
      title: _title,
      collateral: msg.value - FEE,
      price: _price,
      settlementStarts: 0,
      successful: true,
      processed: false,
      seats: _seats,
      sold: 0,
      state: 1
    });

    RouteUpdated(id);
    ++routesCount;
  }

  function setBoardingState(uint _id) public onlyOperator(_id) {
    if (routes[_id].state != 1) {
      throw;
    }
    routes[_id].state = 2;
  }

  function setSettlementState(uint _id) public onlyOperator(_id) {
    if (routes[_id].state != 2) {
      throw;
    }
    routes[_id].state = 3;
    routes[_id].settlementStarts = now;
  }

  /**
   * Route that is in settlement state for longer than SETTLEMENT_PERIOD
   * is now deemed to have carried out successfully and operator is able to collect payments
   */
  function finalize(uint _id) public onlyOperator(_id) {
    if (
      routes[_id].state != 3 ||
      routes[_id].processed ||
      now - routes[_id].settlementStarts < SETTLEMENT_PERIOD // not yet after settlement period
    ) {
      throw;
    }

    routes[_id].state = 4;
    routes[_id].successful = true;
    processFunds(_id);
  }

/**
 * ---------------
 * For Dapp admin (arbitrator)
 * ---------------
 */

  /**
   * To arbitrate a Route that is in settlement state, whether the operator has delivered or not
   * @param _id Route ID that is already in settlement state
   * @param _successful Whether the route is deemed to have been successfully executed by the operator
   */
  function arbitrate(uint _id, bool _successful) public onlyOwner {
    // Purposely not checking for timeout here

    if (routes[_id].state != 3 || routes[_id].processed) {
      throw;
    }

    routes[_id].state = 4;
    routes[_id].successful = _successful;
    processFunds(_id);
  }

/**
 * ---------------
 * Private functions
 * ---------------
 */

 function processFunds(uint _id) private {
  if (routes[_id].processed || routes[_id].state != 4) {
    throw;
  }

  if (routes[_id].successful) {
    balances[routes[_id].operator] += routes[_id].collateral + routes[_id].sold * routes[_id].price;
  } else {
    balances[owner] += routes[_id].collateral; // owner keeps it
    // refund all users
    for (uint i = 0; i < ticketHolders[_id].length; ++i) {
      balances[ticketHolders[_id][i]] += routes[_id].price;
    }
  }

  routes[_id].processed = true;
 }


}
