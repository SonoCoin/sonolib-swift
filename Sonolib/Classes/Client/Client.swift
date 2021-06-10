//
//  Client.swift
//  
//
//  Created by Tim Notfoolen on 02.07.2020.
//

import Foundation
import Alamofire

public class Client {
    
    public let baseAddr: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(baseAddr: String) {
        self.baseAddr = baseAddr
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    public func get<T>(url: String, type: T.Type, success: ((T) -> Void)?, error: ((String) -> Void)?) throws where T : Decodable {
        AF.request(url).responseData { [error, success] (response) in
            switch response.result {
            case .success(let value):
                do {
                    let output = try self.decoder.decode(T.self, from: value)
                    success?(output)
                } catch let err {
                    do {
//                        let serverError = try self.decoder.decode(ErrorDto.self, from: value)
                        let serverError = try self.decoder.decode(ErrorProxyDto.self, from: value)
                        error?(serverError.errorString)
                    } catch _ {
                        error?(err.localizedDescription)
                    }
                }
            case .failure(let err):
                error?(err.localizedDescription)
            }
        }
    }
    
    public func post<T1, T2>(url: String, method: HTTPMethod = .get, requestId: String? = nil, data: T1, type: T2.Type, success: ((T2) -> Void)?, error: ((String) -> Void)?) throws where T1 : Encodable, T2 : Decodable {
        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let reqId = requestId {
            request.setValue(reqId, forHTTPHeaderField: "Sono-Request-Id")
        }
        
        let json = try self.encoder.encode(data)
        
        request.httpBody = json

        AF.request(request)
            .responseData { [error, success] (response) in
            switch response.result {
            case .success(let value):
                do {
                    let str = String(data: value, encoding: .utf8)
                    
                    let output = try self.decoder.decode(T2.self, from: value)
                    success?(output)
                } catch let err {
                    do {
//                        let serverError = try self.decoder.decode(ErrorDto.self, from: value)
                        let serverError = try self.decoder.decode(ErrorProxyDto.self, from: value)
                        error?(serverError.errorString)
                    } catch _ {
                        error?(err.localizedDescription)
                    }
                }
            case .failure(let err):
                error?(err.localizedDescription)
            }
        }
    }
    
}
