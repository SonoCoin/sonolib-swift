//
//  ClientTests.swift
//  
//
//  Created by Tim Notfoolen on 03.07.2020.
//

import XCTest
@testable import Sonolib

final class ClientTests: XCTestCase {
    
    private let client = Client(baseAddr: "https://testnet.sonocoin.io/api/rest/v1")
    private let gas = UInt64(100000000000)
    private let fee = UInt64(0)
    private let gasPrice = UInt64(0)
    private let commission = UInt64(0)
    
    func testGetBalance() {
        let e = expectation(description: "Alamofire")
        
        let address = "SCjRdq6w3QX8HWusFc6mUXbkMgbKB9shhZt"
        
        client.getBalance(address: address, success: { balance in
            print(balance)

            e.fulfill()
        }) { err in
            print(err)

            e.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testGetNonce() {
        let e = expectation(description: "Alamofire")
        
        let address = "SCjRdq6w3QX8HWusFc6mUXbkMgbKB9shhZt"
        
        client.getNonce(address: address, success: { nonce in
            print(nonce)

            e.fulfill()
        }) { err in
            print(err)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testPost() {
        let e = expectation(description: "Alamofire")
        
        let testClient = Client(baseAddr: "https://wallet.sonocoin.io/proxy/api")
        
        testClient.testPost(success: { res in
            print(res)
            e.fulfill()
        }) { err in
            print(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSend() {
        let e = expectation(description: "Alamofire")
        
        let receiver = "SCigaYBVmALLd5bvEd3QvWL27FS8nsjssDY"
        let words = "pink crunch sight hazard sing pigeon ring loyal silk believe cloth text amazing tooth wealth coil reason wage satisfy account easy rare grass lift"
        let amount = UInt64(1)
        
        let mnemonic = try! Mnemonic(words: words)
        let hd = try! mnemonic.toHD(index: 0)
        let wallet = try! mnemonic.toWallet(index: 0)
        let sender = wallet.base58Address
        
        let txAmount = amount * Sono.currencyDivider
        
        client.getNonce(address: sender, success: { nonce in
            let tx = try! TransactionRequest()
                .addCommission(gasPrice: self.gasPrice, transferCommission: self.gas)
                .addSender(address: sender, key: hd, value: txAmount, nonce: nonce.unconfirmedNonce)
                .addTransfer(address: receiver, value: txAmount)
                .sign()

            self.client.send(tx: tx, success: { res in
                assert(res)

                e.fulfill()
            }) { err in
                print(err)
                e.fulfill()
            }
//            e.fulfill()
        }) { err in
            print(err)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSendToken() {
        let e = expectation(description: "Alamofire")
        
        let contract = "SXQesoQbc9dfCHnrPzoSt2fGgPppRVcBS7B"
        let receiver = "SCigaYBVmALLd5bvEd3QvWL27FS8nsjssDY"
        let words = "pink crunch sight hazard sing pigeon ring loyal silk believe cloth text amazing tooth wealth coil reason wage satisfy account easy rare grass lift"
        let amount = UInt64(300)
        
        let mnemonic = try! Mnemonic(words: words)
        let hd = try! mnemonic.toHD(index: 0)
        let wallet = try! mnemonic.toWallet(index: 0)
        let sender = wallet.base58Address
        
        client.getNonce(address: sender, success: { nonce in
            let tx = try! Erc20Transfer()
                .addCommission(gasPrice: self.gasPrice)
                .addSender(address: sender, key: hd, value: self.commission, nonce: nonce.unconfirmedNonce)
                .addTransfer(contract: contract, address: receiver, amount: amount, gas: self.gas)
                .sign()

            self.client.send(tx: tx, success: { res in
                assert(res)

                e.fulfill()
            }) { err in
                print(err)
                e.fulfill()
            }
//            e.fulfill()
        }) { err in
            print(err)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    static var allTests = [
        ("testGetBalance", testGetBalance),
        ("testGetNonce", testGetNonce),
        ("testSend", testSend),
        ("testSendToken", testSendToken),
    ]
}
