pragma solidity >=0.6.0;

import "./SafeMath.sol";

/*
    This contract is a token meant to replace Northeastern University's Husky Dollars and meal swipe programs.
    One pitfall of using a blockchain like this for payments is transaction time. One way to speed this up
    is for the people charging the students (dining hall, restaurants, etc), check the balance of the student
    address before charging them. This will ensure that a student has sufficient funds (or not) to make that purchase.
    If all checks out, the student can send the coins to the charger.

    Another way to do this to make it easier on the students is to add each charging address as an authority and then call transferFrom.
    This would remove the need for students paying for gas fees.
*/
contract NUCoin {

    using SafeMath for uint256;

    string public constant name = "NUCoin";
    string public constant symbol = "NU";
    string public constant standard = "NUCoin";
    uint8 public constant decimals = 2;
    address private initial_authority;
    //address[] public authorities;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // Keeps track of the _balances of all addresses.
    mapping(address => uint256) private _balances;

    // Keeps track of which addresses are authoritative.
    mapping(address => bool) private authorities;

    // Sets the initial authority address and gives that address the INITIAL_SUPPLY of coins.
    constructor() public {
        initial_authority = msg.sender;
        authorities[initial_authority] = true;
    }

    // Transfers a given amount of coins to the given address from the senders address.
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_balances[msg.sender] >= _value, "NUCoin/Economy/Insufficient funds to send.");

        _balances[msg.sender] -= _value;
        _balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    // Gets the balance of the given account.
    // I realized there's no real way to hide a student's balance because msg.sender can be spoofed for `view` functions.
    // Also, a student would have to know another student's address to be able to view it anyway.
    function balanceOf(address _addr) public view returns (uint256 balance) {
        return _balances[_addr];
    }

    // Checks whether the given account is authoritative.
    function isAuthority(address _addr) public view returns (bool result) {
        return authorities[_addr];
    }

    ////////// Authoritative functions \\\\\\\\\

    // Deposit funds into a given account. Must be an authoritative address.
    function addFunds(uint256 _amt, address _addr) external returns (bool success) {
        require(isAuthority(msg.sender), "NUCoin/Security/Cannot add funds from a non-authoritative address.");
        _balances[_addr].add(_amt);
        return true;
    }

    // Delete funds from an account. Must be an authoritative address.
    function removeFunds(uint256 _amt, address _addr) external returns (bool success) {
        require(isAuthority(msg.sender), "NUCoin/Security/A non-authoritative address cannot remove funds from another account.");
        _balances[_addr].sub(_amt, "NUCoin/Economy/Transfer amount exceeds balance");
        return true;
    }

    // Transfers a given amount of coins from `sender` to `recipient`.
    function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool success) {
        require(isAuthority(msg.sender), "NUCoin/Security/Cannot transferFrom non-authorative address.");
        _balances[sender] = _balances[sender].sub(amount, "NUCoin/Economy/Transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Adds an address to the list of authoritative accounts. Must be an authoritative address.
    function addAuthority(address _toAdd) public returns (bool success) {
        require(isAuthority(msg.sender), "NUCoin/Security/Cannot add authority from a non-authoritative address.");
        authorities[_toAdd] = true;
        return true;
    }

    // Removes an accounts authoritative access. Must be an authoritative address.
    function renounceAuthority(address _toRm) public returns (bool success) {
        require(isAuthority(msg.sender), "NUCoin/Security/Cannot remove authority from a non-authoritative address.");
        authorities[_toRm] = false;
        return true;
    }

}
