pragma solidity ^0.8.0;

contract FoodPickup {

    address public owner;

    enum Category {Asian, Mediterranean, Other}

    struct Restaurant {
        uint256 id;
        string name;
        string location;
        string[] keywords;
        Category category;
        string menu;
        uint256 openTime;
        uint256 closeTime;
        bool isVerified;
        bool isOpen;
    }

    Restaurant[] public restaurants;
    mapping(uint256 => Restaurant) public idToRestaurant;

    event RestaurantRegistered(uint256 indexed id, string indexed name, string indexed location);
    event RestaurantVerified(uint256 indexed id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerRestaurant(
        string memory _name,
        string memory _location,
        string[] memory _keywords,
        Category _category,
        string memory _menu,
        uint256 _openTime,
        uint256 _closeTime
    ) public {
        uint256 restaurantId = restaurants.length;
        Restaurant memory newRestaurant = Restaurant(
            restaurantId,
            _name,
            _location,
            _keywords,
            _category,
            _menu,
            _openTime,
            _closeTime,
            false,
            false
        );

        restaurants.push(newRestaurant);
        idToRestaurant[restaurantId] = newRestaurant;
        emit RestaurantRegistered(restaurantId, _name, _location);
    }

    function verifyRestaurant(uint256 _restaurantId) public onlyOwner {
        require(_restaurantId < restaurants.length, "Invalid restaurant ID.");
        require(!idToRestaurant[_restaurantId].isVerified, "Restaurant is already verified.");

        idToRestaurant[_restaurantId].isVerified = true;
        emit RestaurantVerified(_restaurantId);
    }

    function setOpenStatus(uint256 _restaurantId, bool _isOpen) public {
        require(msg.sender == owner || msg.sender == address(this), "Only owner or restaurant can call this function.");
        require(_restaurantId < restaurants.length, "Invalid restaurant ID.");
        idToRestaurant[_restaurantId].isOpen = _isOpen;
    }

    function getRestaurantsByCategory(Category _category) public view returns (Restaurant[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < restaurants.length; i++) {
            if (restaurants[i].category == _category && restaurants[i].isVerified) {
                count++;
            }
        }

        Restaurant[] memory filteredRestaurants = new Restaurant[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < restaurants.length; i++) {
            if (restaurants[i].category == _category && restaurants[i].isVerified) {
                filteredRestaurants[index] = restaurants[i];
                index++;
            }
        }

        return filteredRestaurants;
    }

    function getRestaurantsByKeyword(string memory _keyword) public view returns (Restaurant[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < restaurants.length; i++) {
            if (containsKeyword(restaurants[i], _keyword) && restaurants[i].isVerified) {
                count++;
            }
        }

        Restaurant[] memory filteredRestaurants = new Restaurant[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < restaurants.length; i++) {
            if (containsKeyword(restaurants[i], _keyword) && restaurants[i].isVerified) {
                filteredRestaurants[index] = restaurants[i];
                index++;
            }
        }

        return filteredRestaurants;
    }

    function containsKeyword(Restaurant memory _restaurant, string memory _keyword) private pure returns (bool) {
        for (uint256 i = 0; i < _restaurant.keywords.length; i++) {
            if (keccak256(abi.encodePacked(_restaurant.keywords[i])) == keccak256(abi.encodePacked(_keyword))) {
                return true;
            }
        }

        return false;
    }
}
