//
//  TransactionRequest+Ext.swift
//  
//
//  Created by Tim Notfoolen on 05.07.2020.
//

import Foundation

extension TransactionRequest: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case hash
        case type
        case version
        case inputs
        case transfers
        case messages
        case stakes
        case gasPrice
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hash, forKey: .hash)
        try container.encode(type, forKey: .type)
        try container.encode(version, forKey: .version)
        try container.encode(inputs, forKey: .inputs)
        try container.encode(transfers, forKey: .transfers)
        try container.encode(messages, forKey: .messages)
        try container.encode(stakes, forKey: .stakes)
        try container.encode(gasPrice, forKey: .gasPrice)
    }
    
}
