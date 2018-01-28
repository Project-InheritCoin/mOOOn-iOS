//
//  StandardSyncCoordinator.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 16..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Geth

class StandardSyncCoordinator: SyncCoordinatorProtocol {
    
    private var chain: Chain!
    
    func startSync(chain: Chain, delegate: SyncCoordinatorDelegate) throws {
        self.chain = chain
        delegate.syncDidFinished()
    }
    
    func getClient() throws -> GethEthereumClient {
        var error: NSError?
        let client =  GethNewEthereumClient(chain.clientUrl, &error)
        guard error == nil else {
            throw error!
        }
        return client!
    }
    
}
