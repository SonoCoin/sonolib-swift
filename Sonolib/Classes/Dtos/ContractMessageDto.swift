//
//  ContractMessageDto.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation
import Base58Swift

public struct ContractMessageDto {
    
    public var sender: String
    public var address: String?
    public var payload: String
    public var value: UInt64
    public var gas: UInt64
 
    public init(sender: String, code: String, value: UInt64, gas: UInt64) {
        self.sender = sender
        self.payload = code
        self.value = value
        self.gas = gas
    }
    
    public init(sender: String, address: String?, payload: String, value: UInt64, gas: UInt64) {
        self.sender = sender
        self.address = address
        self.payload = payload
        self.value = value
        self.gas = gas
    }
    
    public func toBytes() throws -> Data {
        var buf = Data()
        
        guard let addr = Base58.base58Decode(sender) else {
            throw TransactionError.invalidAddress
        }
        
        buf.append(Data(addr))
        buf.append(payload.hex)
        buf.append(value.ldata)
        buf.append(gas.ldata)
        
        if let address = address, !address.isEmpty, let b58 = Base58.base58Decode(address) {
            buf.append(Data(b58))
        }
        
        return buf
    }
    
}

extension ContractMessageDto: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case sender
        case address
        case payload
        case value
        case gas
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sender, forKey: .sender)
        try container.encode(address, forKey: .address)
        try container.encode(payload, forKey: .payload)
        try container.encode(value, forKey: .value)
        try container.encode(gas, forKey: .gas)
    }
}
