//
//  TransferDto.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation
import Base58Swift

public class TransferDto {

    public var address: String
    public var value: UInt64
    
    public init(address: String, value: UInt64) {
        self.address = address
        self.value = value
    }
    
    public func toBytes() throws -> Data {
        var buf = Data()
        
        guard let addr = Base58.base58Decode(address) else {
            throw TransactionError.invalidAddress
        }
        
        buf.append(Data(addr))
        buf.append(value.ldata)
        
        return buf
    }
    
}

extension TransferDto: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case address
        case value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(value, forKey: .value)
    }
}

