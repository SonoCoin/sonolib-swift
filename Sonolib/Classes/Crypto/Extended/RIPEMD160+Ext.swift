//
//  RIPEMD160+Ext.swift
//
//
//  Created by Tim Notfoolen on 01.07.2020.
//

import Foundation

public extension RIPEMD160 {
    
    static func hash(message: Data) -> Data {
        var md = RIPEMD160()
        md.update(data: message)
        return md.finalize()
    }

    static func hash(message: String) -> Data {
        return RIPEMD160.hash(message: message.data(using: .utf8)!)
    }
}
