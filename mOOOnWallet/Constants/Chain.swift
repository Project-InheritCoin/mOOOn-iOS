//
//  Chain.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Geth

enum Chain: String {
    
    case mainnet
    case ropsten
    case rinkeby
    
    static var `default`: Chain {
        return .mainnet
    }
    
    var chainId: Int64 {
        switch self {
        case .mainnet:
            return 1
        case .ropsten:
            return 3
        case .rinkeby:
            return 4
        }
    }
    
    var netStats: String? {
        switch self {
        case .rinkeby:
            return "flypaper:Respect my authoritah!@stats.rinkeby.io"
        default:
            return nil
        }
    }
    
    var enode: String? {
        switch self {
        case .mainnet:
            return nil
        case .ropsten:
            return Constants.Ethereum.ropstenEnodeRawUrl
        case .rinkeby:
            return Constants.Ethereum.rinkebyEnodeRawUrl
        }
    }
    
    var genesis: String {
        switch self {
        case .mainnet:
            return GethMainnetGenesis()
        case .ropsten:
            return GethTestnetGenesis()
        case .rinkeby:
            return GethRinkebyGenesis()
        }
    }
    
    var description: String {
        return "\(self)"
    }
    
    var localizedDescription: String {
        switch self {
        case .mainnet:
            return "Mainnet"
        case .ropsten:
            return "Ropsten Testnet"
        case .rinkeby:
            return "Rinkeby Testnet"
        }
    }
    
    var path: String {
        return "/.\(description)"
    }
    
    var etherscanUrl: String {
        switch self {
        case .mainnet:
            return "api.etherscan.io"
        case .ropsten:
            return "ropsten.etherscan.io"
        case .rinkeby:
            return "rinkeby.etherscan.io"
        }
    }
    
    var clientUrl: String {
        switch self {
        case .mainnet:
            return "https://mainnet.infura.io"
        case .ropsten:
            return "https://ropsten.infura.io"
        case .rinkeby:
            return "https://rinkeby.infura.io"
        }
    }
    
    static func all() -> [Chain] {
        return [.mainnet, .ropsten, .rinkeby]
    }
    
}

