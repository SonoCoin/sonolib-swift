//
//  CoinTests.swift
//  
//
//  Created by Tim Notfoolen on 13.07.2020.
//

import XCTest
@testable import Sonolib

final class CoinTests: XCTestCase {
    
    private let proxyClient = ProxyClient(baseAddr: "https://api.sonocoin.io/proxy/api")
    private let network = "TestNet"
    private let contract = "SXQesoQbc9dfCHnrPzoSt2fGgPppRVcBS7B"
    private let words = "pink crunch sight hazard sing pigeon ring loyal silk believe cloth text amazing tooth wealth coil reason wage satisfy account easy rare grass lift"
    private let walletIndex = 0
    private let sender = "SCWTXwXKNJx6rpqEgV8eH4kGu1KmMoeBbAx"
    private let receiver = "SCigaYBVmALLd5bvEd3QvWL27FS8nsjssDY"
    
    func testCreateCoin() {
        let e = expectation(description: "Alamofire")
        
        let amount = Decimal(0.7)
        
        self.proxyClient.getCoinContract(network: self.network, success: { contract in
            self.proxyClient.createCoin(network: self.network, words: self.words, walletIndex: self.walletIndex, contract: contract.address, amount: amount, success: { coinSecretKey in
                XCTAssert(coinSecretKey != "")
                e.fulfill()
            }) { err in
                XCTFail(err)
                e.fulfill()
            }
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testCoinInfo() {
        let e = expectation(description: "Alamofire")
        
        let expectedAmount = Decimal(0.7)
        let coinSecretKey = "5b5935764b24ebd0baac4c61245578be9323b0ab3e67338cdd2faee4aab84d5a02ef331c601fba211f772a90dd8305590455aa756edb5a7d9fbe5aeb404dee1e"
        
        self.proxyClient.getCoinContract(network: self.network, success: { contract in
            self.proxyClient.getCoinInfo(network: self.network, contract: contract.address, coinSecretKey: coinSecretKey, success: { val in
                XCTAssert(val == expectedAmount)
                e.fulfill()
            }) { err in
                XCTFail(err)
                e.fulfill()
            }
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    func testSpendCoin() {
        let e = expectation(description: "Alamofire")
        
        let coinSecretKey = "5b5935764b24ebd0baac4c61245578be9323b0ab3e67338cdd2faee4aab84d5a02ef331c601fba211f772a90dd8305590455aa756edb5a7d9fbe5aeb404dee1e"

        self.proxyClient.getCoinContract(network: self.network, success: { contract in
            self.proxyClient.spendCoin(network: self.network, words: self.words, walletIndex: self.walletIndex, contract: contract.address, coinSecretKey: coinSecretKey, success: { res in
                XCTAssert(res)
                e.fulfill()
            }, error: { err in
                XCTFail(err)
                e.fulfill()
            })
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testCreateTokenCoin() {
        let e = expectation(description: "Alamofire")
        
        let amount = Decimal(1.2)
        self.proxyClient.createTokenCoin(network: self.network, words: self.words, walletIndex: self.walletIndex, contractAddress: self.contract, amount: amount, success: { coinSecretKey in
            XCTAssert(coinSecretKey != "")
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 100.0, handler: nil)
    }
    
    func testGetTokenCoinInfo() throws {
        let e = expectation(description: "Alamofire")
        
        let coinSecretKey = "6ec44cdbf169ae2efe35d3131a4021319e56e5ac873dee4a3ecc8333940713bad0d59edc6c08fb39748a44a60f57967b8e024500984399210c8041d61f922700"
        let expectedAmount = Decimal(1.2)
        
        let mnemonic = try Mnemonic(words: self.words)
        let owner = try mnemonic.toWallet(index: self.walletIndex).base58Address
        
        self.proxyClient.getTokenCoinInfo(network: self.network, owner: owner, contractAddress: self.contract, coinSecretKey: coinSecretKey, success: { amount in
            XCTAssert(expectedAmount == amount)
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSpendTokenCoin() throws {
        let e = expectation(description: "Alamofire")
        
        let coinSecretKey = "7f2b184e2a3837788a3f4281c72d3afe214772bd6163103a20abfd13aea630412264cde115e93a3c0275ed301fdf7a6642f15abd20037a5551d48ae6052c2522"
        let mnemonic = try Mnemonic(words: self.words)
        let owner = try mnemonic.toWallet(index: self.walletIndex).base58Address
        
        self.proxyClient.spendTokenCoin(network: self.network, words: self.words, walletIndex: self.walletIndex, owner: owner, contract: self.contract, coinSecretKey: coinSecretKey, success: { res in
            XCTAssert(res)
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 100.0, handler: nil)
    }
    
    static var allTests = [
        ("testCreateCoin", testCreateCoin),
        ("testCoinInfo", testCoinInfo),
        ("testSpendCoin", testSpendCoin),
        
        ("testCreateTokenCoin", testCreateTokenCoin),
        ("testGetTokenCoinInfo", testGetTokenCoinInfo),
        ("testSpendTokenCoin", testSpendTokenCoin),
    ]
    
}
