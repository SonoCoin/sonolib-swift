//
//  NetworkDto.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

public struct NetworkDto {
    public var name: String
    public var path: String
}

extension NetworkDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case name
        case path
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.path = try container.decode(String.self, forKey: .path)
    }
    
}
