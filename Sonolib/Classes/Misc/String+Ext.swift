//
//  String+Ext.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

extension String {

    var hex: Data {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return Data() }

        return data
    }

    func toCoinInfo() throws -> CoinInfo {
        let buf = self.hex
        if (buf.count != 9) {
            throw CoinInfoError.invalidPayloadSize
        }
        
        let status = Int(buf[0])
        let amount = buf[1..<buf.count].buint64
        return try CoinInfo(status: status, amount: amount)
    }

}
