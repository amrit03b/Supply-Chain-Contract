// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    enum Status { Created, InTransit, Delivered }

    struct Product {
        uint256 id;
        string name;
        string origin;
        Status status;
        address owner;
    }

    mapping(uint256 => Product) public products;
    mapping(uint256 => string[]) public productHistory;
    uint256 public productCounter;

    event ProductCreated(uint256 id, string name, string origin);
    event StatusUpdated(uint256 id, Status status);

    constructor() {
        productCounter = 0;
    }

    function createProduct(string memory _name, string memory _origin) public {
        productCounter++;
        products[productCounter] = Product(productCounter, _name, _origin, Status.Created, msg.sender);
        productHistory[productCounter].push("Created");

        emit ProductCreated(productCounter, _name, _origin);
    }

    function updateStatus(uint256 _id, Status _status) public {
        require(products[_id].id != 0, "Product does not exist");
        require(products[_id].owner == msg.sender, "Only the owner can update the status");

        products[_id].status = _status;
        productHistory[_id].push(getStatusString(_status));

        emit StatusUpdated(_id, _status);
    }

    function getProduct(uint256 _id) public view returns (Product memory) {
        require(products[_id].id != 0, "Product does not exist");
        return products[_id];
    }

    function getProductHistory(uint256 _id) public view returns (string[] memory) {
        require(products[_id].id != 0, "Product does not exist");
        return productHistory[_id];
    }

    function getStatusString(Status _status) internal pure returns (string memory) {
        if (_status == Status.Created) return "Created";
        if (_status == Status.InTransit) return "In Transit";
        if (_status == Status.Delivered) return "Delivered";
        return "";
    }
}
