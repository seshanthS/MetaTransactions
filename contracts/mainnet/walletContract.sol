pragma solidity 0.5.12;
pragma experimental ABIEncoderV2;
contract userManager {
    function isValidRelayer(address) public returns (bool) ;
}

contract wallet{
    address userManagerAddress;
    userManager _userManager;
    
    uint nonce;
    
    address user;
    mapping(address => bool)authorisedAddresses; //user's own keys for accessing this contract wallet.
    
    mapping(bytes32 => bool)SignatureExists;
    mapping(bytes32 => uint)signatureValidity;
    
    event metaTxExecuted(address indexed _from, address indexed _relayer, address _to, uint _amount, uint _gas, uint _status);
    
    /* _signatureParams[0] = messageHash
       _signatureParams[1] = r
       _signatureParams[2] = s
    */
    constructor(address _userManagerAddress, bytes32[] memory _signatureParams, uint8 _v )public {
        userManagerAddress = _userManagerAddress;
        user = ecrecover(_signatureParams[0], _v, _signatureParams[1], _signatureParams[2]);
    }
    
    /* _signatureParams[0] = hash of message + nonce;
       _signatureParams[1] = r
       _signatureParams[2] = s
       
       returns uint: 0 - success, 3 - signatureExpired
    */
    function execute(address payable  _to, uint _amount, bytes memory _data, uint _gas, bytes32[] memory _signatureParams, uint8 _v, uint _signatureValidityInMinutes ) public returns (uint _status){
        _userManager = userManager(userManagerAddress);
        require(ecrecover(_signatureParams[0], _v, _signatureParams[1], _signatureParams[2]) == user, "Not a valid Signature");
        
        //if signature not exists, set it
        if(SignatureExists[_signatureParams[0]] == false){
            SignatureExists[_signatureParams[0]] = true;
            signatureValidity[_signatureParams[0]] = now +  _signatureValidityInMinutes * 1 minutes;
            
            //if signature exists and signatureValidity is less than current time, return 3(signature expired)
        }else if(SignatureExists[_signatureParams[0]] == true && signatureValidity[_signatureParams[0]] < now){
            return 3; // signature Expired
        }
        
        require( _userManager.isValidRelayer(msg.sender) == true , "Not a valid Relayer");
        if(_data.length == 0){
                nonce ++;
                _to.transfer(_amount);
             }else{
                 nonce++;
                assembly{
                    _status := call(_gas,_to,_amount, add(_data, 0x20),mload(_data),0,0) 
                }
            } 
        emit metaTxExecuted(address(this), msg.sender, _to, _amount, _gas, _status);
        return 0;
    }
    
    function isContract(address _addressToCheck)public view returns(bool result){
        uint size;
        assembly {
            size := extcodesize(_addressToCheck)
        }
        if(size > 0){
            return true;
        }else {
            return false;
        }
    }
    
    function getNonce() public view returns (uint){
        return nonce;
    }
    
    function () external payable{
        
    }
     
}