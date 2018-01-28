//
//  SendViewController.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {
    
    var sendTransactionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupSubviews()
    }
    
    func setupSubviews() {
        self.sendTransactionButton = UIButton()
        self.sendTransactionButton.frame.size = CGSize(width: 200, height: 50)
        self.sendTransactionButton.setTitle("Send Transaction", for: .normal)
        self.sendTransactionButton.backgroundColor = UIColor.gray
        self.view.addSubview(self.sendTransactionButton)
        self.sendTransactionButton.center = self.view.center
        self.sendTransactionButton.addTarget(self, action: #selector(sendTransactionButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendTransactionButtonTapped() {
        let keystoreService: KeystoreService = KeystoreService()
        let ethereumCore: Ethereum = Ethereum.core
        let mOOOnToken: Token = mOOOn()
        
        let transactionService: TransactionService = TransactionService(core: ethereumCore, keystore: keystoreService)
        transactionService.sendTokenTransaction(contractAddress: mOOOnToken.contractAddress,
                                                to: "보낼 주소",
                                                amountHex: "보낼 토큰의 양",
                                                passphrase: "계정 비밀번호",
                                                result: { result in
                                                    switch result {
                                                    case .success(let signdTransaction) :
                                                        print("토큰 전송 성공")
                                                        break
                                                    case .failure(let error) :
                                                        print("토큰 전송 실패")
                                                        break
                                                    }
                                                    
        })
    }
}
