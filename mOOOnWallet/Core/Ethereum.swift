//
//  Ethereum.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit
import Geth

protocol EthereumProtocol {
    func start(chain: Chain, delegate: SyncCoordinatorDelegate) throws
}

class Ethereum: EthereumProtocol {
    
    static let core = Ethereum()
    static let syncQueue = DispatchQueue(label: "com.ethereum-wallet.sync")
    
    let context: GethContext = GethNewContext()
    var syncCoordinator: SyncCoordinatorProtocol!
    var client: GethEthereumClient!
    var chain: Chain!
    
    private init() {}
    
    func start(chain: Chain, delegate: SyncCoordinatorDelegate) throws {
        try syncCoordinator.startSync(chain: chain, delegate: delegate)
        self.client = try syncCoordinator.getClient()
        self.chain = chain
    }
    
}
