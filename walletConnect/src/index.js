import WalletConnect from "@walletconnect/browser";
import WalletConnectQRCodeModal from "@walletconnect/qrcode-modal";
import Web3 from "web3";
import request from "request"

const web3 = new Web3()
const walletConnector = new WalletConnect({
    bridge: "https://bridge.walletconnect.matic.today",//"https://bridge.walletconnect.org", // Required 'https://walletconnect.matic.network'
      dappName:"MetaTransactions"
});

let sdk ={
    enable : async function(){
        return new Promise(async(resolve, reject)=>{
            if(!walletConnector.connected){
                await walletConnector.createSession()
                let uri = walletConnector.uri;
                WalletConnectQRCodeModal.open(uri,()=>{
                    console.log("close")
                }, false)
            }
            walletConnector.on('connect', async(err, payload)=>{
                if (err) {
                    //throw error;
                    reject(error)
                  }
                  WalletConnectQRCodeModal.close();
                  resolve("connected")
            })
        })
        
    },

    sign: async function(message){
        if(!walletConnector.connected){
            return "error"
        }else{
            let messageHash = web3.utils.keccak256("\x19Ethereum Signed Message:\n" + message.length + message)
            let inHex = await web3.utils.utf8ToHex(message)
            let personalSignature = await walletConnector.signPersonalMessage([inHex,walletConnector.accounts[0]])
            let signatureRaw = personalSignature.slice(2)
            const r = '0x' + signatureRaw.slice(0, 64)
            const s = '0x' + signatureRaw.slice(64, 128)
            const v = '0x' + signatureRaw.slice(128, 130)

            return {r ,s, v, messageHash}
        }
    },

    send : async function(data){

    },

    listener: walletConnector._eventManager
}


window.walletConnector = walletConnector;
window.sdk = sdk