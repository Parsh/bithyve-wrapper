package format

// UtxoTxReturn is the return structure used in /utxotxs
type UtxoTxReturn struct {
	Utxos        [][]Utxo             `json:"Utxos"`
	Transactions []MultigetAddrReturn `json:"Txs"`
}

// EIUtxoReturn is the reutrn structure used in /nutxotxs
type EIUtxoReturn map[string]UtxoTxReturn

// BalTxReturn is a struct used for the baltxs endpoint
type BalTxReturn struct {
	Balance      BalanceReturn
	Transactions []MultigetAddrReturn `json:"Txs"`
}

// TxReturn is used to return Txs
type TxReturn struct {
	Txs [][]Tx `json:"Txs"`
}

// BalanceReturn is a structure that is used for getting multiple balances
type BalanceReturn struct {
	Balance            float64
	UnconfirmedBalance float64
}

// MultigetAddrReturn is a structure used for multiple addresses json return
type MultigetAddrReturn struct {
	TotalTransactions       float64
	ConfirmedTransactions   float64
	UnconfirmedTransactions float64
	Transactions            []Tx
	Address                 string
}
