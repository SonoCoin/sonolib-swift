//
//  ProxyClientTests.swift
//  
//
//  Created by Tim Notfoolen on 06.07.2020.
//

import XCTest
@testable import Sonolib

final class ProxyClientTests: XCTestCase {
    
    private let proxyClient = ProxyClient(baseAddr: "https://api.sonocoin.io/proxy/api")
    private let network = "TestNet"
    private let contract = "SXQesoQbc9dfCHnrPzoSt2fGgPppRVcBS7B"
    private let words = "pink crunch sight hazard sing pigeon ring loyal silk believe cloth text amazing tooth wealth coil reason wage satisfy account easy rare grass lift"
    private let walletIndex = 0
    private let sender = "SCWTXwXKNJx6rpqEgV8eH4kGu1KmMoeBbAx"
    private let receiver = "SCigaYBVmALLd5bvEd3QvWL27FS8nsjssDY"
    
    func testGetNetworks() {
        let e = expectation(description: "Alamofire")
        proxyClient.getNetworks(success: { networks in
            XCTAssert(networks.count > 0)
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetBalance() {
        let e = expectation(description: "Alamofire")
        
        proxyClient.getBalance(network: self.network, address: self.sender, success: { balance in
            XCTAssert(balance.confirmedAmount > 0)
            XCTAssert(balance.unconfirmedAmount > 0)
            XCTAssert(balance.priceUsd > 0)
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetBalances() {
        let e = expectation(description: "Alamofire")
        
        let addresses = [sender, receiver]
        
        proxyClient.getBalances(network: self.network, addresses: addresses, success: { balances in
            XCTAssert(balances.count == addresses.count)
            
            for balance in balances {
                XCTAssert(balance.confirmedAmount > 0)
                XCTAssert(balance.unconfirmedAmount > 0)
                XCTAssert(balance.priceUsd > 0)
            }
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetTokenBalances() {
        let e = expectation(description: "Alamofire")
        
        proxyClient.getTokenBalances(network: self.network, address: sender, success: { tokenBalances in
            for balance in tokenBalances {
                XCTAssert(balance.balance > 0)
                XCTAssert(Wallet.isValidContractAddress(address: balance.contract.address))
                if let decimals = balance.contract.decimals {
                    XCTAssert(decimals > 0)
                }
                XCTAssert(balance.contract.name != "")
                XCTAssert(balance.contract.type == "Erc20")
                XCTAssert(balance.contract.symbol != "")
            }
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetContracts() {
        let e = expectation(description: "Alamofire")
        
        proxyClient.getContracts(network: self.network, success: { contracts in
            XCTAssert(contracts.count > 0)
            for contract in contracts {
                if let decimals = contract.decimals {
                    XCTAssert(decimals > 0)
                    XCTAssert(contract.name != "")
                    XCTAssert(contract.type == "Erc20")
                    XCTAssert(contract.symbol != "")
                }
            }
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetContract() {
        let e = expectation(description: "Alamofire")
        
        proxyClient.getContract(network: self.network, address: self.contract, success: { contract in
            XCTAssert(contract.address == self.contract)
            
            if let decimals = contract.decimals {
                XCTAssert(decimals > 0)
            }
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSend() {
        let e = expectation(description: "Alamofire")
        
        proxyClient.send(network: self.network, words: self.words, walletIndex: self.walletIndex, receiver: receiver, amount: 1.2, success: { res in
            XCTAssert(res)
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSendToken() {
        let e = expectation(description: "Alamofire")
        
        proxyClient.sendToken(network: self.network, words: self.words, walletIndex: self.walletIndex, contractAddress: contract, receiver: receiver, amount: 123, success: { res in
            XCTAssert(res)
            e.fulfill()
        }) { err in
            XCTFail(err)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    static var allTests = [
        ("testGetNetworks", testGetNetworks),
        ("testGetBalance", testGetBalance),
        ("testGetBalances", testGetBalances),
        ("testGetTokenBalances", testGetTokenBalances),
        ("testGetContracts", testGetContracts),
        ("testGetContract", testGetContract),
        ("testSend", testSend),
        ("testSendToken", testSendToken),
    ]
}
