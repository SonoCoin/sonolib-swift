//
//  File.swift
//  
//
//  Created by Tim Notfoolen on 10.07.2020.
//

import Foundation

public enum CoinInfoError: Error {
    case invalidCoinStatus
    case invalidPayloadSize
}

public struct CoinInfo {
    
    public var status: CoinStatus
    public var amount: UInt64
    
    public init(status: Int, amount: UInt64) throws {
        switch status {
        case 1:
            self.status = CoinStatus.active
            break
        case 2:
            self.status = CoinStatus.spent
        default:
            throw CoinInfoError.invalidCoinStatus
        }
        
        self.amount = amount
    }
    
}
