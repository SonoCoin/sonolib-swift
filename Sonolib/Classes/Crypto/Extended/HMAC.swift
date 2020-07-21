//
//  CryptoAlgorithm.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation
import CommonCrypto

public struct HMAC {
    
    public static func digest(input : Data, algo: HMACAlgo) -> Data {
        let digestLength = algo.digestLength
        var hash = [UInt8](repeating: 0, count: digestLength)
        switch algo {
        case .MD5:
            CC_MD5(input.bytes, UInt32(input.count), &hash)
            break
        case .SHA1:
            CC_SHA1(input.bytes, UInt32(input.count), &hash)
            break
        case .SHA224:
            CC_SHA224(input.bytes, UInt32(input.count), &hash)
            break
        case .SHA256:
            CC_SHA256(input.bytes, UInt32(input.count), &hash)
            break
        case .SHA384:
            CC_SHA384(input.bytes, UInt32(input.count), &hash)
            break
        case .SHA512:
            CC_SHA512(input.bytes, UInt32(input.count), &hash)
            break
        }
        return Data(bytes: hash, count: digestLength)
    }
    
}

public enum HMACAlgo {
    
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
}
