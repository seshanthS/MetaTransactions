pragma solidity 0.5.12;

contract userMapper {
    
    address admin;
    bytes walletContractByteCode;
    mapping(bytes => address)walletContractAddress;
    mapping(address => bool)allowedRelayers;
    
    event userRegistered(bytes _name, address _walletAddress);
    
    constructor(address _admin, bytes memory _walletContractByteCode)public{
        admin = _admin;
        walletContractByteCode = _walletContractByteCode;
    }
    
    modifier onlyRelayers(){
        require(allowedRelayers[msg.sender], "Not a valid Relayer");
        _;
    }
    
    function registerUser(bytes memory _userName)public onlyRelayers returns (address){
        address _walletAddress = deployWallet(1);
        walletContractAddress[_userName] = _walletAddress;
        emit userRegistered(_userName, _walletAddress);
        return _walletAddress;
    }
    
    function deployWallet(uint _salt) internal returns (address){
        bytes memory _code = walletContractByteCode;
        address addressOfWallet;
        assembly{
            addressOfWallet := create2(0, add(_code, 0x20),mload(_code), _salt)
            if iszero(extcodesize(addressOfWallet)){
                revert(0,0)
            }
        }
        return addressOfWallet;
    }
        
    function setRelayerValid(address _relayerAddress) public {
        require(msg.sender == admin, "Not an admin");
        allowedRelayers[_relayerAddress] = true;
    }
    
    function getWalletAddress(bytes memory _userName)public view returns (address){
        return walletContractAddress[_userName];
    }
    
    function isValidRelayer(address _relayerAddress)public view returns (bool){
        return allowedRelayers[_relayerAddress];
    }

    function getAdminAddress() public view returns(address) {
        return admin;
    }
}
