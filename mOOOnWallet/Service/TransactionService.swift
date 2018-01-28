//
//  TransactionService.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Geth
import Alamofire

class TransactionService: TransactionServiceProtocol {
    
    private let context: GethContext
    private let client: GethEthereumClient
    private let keystore: KeystoreService
    private let chain: Chain
    
    init(core: Ethereum, keystore: KeystoreService) {
        // TODO: Check objects
        self.context = core.context
        self.client = core.client
        self.chain = core.chain
        self.keystore = keystore
    }
    
    func sendTransaction(amountHex: String, to: String, gasLimitHex: String, passphrase: String, result: @escaping (Result<GethTransaction>) -> Void) {
        Ethereum.syncQueue.async {
            do {
                let account = try self.keystore.getAccount(at: 0)
                let transaction = try self.createTransaction(amountHex: amountHex, to: to, gasLimitHex: gasLimitHex, account: account)
                let signedTransaction = try self.keystore.signTransaction(transaction, account: account, passphrase: passphrase, chainId: self.chain.chainId)
                try self.sendTransaction(signedTransaction)
                DispatchQueue.main.async {
                    result(.success(signedTransaction))
                }
            } catch {
                DispatchQueue.main.async {
                    result(.failure(error))
                }
            }
        }
    }
    
    func sendTokenTransaction(contractAddress: String, to: String, amountHex: String, passphrase: String, result: @escaping (Result<GethTransaction>) -> Void) {
        Ethereum.syncQueue.async {
            do {
                let account = try self.keystore.getAccount(at: 0)
                let transaction = try self.createTokenTransaction(contractAddress: contractAddress, to: to, amountHex: amountHex)
                let signedTransaction = try self.keystore.signTransaction(transaction, account: account, passphrase: passphrase, chainId: self.chain.chainId)
                try self.sendTransaction(signedTransaction)
                DispatchQueue.main.async {
                    result(.success(signedTransaction))
                }
            } catch {
                DispatchQueue.main.async {
                    result(.failure(error))
                }
            }
        }
    }
    
    private func createTransaction(amountHex: String, to: String, gasLimitHex: String, account: GethAccount) throws -> GethTransaction {
        var error: NSError?
        let gethAddress = GethNewAddressFromHex(to, &error)
        var noncePointer: Int64 = 0
        try client.getNonceAt(context, account: account.getAddress(), number: -1, nonce: &noncePointer)
        
        let intAmount = GethNewBigInt(0)
        intAmount?.setString(amountHex, base: 16)
        
        let gasLimit = GethNewBigInt(0)
        gasLimit?.setString(gasLimitHex, base: 16)
        let gasPrice = try client.suggestGasPrice(context)
        
        return GethNewTransaction(noncePointer, gethAddress, intAmount, gasLimit, gasPrice, nil)
    }
    
    private func createTokenTransaction(contractAddress: String, to: String, amountHex: String) throws -> GethTransaction {
        var error: NSError?
        let gethAddress = GethNewAddressFromHex(to, &error)
        guard let contract = GethBindContract(gethAddress, "", client, &error) else {
            throw TransactionServiceError.wrongContractAddress
        }
        let transactOpts = GethTransactOpts()
        let method = "{\"constant\": false, \"inputs\": [ { \"name\": \"_to\", \"type\": \"address\" }, { \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"transfer\", \"outputs\": [ { \"name\": \"success\", \"type\": \"bool\" } ], \"type\": \"function\"}"
        
        let addresInterface = GethInterface()!
        addresInterface.setString(to)
        let amountInterface = GethInterface()!
        let intAmount = GethNewBigInt(0)!
        intAmount.setString(amountHex, base: 16)
        amountInterface.setUint64(intAmount)
        let interfaces = GethInterfaces(2)!
        try interfaces.set(0, object: addresInterface)
        try interfaces.set(1, object: amountInterface)
        
        return try contract.transact(transactOpts, method: method, args: interfaces)
    }
    
    private func sendTransaction(_ signedTransaction: GethTransaction) throws {
        try client.sendTransaction(context, tx: signedTransaction)
    }
    
}

enum TransactionServiceError: Error {
    case wrongContractAddress
}

