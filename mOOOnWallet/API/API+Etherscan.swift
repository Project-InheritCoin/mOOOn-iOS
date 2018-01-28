//
//  API+Etherscan.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 28..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Alamofire

extension API {
    
    enum Etherscan {
        case transactions(address: String)
        case balance(address: String)
    }
    
}

extension API.Etherscan: APIMethodProtocol {
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        let chain = Chain.default
        return "https://\(chain.etherscanUrl)/api?"
    }
    
    var params: Params? {
        switch self {
        case .transactions(let address):
            return [
                "module": "account",
                "action": "txlist",
                "address": address,
                "startblock": 0,
                "endblock": 99999999,
                "sort": "asc",
                "apiKey": Constants.Etherscan.apiKey
            ]
        case .balance(let address):
            return [
                "module": "account",
                "action": "tokenBalance",
                "address": address,
                "tag": "latest",
                "contractaddress": Constants.mOOOn.contractAddress,
                "apiKey": Constants.Etherscan.apiKey
            ]
        }
    }
}
