//
//  Data+Ext.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation
import CommonCrypto

extension Data {
    
    var bytes : [UInt8] {
        return [UInt8](self)
    }
    
    var hex: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    var sha512: Data {
        return HMAC.digest(input: self, algo: HMACAlgo.SHA512)
    }
    
}

extension Array where Element == UInt8 {
    var data : Data{
        return Data(self)
    }
}
