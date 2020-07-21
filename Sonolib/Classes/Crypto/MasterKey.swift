//
//  MasterKey.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

public class MasterKey {
    
    public let key: Data;
    public let chainCode: Data;
    
    public init(data: Data) {
        self.key = data.subdata(in: 0..<32)
        self.chainCode = data.subdata(in: 32..<64)
    }
    
    public init(key: Data, chainCode: Data) {
        self.key = key
        self.chainCode = chainCode
    }
    
}
