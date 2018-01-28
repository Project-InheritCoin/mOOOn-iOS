//
//  KeystoreServiceProtocol.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Geth

protocol KeystoreServiceProtocol {
    func getAccount(at index: Int) throws -> GethAccount
    func createAccount(passphrase: String) throws -> GethAccount
    func jsonKey(for account: GethAccount, passphrase: String) throws -> Data
    func jsonKey(for account: GethAccount, passphrase: String, newPassphrase: String) throws -> Data
    func restoreAccount(with jsonKey: Data, passphrase: String) throws -> GethAccount
    func deleteAccount(_ account: GethAccount, passphrase: String) throws
    func deleteAllAccounts(passphrase: String) throws
    func signTransaction(_ transaction: GethTransaction, account: GethAccount, passphrase: String, chainId: Int64) throws -> GethTransaction
}

