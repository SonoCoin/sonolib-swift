//
//  ContractBalanceDto.swift
//  
//
//  Created by Tim Notfoolen on 06.07.2020.
//

import Foundation

public struct ContractBalanceDto {
    
    public var contract: ContractDto
    public var balance: Decimal
    
}

extension ContractBalanceDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case contract
        case balance
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.contract = try container.decode(ContractDto.self, forKey: .contract)
        self.balance = try container.decode(Decimal.self, forKey: .balance)
    }
    
}
