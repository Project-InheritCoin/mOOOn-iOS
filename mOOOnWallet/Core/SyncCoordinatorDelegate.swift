//
//  SyncCoordinatorDelegate.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Geth

protocol SyncCoordinatorDelegate: class {
    func syncDidChangeProgress(current: Int64, max: Int64)
    func syncDidFinished()
    func syncDidUpdateBalance(_ balanceHex: String, timestamp: Int64)
    func syncDidUpdateGasLimit(_ gasLimit: Int64)
    func syncDidReceiveTransactions(_ transactions: [GethTransaction], timestamp: Int64)
}
