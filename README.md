# MetaTransactions
Aim is to build a metaTransaction library for Unity. Currently smartContracts are completed.

## MetaTransactions in Blockchain Gaming.
MetaTransactions allows the player to interact with the blockhain without knowledge of blockchain. Gas required to interact wth 
the network will be payed by the game developers. 

## Archietecture - Nothing Much :P
Contract wallets will be generated using CREATE2 only after the user has enough funds to pay for the contract deployment.

## Relayers
Transactions from players are sumbitted to relayers who inturn submit it to the network. Relayers will pay the fee on behalf of the user.
Relayer Nodes will be written using Golang.

Nothing Much now... Will be updated soon...
