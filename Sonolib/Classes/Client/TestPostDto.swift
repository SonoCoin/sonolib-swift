//
//  TestPostDto.swift
//  
//
//  Created by Tim Notfoolen on 05.07.2020.
//

import Foundation

public struct TestPostDto: Encodable, Decodable {
    
    public var key: String
    public var value: String
    
    public enum CodingKeys: String, CodingKey {
        case key
        case value
    }
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(value, forKey: .value)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.key = try container.decode(String.self, forKey: .key)
        self.value = try container.decode(String.self, forKey: .value)
    }
}
