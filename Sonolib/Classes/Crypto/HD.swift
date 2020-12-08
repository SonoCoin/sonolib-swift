//
//  HD.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation
import Sodium

public enum HDError: Error {
    case invalidPath
}

public class HD {
    
    public static let ED25519_CURVE = "Sonocoin seed"
    public static let HARDENED_OFFSET = UInt32(0x80000000)
    public static let DEFAULT_DERIVE_PATH = "m/0\'"
    public var keyPair: CryptoKeys
    
    public init(keyPair: CryptoKeys) {
        self.keyPair = keyPair
    }
    
    public convenience init(seed: Data, index: Int) throws {
        let path = "m/" + String(index) + "\'"
        try self.init(seed: seed, path: path)
    }
    
    public init(seed: Data, path: String) throws {
        var pathArgs = path
        if (pathArgs.isEmpty) {
            pathArgs = HD.DEFAULT_DERIVE_PATH
        }
        let mk = try HD.derivePath(path: pathArgs, seed: seed)
        
        let (sk, pk) = try Crypt.generateKeys(seed: mk.key)
        self.keyPair = CryptoKeys(secretKey: sk, publicKey: pk)
    }
    
    public func toWallet() -> Wallet {
        return Wallet(pubKey: keyPair.publicKey)
    }
    
    public func sign(data: Data) throws -> Data {
        return try Crypt.sign(key: self.keyPair.secretKey, msg: data)
    }
    
    public static func derivePath(path: String, seed: Data) throws -> MasterKey {
        // @TODO FIXME
//        if (!HD.isValid(path: path)) {
//            throw HDError.invalidPath
//        }
        
        var mk = HD.getMasterKeyFrom(seed: seed)
        var key = mk.key
        var chainCode = mk.chainCode
        
        let segments = try HD.pathToSegments(path: path)
        
        for seg in segments {
            mk = HD.ckdPriv(parentKey: key, parentChainCode: chainCode, index: seg + HD.HARDENED_OFFSET)
            key = mk.key
            chainCode = mk.chainCode
        }
        return MasterKey(key: key, chainCode: chainCode)
    }
    
    static private func ckdPriv(parentKey: Data, parentChainCode: Data, index: UInt32) -> MasterKey {
        var buffer = Data([0])
        buffer.append(contentsOf: parentKey)
        buffer.append(contentsOf: index.bdata)
        
//        let digest = buffer.sha512
        let digest = HMAC.sign(data: buffer, algorithm: .sha512, key: parentChainCode)
        return MasterKey(data: digest)
    }
    
    static private func getMasterKeyFrom(seed: Data) -> MasterKey {
//        let digest = seed.sha512;
        let digest = HMAC.sign(data: seed, algorithm: .sha512, key: HD.ED25519_CURVE.data(using: .utf8)!)
        return MasterKey(data: digest)
    }
    
    static private func isValid(path: String) -> Bool {
        let range = NSRange(location: 0, length: path.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^m(/\\d')+$")
        return regex.firstMatch(in: path, options: [], range: range) != nil
    }
    
    static private func pathToSegments(path: String) throws -> [UInt32] {
        let items = HD.pathToStringArray(path: path)
        var segments: [UInt32] = Array(repeating: 0, count: items.count)
        for index in 0..<items.count {
            guard let segment = UInt32(items[index]) else {
                throw HDError.invalidPath
            }
            segments[index] = segment
        }
        return segments
    }
    
    static private func pathToStringArray(path: String) -> [String] {
        var splitted = path.components(separatedBy: "/")
        splitted = Array(splitted[1..<splitted.count])
        
        for index in 0..<splitted.count {
            splitted[index] = splitted[index].replacingOccurrences(of: "'", with: "")
        }
        return splitted
    }
    
}
