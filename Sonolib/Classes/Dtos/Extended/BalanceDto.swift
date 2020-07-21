//
//  BalanceDto.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

public struct BalanceDto {
    
    public var confirmedAmount: UInt64
    public var unconfirmedAmount: UInt64

}

extension BalanceDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case confirmedAmount
        case unconfirmedAmount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.confirmedAmount = try container.decode(UInt64.self, forKey: .confirmedAmount)
        self.unconfirmedAmount = try container.decode(UInt64.self, forKey: .unconfirmedAmount)
    }
    
}
