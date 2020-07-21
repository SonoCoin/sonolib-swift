//
//  WalletTests.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import XCTest
@testable import Sonolib

final class WalletTests: XCTestCase {

    func testNewWallet() {
        let mnemonic = try! Mnemonic(count: 24)
        let wallet = try! mnemonic.toWallet(index: 0)
        let walletAddress = wallet.base58Address
    }

    func testValidAddress() {
        let invalid = "SC4677676767676767676766767565656656"
        XCTAssert(!Wallet.isValidAccountAddress(address: invalid))
        
        let accountValid = "SCjRdq6w3QX8HWusFc6mUXbkMgbKB9shhZt"
        XCTAssert(Wallet.isValidAccountAddress(address: accountValid))
        
        let contractValid = "SXXg2869a2LCqUKagPsPJMSRCmxyyE2QvBB"
        XCTAssert(Wallet.isValidContractAddress(address: contractValid))
    }

    static var allTests = [
        ("testNewWallet", testNewWallet),
        ("testValidAddress", testValidAddress),
    ]

}
