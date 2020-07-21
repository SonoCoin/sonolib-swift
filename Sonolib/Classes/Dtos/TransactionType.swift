//
//  TransactionType.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

public enum TransactionType: UInt32, Encodable {
    case Account = 0
    case Coinbase = 1
    case Genesis = 2
}
