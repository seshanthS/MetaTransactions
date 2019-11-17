const userMapperContract = artifacts.require('./mainnet/userMapper')
const request = require('request-promise')

module.exports = function(_deployer) {
  // Use deployer to state migration tasks.
  let instance = await _deployer.deploy(userMapperContract, "0xcb4ab6cfe062e99009dc8c6f0893d7236dab2f25")
  let nonce = await instance.methods.getNonce().call()
  var options = {
    uri: 'https:/localhost:3000/getByteCode',
    method: "POST",
    body: {
      hash: 'payload',
      v:"",
      r:"",
      s:""
    },
    json: true // Automatically parses the JSON string in the response
  };
  let bytecode = await request(options).catch(err=>console.log)
  console.log(bytecode);
  console.log(nonce)
  await instance.methods.deployWallet(bytecode).then(console.log)
};
