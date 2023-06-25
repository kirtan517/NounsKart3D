pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract ApeCoinGate {

    using SafeERC20 for IERC20;
    using EnumerableSet for EnumerableSet.AddressSet;

    
    // This are the variables 
    mapping(address => uint) public withoutCost;
    mapping(address => uint) public withCost;


    address public apecoinAddress;

    uint256 public minimumValue = 10 * 10**18; // 10 ApeCoins with 18 decimals

    constructor(address _apecoinAddress) {
        apecoinAddress = _apecoinAddress;
    }

    function setMinimumValue(uint256 newValue) external {
        require(newValue > 0, "Minimum value must be greater than 0");
        minimumValue = newValue;
    }


    function isApecoin(address coinAddress) internal view returns (bool) {
        return coinAddress == apecoinAddress;
    }



    function push_in_value(uint256 amount, address coinAddress) external payable {
        
        require(amount > minimumValue, "Amount must be greater than minimum Value");

        require(isApecoin(coinAddress),"Amount has to be in the form of Apecoin");
        
        IERC20 erc20 = IERC20(apecoinAddress);

        erc20.safeTransferFrom(msg.sender, address(this), amount);

        withCost[msg.sender] = amount;

    }


    function push_in_no_value(uint256 amount, address coinAddress) external payable {
                
        IERC20 erc20 = IERC20(apecoinAddress);

        erc20.safeTransferFrom(msg.sender, address(this), amount);

        withoutCost[msg.sender] = amount;

    }


    
}