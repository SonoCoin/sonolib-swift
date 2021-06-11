//
//  ContractDto.swift
//  
//
//  Created by Tim Notfoolen on 06.07.2020.
//

import Foundation

public struct ContractDto {
    
    public var address: String
    public var createdDt: Date?
    public var sender: String
    public var type: String
    public var name: String?
    public var logo: String?
    public var symbol: String?
    public var decimals: Int?
    public var totalSupply: UInt64?
    public var website: String?
    public var isParsed: Bool
    public var txHash: String
    public var network: String
    
}

extension ContractDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case address
        case createdDt
        case sender
        case type
        case name
        case symbol
        case decimals
        case totalSupply
        case website
        case isParsed
        case txHash
        case network
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.address = try container.decode(String.self, forKey: .address)
        self.createdDt = try container.decode(Date.self, forKey: .createdDt)
        self.sender = try container.decode(String.self, forKey: .sender)
        self.type = try container.decode(String.self, forKey: .type)
        self.name = try container.decode(String.self, forKey: .name)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.decimals = try container.decode(Int.self, forKey: .decimals)
        self.totalSupply = try container.decode(UInt64.self, forKey: .totalSupply)
        self.website = try container.decode(String.self, forKey: .website)
        self.isParsed = try container.decode(Bool.self, forKey: .isParsed)
        self.txHash = try container.decode(String.self, forKey: .txHash)
        self.network = try container.decode(String.self, forKey: .network)
    }
    
}
