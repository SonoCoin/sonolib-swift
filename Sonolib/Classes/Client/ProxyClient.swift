//
//  ProxyClient.swift
//  
//
//  Created by Tim Notfoolen on 06.07.2020.
//

import Foundation
import Alamofire

public class ProxyClient {

    public let baseAddr: String
    public let client: Client

    static private let gas = UInt64(100000000000)
    static private let fee = UInt64(0)
    static private let gasPrice = UInt64(0)
    static private let commission = UInt64(0)

    public init(baseAddr: String) {
        self.baseAddr = baseAddr
        self.client = Client(baseAddr: baseAddr)
    }

    public func getNetworks(success: (([NetworkDto]) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/info/networks"
        do {
            try self.client.get(url: url, type: [NetworkDto].self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func getHistory(network: String, address: String, success: (([HistoryItemDto]) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/history/\(network)/\(address)"
        do {
            try self.client.get(url: url, type: [HistoryItemDto].self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
    public func getHistorySample(network: String, address: String, success: (([HistoryItemDto]) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/history/\(network)/\(address)/sample"
        do {
            try self.client.get(url: url, type: [HistoryItemDto].self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func getBalance(network: String, address: String, success: ((BalanceExtendedDto) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/wallets/\(network)/\(address)/balance"
        do {
            try self.client.get(url: url, type: BalanceExtendedDto.self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func getBalances(network: String, addresses: [String], success: (([BalanceExtendedDto]) -> Void)?, error: ((String) -> Void)?) {
        let req = BalanceRequestDto(addresses: addresses)
        
        let url = self.baseAddr + "/wallets/\(network)/balances"
        do {
            try self.client.post(url: url, data: req, type: [BalanceExtendedDto].self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func getTokenBalances(network: String, address: String, success: (([ContractBalanceDto]) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/contracts/\(network)/\(address)/balances"
        do {
            try self.client.get(url: url, type: [ContractBalanceDto].self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    // static call
    public func staticCall(network: String, contract: String, payload: String, success: ((String) -> Void)?, error: ((String) -> Void)?) {
        let req = StaticCallRequestDto(address: contract, payload: payload)

        let url = self.baseAddr + "/node/\(network)/contract/static_call"
        do {
            try self.client.post(url: url, data: req, type: StaticCallDto.self, success: { staticCall in
                success?(staticCall.result)
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    // consumed fee
    public func consumedFee(network: String, sender: String, contract: String?, payload: String, success: ((UInt64) -> Void)?, error: ((String) -> Void)?) {
        self.consumedFee(network: network, sender: sender, contract: contract, payload: payload, value: Sono.zero, commission: Sono.zero, success: success, error: error)
    }

    public func consumedFee(network: String, sender: String, contract: String?, payload: String, value: UInt64, commission: UInt64, success: ((UInt64) -> Void)?, error: ((String) -> Void)?) {
        let req = ContractMessageDto(sender: sender, address: contract, payload: payload, value: value, gas: commission)

        let url = self.baseAddr + "/node/\(network)/contract/consumed_fee"
        do {
            try self.client.post(url: url, data: req, type: ConsumedFeeResponseDto.self, success: { resp in
                success?(resp.consumedFee)
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func getContracts(network: String, success: (([ContractDto]) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/contracts/\(network)"
        do {
            try self.client.get(url: url, type: [ContractDto].self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func getContract(network: String, address: String, success: ((ContractDto) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/contracts/\(network)/\(address)"
        do {
            try self.client.get(url: url, type: ContractDto.self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func getCoinContract(network: String, success: ((ContractCoinDto) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/contracts/\(network)/coin"
        do {
            try self.client.get(url: url, type: ContractCoinDto.self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    private func getNonce(network: String, address: String, success: ((NonceDto) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/node/\(network)/account/\(address)/nonce"
        do {
            try self.client.get(url: url, type: NonceDto.self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    private func getAllowanceNonce(network: String, address: String, success: ((NonceDto) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/node/\(network)/wallet/\(address)/allowance_nonce"
        do {
            try self.client.get(url: url, type: NonceDto.self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    private func send(network: String, tx: TransactionRequest, success: ((Bool) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/node/\(network)/txs/publish"
        do {
            try self.client.post(url: url, data: tx, type: TxPublishResponseDto.self, success: { res in
                success?(res.result == "ok")
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func send(network: String, words: String, walletIndex: Int, receiver: String, amount: Decimal, success: ((Bool) -> Void)?, error: ((String) -> Void)?) {
        do {
            let val = amount.satoshi
            
            let mnemonic = try Mnemonic(words: words)
            let hd = try mnemonic.toHD(index: walletIndex)
            let sender = hd.toWallet().base58Address
            
            self.getNonce(network: network, address: sender, success: { nonce in
                do {
                    let tx = try TransactionRequest()
                        .addCommission(gasPrice: ProxyClient.gasPrice, transferCommission: ProxyClient.gas)
                        .addSender(address: sender, key: hd, value: val, nonce: nonce.unconfirmedNonce)
                        .addTransfer(address: receiver, value: val)
                        .sign()
                    
                    self.send(network: network, tx: tx, success: success, error: error)
                } catch let err {
                    error?(err.localizedDescription)
                }
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func sendToken(network: String, words: String, walletIndex: Int, contractAddress: String, receiver: String, amount: Decimal, success: ((Bool) -> Void)?, error: ((String) -> Void)?) {
        do {
            let mnemonic = try Mnemonic(words: words)
            let hd = try mnemonic.toHD(index: walletIndex)
            let sender = hd.toWallet().base58Address
            
            self.getContract(network: network, address: contractAddress, success: { contract in
                guard let decimals = contract.decimals else {
                    error?("Invalid contract")
                    return
                }
                let multiplier = pow(10, decimals)
                let val = (amount * multiplier).uint64
                
                do {
                    let payload = try Erc20Transfer.getTransferPayload(address: receiver, amount: val)
                    
                    self.consumedFee(network: network, sender: sender, contract: contractAddress, payload: payload, success: { consumedFee in
                        self.getNonce(network: network, address: sender, success: { nonce in
                            do {

                                let tx = try Erc20Transfer()
                                    .addCommission(gasPrice: ProxyClient.gasPrice)
                                    .addSender(address: sender, key: hd, value: ProxyClient.commission, nonce: nonce.unconfirmedNonce)
                                    .addTransfer(contract: contractAddress, address: receiver, amount: val, gas: consumedFee)
                                    .sign()
                                
                                self.send(network: network, tx: tx, success: success, error: error)
                            } catch let err {
                                error?(err.localizedDescription)
                            }
                        }, error: error)
                    }, error: error)
                } catch let err {
                    error?(err.localizedDescription)
                }
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
    // Coins
    public func createCoin(network: String, words: String, walletIndex: Int, contract: String, amount: Decimal, success: ((String) -> Void)?, error: ((String) -> Void)?) {
        do {
            let val = amount.satoshi
            
            let mnemonic = try Mnemonic(words: words)
            let hd = try mnemonic.toHD(index: walletIndex)
            let sender = hd.toWallet().base58Address
            
            self.getNonce(network: network, address: sender, success: { nonce in
                self.getAllowanceNonce(network: network, address: sender, success: { allowanceNonce in
                    do {
                        let coin = try Coin()
                        let payload = try Coin.getCreateCoinPayload(hd: hd, coinPk: coin.keys.publicKey.hex, amount: val, nonce: allowanceNonce.unconfirmedNonce)
                    
                        self.consumedFee(network: network, sender: sender, contract: contract, payload: payload, success: { consumedFee in
                            do {
                               let tx = try TransactionRequest()
                                   .addCommission(gasPrice: ProxyClient.gasPrice, transferCommission: ProxyClient.gas)
                                   .addSender(address: sender, key: hd, value: ProxyClient.commission, nonce: nonce.unconfirmedNonce)
                                    .addContractExecution(sender: sender, address: contract, input: payload, value: Sono.zero, gas: consumedFee)
                                   .sign()

                               self.send(network: network, tx: tx, success: { result in
                                   success?(coin.keys.secretKey.hex)
                               }, error: error)
                            } catch let err {
                               error?(err.localizedDescription)
                            }
                        }, error: error)
                    } catch let err {
                        error?(err.localizedDescription)
                    }
                }, error: error)
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    public func getCoinInfo(network: String, contract: String, coinSecretKey: String, success: ((Decimal) -> Void)?, error: ((String) -> Void)?) {
        do {
            let coin = try Coin(secretKey: coinSecretKey)
            let payload = Coin.getInfoPayload(coinPk: coin.keys.publicKey.hex)
            
            self.staticCall(network: network, contract: contract, payload: payload, success: { res in
                do {
                    let coinInfo = try res.toCoinInfo()
                    let amount = Decimal(coinInfo.amount) / Decimal(Sono.currencyDivider)
                    success?(amount)
                } catch let err {
                    error?(err.localizedDescription)
                }
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
    public func spendCoin(network: String, words: String, walletIndex: Int, contract: String, coinSecretKey: String, success: ((Bool) -> Void)?, error: ((String) -> Void)?) {
        do {
            let coin = try Coin(secretKey: coinSecretKey)
            let mnemonic = try Mnemonic(words: words)
            let hd = try mnemonic.toHD(index: walletIndex)
            let sender = hd.toWallet().base58Address
            
            self.getNonce(network: network, address: sender, success: { nonce in
                do {
                    let payload = try Coin.getSpendCoinPayload(keys: coin.keys, receiver: sender)
                    
                    self.consumedFee(network: network, sender: sender, contract: contract, payload: payload, success: { consumedFee in
                        do {
                            let tx = try TransactionRequest()
                                .addCommission(gasPrice: ProxyClient.gasPrice, transferCommission: ProxyClient.gas)
                                .addSender(address: sender, key: hd, value: ProxyClient.commission, nonce: nonce.unconfirmedNonce)
                                .addContractExecution(sender: sender, address: contract, input: payload, value: Sono.zero, gas: consumedFee)
                                .sign()
                            
                            self.send(network: network, tx: tx, success: success, error: error)
                        } catch let err {
                            error?(err.localizedDescription)
                        }
                    }, error: error)
                } catch let err {
                    error?(err.localizedDescription)
                }
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
    // Token coins
    public func createTokenCoin(network: String, words: String, walletIndex: Int, contractAddress: String, amount: Decimal, success: ((String) -> Void)?, error: ((String) -> Void)?) {
        do {
            let mnemonic = try Mnemonic(words: words)
            let hd = try mnemonic.toHD(index: walletIndex)
            let sender = hd.toWallet().base58Address
            let coin = try Coin()

            self.getContract(network: network, address: contractAddress, success: { contract in
                guard let decimals = contract.decimals else {
                    error?("Invalid contract")
                    return
                }
                
                let multiplier = pow(10, decimals)
                let val = (amount * multiplier).uint64
                let payload = Erc20Transfer.getApprovePayload(coinPk: coin.keys.publicKey, amount: val)
                
                self.getNonce(network: network, address: sender, success: { nonce in
                    self.consumedFee(network: network, sender: sender, contract: contract.address, payload: payload, success: { consumedFee in
                        do {
                            let tx = try TransactionRequest()
                                .addCommission(gasPrice: ProxyClient.gasPrice, transferCommission: ProxyClient.gas)
                                .addSender(address: sender, key: hd, value: ProxyClient.commission, nonce: nonce.unconfirmedNonce)
                                .addContractExecution(sender: sender, address: contract.address, input: payload, value: Sono.zero, gas: consumedFee)
                                .sign()
                            
                            self.send(network: network, tx: tx, success: { result in
                                success?(coin.keys.secretKey.hex)
                            }, error: error)

                        } catch let err {
                            error?(err.localizedDescription)
                        }
                    }, error: error)
                }, error: error)
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }

    private func _getCoinTokenInfo(network: String, owner: String, contractAddress: String, coinSecretKey: String, success: ((UInt64) -> Void)?, error: ((String) -> Void)?) {
        do {
            let coin = try Coin(secretKey: coinSecretKey.hex)
            let hd = HD(keyPair: coin.keys)
            let spender = hd.toWallet().base58Address
            let payload = try Erc20Transfer.getAllowancePayload(owner: owner, spender: spender)
            
            self.staticCall(network: network, contract: contractAddress, payload: payload, success: { staticCall in
                success?(staticCall.hex.buint64)
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
    public func getTokenCoinInfo(network: String, owner: String, contractAddress: String, coinSecretKey: String, success: ((Decimal) -> Void)?, error: ((String) -> Void)?) {
        self.getContract(network: network, address: contractAddress, success: { contract in
            guard let decimals = contract.decimals else {
                error?("Invalid contract")
                return
            }
            let multiplier = pow(10, decimals)
            self._getCoinTokenInfo(network: network, owner: owner, contractAddress: contractAddress, coinSecretKey: coinSecretKey, success: { amount in
                let res = Decimal(amount)
                success?(res / multiplier)
            }, error: error)
        }, error: error)
    }
    
    public func spendTokenCoin(network: String, words: String, walletIndex: Int, owner: String, contract: String, coinSecretKey: String, success: ((Bool) -> Void)?, error: ((String) -> Void)?) {
        do {
            let coin = try Coin(secretKey: coinSecretKey.hex)
            let hd = HD(keyPair: coin.keys)
            let sender = hd.toWallet().base58Address
            
            let mnemonic = try Mnemonic(words: words)
            let hd2 = try mnemonic.toHD(index: walletIndex)
            let receiver = hd2.toWallet().base58Address
            
            self._getCoinTokenInfo(network: network, owner: owner, contractAddress: contract, coinSecretKey: coinSecretKey, success: { amount in
                do {
                    let payload = try Erc20Transfer.getTransferFromPayload(sender: owner, receiver: receiver, amount: amount)
                    
                    self.getNonce(network: network, address: sender, success: { nonce in
                        self.consumedFee(network: network, sender: sender, contract: contract, payload: payload, success: { consumedFee in
                            do {
                                let tx = try TransactionRequest()
                                    .addCommission(gasPrice: ProxyClient.gasPrice, transferCommission: ProxyClient.gas)
                                    .addSender(address: sender, key: hd, value: ProxyClient.commission, nonce: nonce.unconfirmedNonce)
                                    .addContractExecution(sender: sender, address: contract, input: payload, value: Sono.zero, gas: ProxyClient.gas)
                                    .sign()
                            
                                self.send(network: network, tx: tx, success: success, error: error)

                            } catch let err {
                                error?(err.localizedDescription)
                            }
                        }, error: error)
                    }, error: error)
                } catch let err {
                    error?(err.localizedDescription)
                }
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
    // Token builder
    public func createToken(network: String, words: String, walletIndex: Int, payload: String, feeAddress: String, fee: Decimal, success: ((Bool) -> Void)?, error: ((String) -> Void)?) {
        do {
            let mnemonic = try Mnemonic(words: words)
            let hd = try mnemonic.toHD(index: walletIndex)
            let sender = hd.toWallet().base58Address

            self.getNonce(network: network, address: sender, success: { nonce in
                self.consumedFee(network: network, sender: sender, contract: nil, payload: payload, success: { consumedFee in
                    do {
                        let tx = try TransactionRequest()
                            .addCommission(gasPrice: ProxyClient.gasPrice, transferCommission: ProxyClient.gas)

                            .addSender(address: sender, key: hd, value: fee.satoshi, nonce: nonce.unconfirmedNonce)

                            .addTransfer(address: feeAddress, value: fee.satoshi)
                            .addContractCreation(sender: sender, code: payload, value: Sono.zero, gas: ProxyClient.gas)
                            .sign()

                        self.send(network: network, tx: tx, success: { result in
                            success?(result)
                        }, error: error)
                    } catch let err {
                        error?(err.localizedDescription)
                    }
                }, error: error)
            }, error: error)
            
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
}
