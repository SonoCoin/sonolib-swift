//
//  StaticCallRequestDto.swift
//  
//
//  Created by Tim Notfoolen on 10.07.2020.
//

import Foundation

public struct StaticCallRequestDto {
    
    public var address: String
    public var payload: String
 
    public init(address: String, payload: String) {
        self.address = address
        self.payload = payload
    }
    
}

extension StaticCallRequestDto: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case address
        case payload
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(payload, forKey: .payload)
    }
}
