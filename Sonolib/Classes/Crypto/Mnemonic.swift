//
//  Mnemonic.swift
//
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation

enum MnemonicError: Error {
    case invalidWordsCount
}

public class Mnemonic {

    public let words: String
    public let seed: Data

    public init(count: Int) throws {
        switch count {
        case 12, 15, 18, 21, 24:
            break
        default:
            throw MnemonicError.invalidWordsCount
        }
        
        let mnemonic = MnemonicWrapper(strength: Int(round(Double(count * 4) / Double(3)) * 8))
        self.words = mnemonic.phrase.joined(separator: " ")
        self.seed = Data(mnemonic.seed)
    }

    public init(words: String) throws {
        self.words = words
        let mnemonic = try MnemonicWrapper(phrase: words.components(separatedBy: " "))
        self.seed = Data(mnemonic.seed)
    }

    public func toHD(index: Int) throws -> HD {
        return try HD(seed: self.seed, index: index)
    }

    public func toWallet(index: Int) throws -> Wallet {
        let hd = try self.toHD(index: index)
        return hd.toWallet()
    }
    
}
