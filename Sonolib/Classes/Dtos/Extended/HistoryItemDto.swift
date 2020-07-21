//
//  HistoryItemDto.swift
//  
//
//  Created by Tim Notfoolen on 06.07.2020.
//

import Foundation

public struct HistoryItemDto {
    public var network: String
    public var blockHash: String?
    public var txHash: String?
    public var ticker: String
    public var isToken: Bool
    public var commission: Decimal
    public var amount: Decimal
    public var operationType: String
    public var type: String
    public var fromAddress: String
    public var toAddress: String
    public var contractAddress: String?
    public var dt: Date?
    public var status: String
    public var nodeId: String?
    public var priceUsd: Decimal
}

extension HistoryItemDto: Decodable {
    public enum CodingKeys: String, CodingKey {
        case network
        case blockHash
        case txHash
        case ticker
        case isToken
        case commission
        case amount
        case operationType
        case type
        case fromAddress
        case toAddress
        case contractAddress
        case dt
        case status
        case nodeId
        case priceUsd
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.network = try container.decode(String.self, forKey: .network)
        self.blockHash = try container.decode(String.self, forKey: .blockHash)
        self.txHash = try container.decode(String.self, forKey: .txHash)
        self.ticker = try container.decode(String.self, forKey: .ticker)
        self.isToken = try container.decode(Bool.self, forKey: .isToken)
        self.commission = try container.decode(Decimal.self, forKey: .commission)
        self.amount = try container.decode(Decimal.self, forKey: .amount)
        self.operationType = try container.decode(String.self, forKey: .operationType)
        self.type = try container.decode(String.self, forKey: .type)
        self.fromAddress = try container.decode(String.self, forKey: .fromAddress)
        self.toAddress = try container.decode(String.self, forKey: .toAddress)
        self.contractAddress = try container.decode(String.self, forKey: .contractAddress)
        self.dt = try container.decode(Date.self, forKey: .dt)
        self.status = try container.decode(String.self, forKey: .status)
        self.nodeId = try container.decode(String.self, forKey: .nodeId)
        self.priceUsd = try container.decode(Decimal.self, forKey: .priceUsd)
    }
}
