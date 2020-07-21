//
//  Wallet.swift
//
//
//  Created by Tim Notfoolen on 01.07.2020.
//

import Foundation
import CryptoKit
import Base58Swift

public class Wallet {

    public static let ACCOUNT_VERSION = Data([14, 48])
    public static let CONTRACT_VERSION = Data([14, 95])

    public static let CHECK_SUM_LEN: Int = 4

    public var base58Address: String
    public var address: Data

    public init(pubKey: Data) {
        var versionedPayload = Data()
        versionedPayload.append(contentsOf: Wallet.ACCOUNT_VERSION)
        
        let pub256key = SHA256.hash(data: pubKey)
        let ripmd160 = RIPEMD160.hash(message: Data(pub256key))
        versionedPayload.append(contentsOf: ripmd160)
        
        let checksum = Wallet.checksum(payload: versionedPayload)
        versionedPayload.append(contentsOf: checksum)
        
        self.address = versionedPayload
        self.base58Address = Base58.base58Encode(versionedPayload.bytes)
    }
    
    public static func checksum(payload: Data) -> Data {
        let data = Helpers.DHASH(data: payload)
        return data.subdata(in: 0..<CHECK_SUM_LEN)
    }
    
    private static func isValidAddress(version: Data, address: String) -> Bool {
        guard let addressArray = Base58.base58Decode(address) else {
            return false
        }
        let addressBytes = addressArray.data
    
        if (addressBytes.count < version.count + CHECK_SUM_LEN) {
            return false
        }
        
        let ver = addressBytes.subdata(in: 0..<version.count)
        if (ver != version) {
            return false
        }
        
        let payload = addressBytes.subdata(in: 0..<addressBytes.count-CHECK_SUM_LEN)
        let checksum = Wallet.checksum(payload: payload)
        var checkAddress = Data()
        checkAddress.append(contentsOf: payload)
        checkAddress.append(contentsOf: checksum)
        
        return checkAddress == addressBytes
    }
    
    public static func isValidAccountAddress(address: String) -> Bool {
        return Wallet.isValidAddress(version: ACCOUNT_VERSION, address: address)
    }
    
    public static func isValidContractAddress(address: String) -> Bool {
        return Wallet.isValidAddress(version: CONTRACT_VERSION, address: address)
    }
    
}
