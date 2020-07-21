//
//  Helpers.swift
//
//
//  Created by Tim Notfoolen on 01.07.2020.
//

import Foundation
import CryptoKit

struct Helpers {
    
    static func DHASH(data: Data) -> Data {
        return Data(SHA256.hash(data: Data(SHA256.hash(data: data))))
    }
    
}
