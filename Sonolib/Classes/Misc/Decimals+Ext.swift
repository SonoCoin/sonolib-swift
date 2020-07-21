//
//  Decimal+Ext.swift
//  
//
//  Created by Tim Notfoolen on 06.07.2020.
//

import Foundation

extension Decimal {
    
    var satoshi: UInt64 {
        let tmp = self * Decimal(Sono.currencyDivider)
        let t = NSDecimalNumber(decimal: tmp)
        return UInt64(truncating: t)
    }
    
    var uint64: UInt64 {
        let t = NSDecimalNumber(decimal: self)
        return UInt64(truncating: t)
    }
    
}
