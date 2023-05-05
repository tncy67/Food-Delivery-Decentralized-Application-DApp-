pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract FoodDelivery {
    
    address payable public owner;
    uint256 public deliveryFee;
    
    struct Restaurant {
        string name;
        string location;
        bool isAvailable;
    }

    struct Order {
        uint256 orderId;
        uint256 restaurantId;
        address customer;
        string[] items;
        uint256 totalAmount;
        uint256 deliveryTimestamp;
        bool isDelivered;
    }
    
    Restaurant[] public restaurants;
    mapping(uint256 => Order) public orders;
    uint256 public nextOrderId;

    event OrderPlaced(uint256 indexed orderId, uint256 indexed restaurantId, address indexed customer, uint256 totalAmount);
    event OrderDelivered(uint256 indexed orderId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor (uint256 _deliveryFee) {
        owner = msg.sender;
        deliveryFee = _deliveryFee;
    }

    function addRestaurant(string memory _name, string memory _location) public onlyOwner {
        restaurants.push(Restaurant(_name, _location, true));
    }

    function setRestaurantAvailability(uint256 _restaurantId, bool _isAvailable) public onlyOwner {
        require(_restaurantId < restaurants.length, "Invalid restaurant ID.");
        restaurants[_restaurantId].isAvailable = _isAvailable;
    }

    function placeOrder(uint256 _restaurantId, string[] memory _items, uint256 _totalAmount) public payable {
        require(_restaurantId < restaurants.length, "Invalid restaurant ID.");
        require(restaurants[_restaurantId].isAvailable, "Selected restaurant is not available.");
        require(msg.value == _totalAmount + deliveryFee, "Incorrect payment amount.");
        
        uint256 orderId = nextOrderId++;
        orders[orderId] = Order(orderId, _restaurantId, msg.sender, _items, _totalAmount, 0, false);
        emit OrderPlaced(orderId, _restaurantId, msg.sender, _totalAmount);
    }

    function markOrderDelivered(uint256 _orderId) public onlyOwner {
        require(orders[_orderId].orderId != 0, "Invalid order ID.");
        require(!orders[_orderId].isDelivered, "Order already delivered.");
        
        orders[_orderId].isDelivered = true;
        orders[_orderId].deliveryTimestamp = block.timestamp;
        emit OrderDelivered(_orderId);
    }

    function withdrawFunds() public onlyOwner {
        owner.transfer(address(this).balance);
    }



}
