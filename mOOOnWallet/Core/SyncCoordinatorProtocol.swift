//
//  SyncCoordinatorProtocol.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Geth

protocol SyncCoordinatorProtocol {
    func startSync(chain: Chain, delegate: SyncCoordinatorDelegate) throws
    func getClient() throws -> GethEthereumClient
}
