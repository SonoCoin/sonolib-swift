//
//  InputDto.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation
import Base58Swift

public struct InputDto {
    
    public var address: String
    public var nonce: UInt64
    public var sign: String?
    public var publicKey: String?
    public var value: UInt64
    
    public init(address: String, value: UInt64, nonce: UInt64, publicKey: String) {
        self.address = address
        self.value = value
        self.nonce = nonce
        self.publicKey = publicKey
    }
    
    public func toBytes() throws -> Data {
        var buf = Data()
        
        guard let addr = Base58.base58Decode(address) else {
            throw TransactionError.invalidAddress
        }
        
        buf.append(Data(addr))
        buf.append(value.ldata)
        buf.append(nonce.ldata)
        
        if let sign = self.sign, !sign.isEmpty,
            let pubKey = self.publicKey, !pubKey.isEmpty {
            buf.append(sign.hex)
            buf.append(pubKey.hex)
        }
        
        return buf
    }
    
}

extension InputDto: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case address
        case nonce
        case sign
        case publicKey
        case value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(nonce, forKey: .nonce)
        try container.encode(sign, forKey: .sign)
        try container.encode(publicKey, forKey: .publicKey)
        try container.encode(value, forKey: .value)
    }
}
