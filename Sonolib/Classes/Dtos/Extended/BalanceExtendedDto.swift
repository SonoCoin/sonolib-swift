//
//  BalanceExtendedDto.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

public struct BalanceExtendedDto {
    public var address: String
    public var priceUsd: Decimal
    public var confirmedAmount: Decimal
    public var unconfirmedAmount: Decimal
}

extension BalanceExtendedDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case address
        case priceUsd
        case confirmedAmount
        case unconfirmedAmount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.address = try container.decode(String.self, forKey: .address)
        self.priceUsd = try container.decode(Decimal.self, forKey: .priceUsd)
        self.confirmedAmount = try container.decode(Decimal.self, forKey: .confirmedAmount)
        self.unconfirmedAmount = try container.decode(Decimal.self, forKey: .unconfirmedAmount)
    }
    
}
