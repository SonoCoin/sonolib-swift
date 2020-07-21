//
//  ContractCoinDto.swift
//  
//
//  Created by Tim Notfoolen on 10.07.2020.
//

import Foundation

public struct ContractCoinDto {
    public var address: String
}

extension ContractCoinDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case address
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.address = try container.decode(String.self, forKey: .address)
    }
    
}
