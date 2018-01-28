//
//  BalanceService.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 28..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Foundation
import Alamofire

class BalanceService : BalanceServiceProtocol {
    func fetchBalanceFromEtherscan(completion: @escaping (Double) -> Void) {
        let keystoreService = KeystoreService()
        do {
            let account = try keystoreService.getAccount(at: 0)
            let address = account.getAddress().getHex()
            getBalance(address: address!, result: { result in
                switch result {
                case .success(let balance):
                    completion(Double(balance)! / 1000000000000000000)
                case .failure(_):
                    print("Error : Cannot fetch balance from etherscan.")
                }
            })
           
        } catch {
            print("KetstoreService Error : Cannot access an account")
        }
    }
    
    func getBalance(address: String, result: @escaping (Result<String>) -> Void) {
        loadObjectJSON(request: API.Etherscan.balance(address: "0xd26114cd6ee289accf82350c8d8487fedb8a0c07")) { resultHandler in
            switch resultHandler {
            case .success(let object):
                
                guard let json = object as? [String: Any], let balance = json["result"] as? String else {
                    result(Result.failure(NSError()))
                    return
                }
                
                result(Result.success(balance))
                
            case .failure(let error):
                result(Result.failure(error))
            }
            
        }
    }
    
    typealias ResultJSONBlock = (Result<Any>) -> Void
    func loadObjectJSON(request: URLRequestConvertible, completion: @escaping ResultJSONBlock) {
        let operation = AnyOperation(request: request,
                                     responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments),
                                     completion: completion)
        operation.execute()
    }
    
    private struct AnyOperation<ResponseSerializer: DataResponseSerializerProtocol> {
        
        var request: URLRequestConvertible
        var responseSerializer: ResponseSerializer
        var completion: ((Result<ResponseSerializer.SerializedObject>) -> Void)?
        
        func execute() {
            Alamofire.request(request).response(queue: DispatchQueue.main, responseSerializer: responseSerializer) { response in
                self.completion?(response.result)
            }
        }
    }
}
