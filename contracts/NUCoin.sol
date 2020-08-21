pragma solidity >=0.5.0;

contract NUCoin {
    string public constant name = "NUCoin";
    string public constant symbol = "XNU";
    string public constant standard = "NUCoin";
    uint8 public constant decimals = 2;
    uint64 private constant INITIAL_SUPPLY = 1000000000000;
    address private initial_authority;
    address[] public authorities;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // Keeps track of the balances of all addresses.
    // This is kept private for the privacy of the students (AKA so other students can't see how much other people have in their account).
    mapping(address => uint256) private balanceOf;

    // Sets the initial authority address and gives that address the INITIAL_SUPPLY of coins.
    constructor() public {
        initial_authority = msg.sender;
        authorities.push(initial_authority);
        balanceOf[msg.sender] = INITIAL_SUPPLY;
    }

    // Transfers a given amount of coins to the given address from the senders address.
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient funds to send.");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    // Gets the balance of the calling account.
    function getBalance() public view returns (uint256 balance) {
        return balanceOf[msg.sender];
    }

    // Deposit funds into a given account. Must be an authoritative address.
    function addFunds(uint256 _amt, address _addr) public returns (bool success) {
        require(isAuthority(msg.sender), "Cannot add funds from a non-authoritative address.");
        balanceOf[_addr] += _amt;
        return true;
    }

    // Delete funds from an account. Must be an authoritative address.
    function removeFunds(uint256 _amt, address _addr) public returns (bool success) {
        require(isAuthority(msg.sender), "A non-authoritative address cannot remove funds from another account.");
        balanceOf[_addr] -= _amt;
        return true;
    }

    // Adds an address to the list of authoritative accounts.
    function addAuthority(address _toAdd) public {
        require(isAuthority(msg.sender), "Cannot add authority from a non-authoritative address!");
        authorities.push(_toAdd);
    }

    // Checks whether the given account is authoritative.
    function isAuthority(address _addr) public view returns (bool result) {
        for (uint i = 0; i < authorities.length; i++) {
            if (authorities[i] == _addr) {
                return true;
            }
        }
        return false;
    }

}
