//
//  CryptoSwift.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

public class CryptoKeys {
    
    public let publicKey: Data
    public let secretKey: Data
    
    public init(secretKey: Data) {
        self.secretKey = secretKey
        self.publicKey = secretKey.subdata(in: 32..<64)
    }
    
    public init(secretKey: Data, publicKey: Data) {
        self.secretKey = secretKey
        self.publicKey = publicKey
    }
    
}
