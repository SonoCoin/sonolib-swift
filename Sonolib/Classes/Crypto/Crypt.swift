//
//  Crypt.swift
//  SonoCoin
//
//  Created by Timur Nutfullin on 05/09/2017.
//  Copyright © 2017 SonoCoin Foundation. All rights reserved.
//

import Foundation
import Sodium

public enum CryptError: Error {
    case keys
    case signature
}

public class ConverterData {
    
    public static func intsToData(_ ints: Bytes) -> Data {
        return Data(ints)
    }
    
    public static func dataToInts(_ data: Data) -> Bytes {
        return data.bytes
    }
    
}

public class Crypt {

    private static var sodium = Sodium()
    
    public static func generateKey() throws -> Data {
        guard let keyPair = sodium.sign.keyPair() else {
            throw CryptError.keys
        }
        return ConverterData.intsToData(keyPair.secretKey)
    }

    public static func generateKeys() throws -> (Data, Data) {
        guard let keyPair = sodium.sign.keyPair() else {
            throw CryptError.keys
        }
        
        return (ConverterData.intsToData(keyPair.secretKey), ConverterData.intsToData(keyPair.publicKey))
    }
    
    public static func generateKeys(seed: Data) throws -> (Data, Data) {
        guard let keyPair = sodium.sign.keyPair(seed: ConverterData.dataToInts(seed)) else {
            throw CryptError.keys
        }
        return (ConverterData.intsToData(keyPair.secretKey), ConverterData.intsToData(keyPair.publicKey))
    }

    public static func sign(key: Data, msg: Data) throws -> Data {
        guard let sign = sodium.sign.signature(message: ConverterData.dataToInts(msg), secretKey: ConverterData.dataToInts(key)) else {
            throw CryptError.signature
        }
        return ConverterData.intsToData(sign)
    }

}
