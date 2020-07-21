//
//  ErrorProxyDto.swift
//  
//
//  Created by Tim Notfoolen on 13.07.2020.
//

import Foundation

public struct ErrorProxyDto {
    public var errorFlag: Bool
    public var errorString: String
    public var errorCode: String
}

extension ErrorProxyDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case errorFlag
        case errorString
        case errorCode
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.errorFlag = try container.decode(Bool.self, forKey: .errorFlag)
        self.errorString = try container.decode(String.self, forKey: .errorString)
        self.errorCode = try container.decode(String.self, forKey: .errorCode)
    }
    
}
