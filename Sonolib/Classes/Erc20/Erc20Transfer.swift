//
//  Erc20Transfer.swift
//  
//
//  Created by Tim Notfoolen on 05.07.2020.
//

import Foundation
import Base58Swift

public enum Erc20TransferError: Error {
    case senderIsNil
}

public class Erc20Transfer {
    
    private static let transferHex      = "5d359fbd"
    private static let balanceHex       = "70a08231"
    private static let approveHex       = "1086a9aa"
    private static let transferFromHex  = "2ea0dfe1"
    private static let allowanceHex     = "dd62ed3e"
    
    
    private var txRequest: TransactionRequest
    private var sender: String?
    
    public init() {
        self.txRequest = TransactionRequest()
    }
    
    public func addCommission(gasPrice: UInt64) -> Erc20Transfer {
        _ = self.txRequest.addCommission(gasPrice: gasPrice, transferCommission: Sono.zero)
        return self
    }
    
    public func addSender(address: String, key: HD, value: UInt64, nonce: UInt64) throws -> Erc20Transfer {
        self.sender = address
        _ = try self.txRequest.addSender(address: address, key: key, value: value, nonce: nonce)
        return self
    }
    
    public func addTransfer(contract: String, address: String, amount: UInt64, gas: UInt64) throws -> Erc20Transfer {
        guard let sender = self.sender else {
            throw Erc20TransferError.senderIsNil
        }
        
        let payload = try Erc20Transfer.getTransferPayload(address: address, amount: amount)
        
        _ = try self.txRequest.addContractExecution(sender: sender, address: contract, input: payload, value: Sono.zero, gas: gas)
        
        return self
    }
    
    public func sign() throws -> TransactionRequest {
        return try self.txRequest.sign()
    }
    
    public static func getTransferPayload(address: String, amount: UInt64) throws -> String {
        guard let address = Base58.base58Decode(address) else {
            throw TransactionError.invalidAddress
        }
        
        var buf = Data()
        buf.append(Data(address))
        buf.append(amount.bdata)
        
        return Erc20Transfer.transferHex + buf.hex
    }
    
    public static func getBalancePayload(contract: String, address: String) throws -> String {
        guard let address = Base58.base58Decode(address) else {
            throw TransactionError.invalidAddress
        }
        
        return Erc20Transfer.balanceHex + Data(address).hex
    }
    
    public static func getApprovePayload(coinPk: Data, amount: UInt64) -> String {
        var buf = Data()
        buf.append(Wallet(pubKey: coinPk).address)
        buf.append(amount.bdata)
        
        return Erc20Transfer.approveHex + buf.hex
    }
    
    public static func getTransferFromPayload(sender: String, receiver: String, amount: UInt64) throws -> String {
        guard let sender = Base58.base58Decode(sender) else {
            throw TransactionError.invalidAddress
        }
        guard let receiver = Base58.base58Decode(receiver) else {
            throw TransactionError.invalidAddress
        }
        
        var buf = Data()
        buf.append(Data(sender))
        buf.append(Data(receiver))
        buf.append(amount.bdata)
        
        return Erc20Transfer.transferFromHex + buf.hex
    }
    
    public static func getAllowancePayload(owner: String, spender: String) throws -> String {
        guard let owner = Base58.base58Decode(owner) else {
            throw TransactionError.invalidAddress
        }
        guard let spender = Base58.base58Decode(spender) else {
            throw TransactionError.invalidAddress
        }
        
        var buf = Data()
        buf.append(Data(owner))
        buf.append(Data(spender))
        
        return Erc20Transfer.allowanceHex + buf.hex
    }
    
}
