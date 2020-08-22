pragma solidity >=0.6.0;

contract NUCoin {
    string public constant name = "NUCoin";
    string public constant symbol = "NU";
    string public constant standard = "NUCoin";
    uint8 public constant decimals = 2;
    uint64 private constant INITIAL_SUPPLY = 1000000000000;
    address private initial_authority;
    //address[] public authorities;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // Keeps track of the balances of all addresses.
    // This is kept private for the privacy of the students (AKA so students can't see how much other people have in their account).
    mapping(address => uint256) private balances;

    // Keeps track of which addresses are authoritative.
    mapping(address => bool) public authorities;

    // Sets the initial authority address and gives that address the INITIAL_SUPPLY of coins.
    constructor() public {
        initial_authority = msg.sender;
        authorities[initial_authority] = true;
        balances[msg.sender] = INITIAL_SUPPLY;
    }

    // Transfers a given amount of coins to the given address from the senders address.
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "NUCoin/Economy/Insufficient funds to send.");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    // Gets the balance of the calling account.
    function balanceOf(address _) external view returns (uint256 balance) {
        require(_ == msg.sender, "NUCoin/Privacy/Cannot view another account's balance.");
        return balances[msg.sender];
    }

    // Checks whether the given account is authoritative.
    function isAuthority(address _addr) public view returns (bool result) {
        return authorities[_addr];
    }

    ////////// Authoritative functions \\\\\\\\\

    // Allows for an authoritative address to view the balance of another account.
    function authViewBalance(address _addr) external view returns (uint256 balance) {
        require(isAuthority(msg.sender), "NUCoin/Security/Cannot access authViewBalence as a non-authoritative sender.");
        return balances[_addr];
    }

    // Deposit funds into a given account. Must be an authoritative address.
    function addFunds(uint256 _amt, address _addr) external returns (bool success) {
        require(isAuthority(msg.sender), "NUCoin/Security/Cannot add funds from a non-authoritative address.");
        balances[_addr] += _amt;
        return true;
    }

    // Delete funds from an account. Must be an authoritative address.
    function removeFunds(uint256 _amt, address _addr) external returns (bool success) {
        require(isAuthority(msg.sender), "NUCoin/Security/A non-authoritative address cannot remove funds from another account.");
        balances[_addr] -= _amt;
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
        //require(isAuthority(_toRm), "NUCoin/Security/Address being removed is not an authority.");
        authorities[_toRm] = false;
        return true;
    }

}
