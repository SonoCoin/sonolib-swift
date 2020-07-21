//
//  StaticCallDto.swift
//  
//
//  Created by Tim Notfoolen on 10.07.2020.
//

import Foundation

public struct StaticCallDto {
    public var result: String
}

extension StaticCallDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case result
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.result = try container.decode(String.self, forKey: .result)
    }
    
}
