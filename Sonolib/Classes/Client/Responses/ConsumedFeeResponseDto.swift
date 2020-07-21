//
//  ConsumedFeeResponseDto.swift
//  
//
//  Created by Tim Notfoolen on 13.07.2020.
//

import Foundation

public struct ConsumedFeeResponseDto {
    public var consumedFee: UInt64
}

extension ConsumedFeeResponseDto: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case consumedFee
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.consumedFee = try container.decode(UInt64.self, forKey: .consumedFee)
    }
    
}

