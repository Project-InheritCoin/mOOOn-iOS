//
//  TransactionServiceProtocol.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Geth
import Alamofire

protocol TransactionServiceProtocol {
    /// Send transaction
    ///
    /// - Parameters:
    ///   - amount: Amount ot send base 16 string
    ///   - to: Recepient address
    ///   - gasLimit: Gas limit hex string
    ///   - passphrase: Password to unlock wallet
    func sendTransaction(amountHex: String, to: String, gasLimitHex: String, passphrase: String, result: @escaping (Result<GethTransaction>) -> Void)
    func sendTokenTransaction(contractAddress: String, to: String, amountHex: String, passphrase: String, result: @escaping (Result<GethTransaction>) -> Void)
}
