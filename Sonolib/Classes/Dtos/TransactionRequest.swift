//
//  TransactionRequest.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

public enum TransactionError : Error {
    case invalidAddress
    case invalidContractAddress
    case invalidAmount
    case signKeyNotFound
}

public class TransactionRequest {
    
    public var hash: String?
    public var type: TransactionType
    public var version: UInt32
    public var inputs: [InputDto]
    public var transfers: [TransferDto]?
    public var messages: [ContractMessageDto]?
    public var stakes: [StakeDto]?
    public var gasPrice: UInt64
    
    private var signers: [String: HD]
    private var transferCommission: UInt64
    
    public init() {
        self.version = Sono.txVersion
        self.inputs = []
        self.type = TransactionType.Account
        
        self.signers = [String: HD]()
        self.gasPrice = 0
        self.transferCommission = 0
    }
    
    public func addCommission(gasPrice: UInt64, transferCommission: UInt64) -> TransactionRequest {
        self.gasPrice = gasPrice
        self.transferCommission = transferCommission
        return self
    }
    
    public func generateHash() throws -> Data {
        let buf = try toBytes()
        return Helpers.DHASH(data: buf)
    }
    
    public func toBytes() throws -> Data {
        var buf = Data()
        
        // Step 1 add Type (4 bytes)
        buf.append(type.rawValue.ldata)
        
        // Step 2: add Version (4 bytes)
        buf.append(version.ldata)
        
        // Step 3: add gas price (8 bytes)
        buf.append(gasPrice.ldata)
        
        // Step 4: add Inputs
        for item in inputs {
            buf.append(try item.toBytes())
        }
        
        // Step 5: add Transfers
        if let items = transfers {
            for item in items {
                buf.append(try item.toBytes())
            }
        }
        
        // Step 6: add Messages
        if let items = messages {
            for item in items {
                buf.append(try item.toBytes())
            }
        }
        
        // Step 7: add Stakes
        if let items = stakes {
            for item in items {
                buf.append(try item.toBytes())
            }
        }
        
        return buf
    }
    
    public func validateValue(commission: UInt64) throws {
        var len = UInt64(0)
        if let items = transfers {
            len += UInt64(items.count)
        }
        if let items = stakes {
            len += UInt64(items.count)
        }
        
        var outValue = commission * gasPrice * len
        
        if let items = transfers {
            for item in items {
                outValue += item.value
            }
        }
        
        if let items = stakes {
            for item in items {
                outValue += item.value
            }
        }
        
        if let items = messages {
            for item in items {
                outValue += item.value + item.gas * gasPrice
            }
        }
        
        var inValue = UInt64(0)
        for item in inputs {
            inValue += item.value
        }
        
        if inValue != outValue {
            throw TransactionError.invalidAmount
        }
    }
    
    public func addSender(address: String, key: HD, value: UInt64, nonce: UInt64) throws -> TransactionRequest {
        if !Wallet.isValidAccountAddress(address: address) {
            throw TransactionError.invalidAddress
        }
        
        inputs.append(InputDto(address: address, value: value, nonce: nonce, publicKey: key.keyPair.publicKey.hex))
        signers[address] = key
        return self
    }
    
    public func addTransfer(address: String, value: UInt64) throws -> TransactionRequest {
        if !Wallet.isValidAccountAddress(address: address) {
            throw TransactionError.invalidAddress
        }
        
        if transfers == nil {
            self.transfers = []
        }
        self.transfers?.append(TransferDto(address: address, value: value))
        return self
    }
    
    private func checkContractsData() {
        if messages == nil {
            messages = []
        }
    }
    
    public func addContractCreation(sender: String, code: String, value: UInt64, gas: UInt64) throws -> TransactionRequest {
        if !Wallet.isValidAccountAddress(address: sender) {
            throw TransactionError.invalidAddress
        }
        
        self.checkContractsData()
        messages?.append(ContractMessageDto(sender: sender, code: code, value: value, gas: gas))
        return self
    }
    
    public func addContractExecution(sender: String, address: String, input: String, value: UInt64, gas: UInt64) throws -> TransactionRequest {
        if !Wallet.isValidAccountAddress(address: sender) {
            throw TransactionError.invalidAddress
        }
        if !Wallet.isValidContractAddress(address: address) {
            throw TransactionError.invalidContractAddress
        }
        
        self.checkContractsData()
        messages?.append(ContractMessageDto(sender: sender, address: address, payload: input, value: value, gas: gas))
        return self
    }
    
    public func addStake(address: String, value: UInt64, nodeId: String) -> TransactionRequest {
        if self.stakes == nil {
            self.stakes = []
        }
        self.stakes?.append(StakeDto(address: address, value: value, nodeId: nodeId))
        return self
    }
    
    public func validate() throws {
        try validateValue(commission: transferCommission)
    }
    
    public func sign() throws -> TransactionRequest {
        try validate()
        
        for index in 0..<inputs.count {
            let input = inputs[index]
            
            let msg = try msgForSignUser(input: input)
            guard let hd = signers[input.address] else {
                throw TransactionError.signKeyNotFound
            }
            let sig = try hd.sign(data: msg)
            inputs[index].sign = sig.hex
        }
        let hash = try generateHash()
        self.hash = hash.hex
        
        return self
    }
    
    private func msgForSignUser(input: InputDto) throws -> Data {
        var buf = Data()
        
        // Step 1 add Type (4 bytes)
        buf.append(type.rawValue.ldata)
        
        // Step 2: add Version (4 bytes)
        buf.append(version.ldata)
        
        // Step 3: add gas price (8 bytes)
        buf.append(gasPrice.ldata)
        
        // Step 4: add Inputs
        buf.append(try input.toBytes())
        
        // Step 5: add Transfers
        if let items = transfers {
            for item in items {
                buf.append(try item.toBytes())
            }
        }
        
        // Step 6: add Messages
        if let items = messages {
            for item in items {
                buf.append(try item.toBytes())
            }
        }
        
        // Step 7: add Stakes
        if let items = stakes {
            for item in items {
                buf.append(try item.toBytes())
            }
        }
        
        return buf
        
    }
    
}
