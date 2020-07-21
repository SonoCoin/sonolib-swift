//
//  Client+Ext.swift
//  
//
//  Created by Tim Notfoolen on 06.07.2020.
//

import Foundation


extension Client {
    
    public func getBalance(address: String, success: ((BalanceDto) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/account/\(address)/balance"
        do {
            try self.get(url: url, type: BalanceDto.self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
    public func getNonce(address: String, success: ((NonceDto) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/account/\(address)/nonce"
        do {
            try self.get(url: url, type: NonceDto.self, success: success, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
    public func send(tx: TransactionRequest, success: ((Bool) -> Void)?, error: ((String) -> Void)?) {
        let url = self.baseAddr + "/txs/publish"
        do {
            try self.post(url: url, data: tx, type: TxPublishResponseDto.self, success: { res in
                success?(res.result == "ok")
            }, error: error)
        } catch let err {
            error?(err.localizedDescription)
        }
    }
    
}
