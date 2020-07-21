//
//  StakeDto.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation
import Base58Swift

public class StakeDto {
    
    public var address: String
    public var value: UInt64
    public var nodeId: String?
    
    public init(address: String, value: UInt64, nodeId: String?) {
        self.address = address
        self.value = value
        self.nodeId = nodeId
    }
    
    public func toBytes() throws -> Data {
        var buf = Data()
        
        guard let addr = Base58.base58Decode(address) else {
            throw TransactionError.invalidAddress
        }
        
        buf.append(Data(addr))
        buf.append(value.ldata)
        
        if let nodeId = self.nodeId, !nodeId.isEmpty {
            buf.append(nodeId.hex)
        }
        
        return buf
    }
    
}

extension StakeDto: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case address
        case value
        case nodeId
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(value, forKey: .value)
        try container.encode(nodeId, forKey: .nodeId)
    }
}

