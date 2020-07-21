//
//  ErrorDto.swift
//  
//
//  Created by Tim Notfoolen on 03.07.2020.
//

import Foundation

public struct ErrorDto {
    public var status: String
    public var code: Int
    public var message: String
}

extension ErrorDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.status = try container.decode(String.self, forKey: .status)
        self.code = try container.decode(Int.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
    }
    
}
