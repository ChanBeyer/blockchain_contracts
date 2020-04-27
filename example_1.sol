pragma solidity >=0.4.0 <0.7.0;

contract SimpleStorage {
    // A contract to store the value of a variable that can be rewritten and read
    uint storedData;
    function set(uint x) public {
        // the function to overwrite the value of the variable
        storedData = x;
    }
    function get() public view returns (uint) {
        // the function to retrieve the value of the variable
        return storedData;
    }
}
