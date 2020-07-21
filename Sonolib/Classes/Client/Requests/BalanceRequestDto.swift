//
//  BalanceRequestDto.swift
//  
//
//  Created by Tim Notfoolen on 06.07.2020.
//

import Foundation

public struct BalanceRequestDto {
    
    public var addresses: [String]
 
    public init(addresses: [String]) {
        self.addresses = addresses
    }
    
}

extension BalanceRequestDto: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case addresses
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(addresses, forKey: .addresses)
    }
}
