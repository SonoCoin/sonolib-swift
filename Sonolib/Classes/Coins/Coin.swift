//
//  File.swift
//  
//
//  Created by Tim Notfoolen on 10.07.2020.
//

import Foundation
import Base58Swift

public class Coin {
    
    private static let createCoinHex = "a2b62e59"
    private static let transferCoinHex = "b3f4fb31"
    private static let infoCoinHex = "b64a097e"
    
    private static let approve = "approve"
    private static let transfer = "transfer"
    
    public var keys: CryptoKeys
    
    public init() throws {
        let (sk, pk) = try Crypt.generateKeys()
        self.keys = CryptoKeys(secretKey: sk, publicKey: pk)
    }
    
    public init(secretKey: String) throws {
        let buf = secretKey.hex
        let sk = buf
        let pk = buf.subdata(in: 32..<64)
//        let (sk, pk) = try Crypt.generateKeys(seed: secretKey.hex)
        self.keys = CryptoKeys(secretKey: sk, publicKey: pk)
    }
    
    public init(secretKey: Data) throws {
//        let (sk, pk) = try Crypt.generateKeys(seed: secretKey)
        let sk = secretKey
        let pk = secretKey.subdata(in: 32..<64)
        self.keys = CryptoKeys(secretKey: sk, publicKey: pk)
    }
    
    public static func getInfoPayload(coinPk: String) -> String {
        return infoCoinHex + coinPk
    }
    
    public static func getCreateCoinPayload(hd: HD, coinPk: String, amount: UInt64, nonce: UInt64) throws -> String {
        var buf = Data()
        buf.append(approve.data(using: .utf8)!)
        buf.append(amount.bdata)
        buf.append(nonce.bdata)
        
        let sig = try hd.sign(data: buf)
        
        var payload = Data()
        payload.append(hd.keyPair.publicKey)
        payload.append(amount.bdata)
        payload.append(sig)
        return Coin.createCoinHex + payload.hex + coinPk
    }
    
    public static func getSpendCoinPayload(keys: CryptoKeys, receiver: String) throws -> String {
        var buf = Data()
        buf.append(transfer.data(using: .utf8)!)
        
        guard let receiver = Base58.base58Decode(receiver) else {
            throw TransactionError.invalidAddress
        }
        buf.append(Data(receiver))
        
        let sig = try Crypt.sign(key: keys.secretKey, msg: buf)
        
        var payload = Data()
        payload.append(keys.publicKey)
        payload.append(Data(receiver))
        payload.append(sig)
        
        return Coin.transferCoinHex + payload.hex
    }
    
}
