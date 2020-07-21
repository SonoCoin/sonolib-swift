//
//  NonceDto.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

public struct NonceDto {
    
    public var confirmedNonce: UInt64
    public var unconfirmedNonce: UInt64
    
}

extension NonceDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case confirmedNonce
        case unconfirmedNonce
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.confirmedNonce = try container.decode(UInt64.self, forKey: .confirmedNonce)
        self.unconfirmedNonce = try container.decode(UInt64.self, forKey: .unconfirmedNonce)
    }
    
}
