pragma solidity >=0.4.16 <0.7.0;

contract Example {
    function f() public payable returns (bytes4) {
        return this.f.selector;
    }

    function g() public {
        this.f.gas(10).value(800)();
    }
}
