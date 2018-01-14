//
//  ViewController.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 14..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {
    
    var sendButton: UIButton!
    var receiveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupSubviews()
    }
    
    func setupSubviews() {
        setupSendButton()
        setupReceiveButton()
    }
    
    func setupSendButton() {
        self.sendButton = UIButton(frame: CGRect(x: 50, y: 300, width: 100, height: 50))
        self.sendButton.setTitle("Send", for: .normal)
        self.sendButton.backgroundColor = UIColor.gray
        self.view.addSubview(self.sendButton)
        self.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    func setupReceiveButton() {
        self.receiveButton = UIButton(frame: CGRect(x: 225, y: 300, width: 100, height: 50))
        self.receiveButton.setTitle("Receive", for: .normal)
        self.receiveButton.backgroundColor = UIColor.gray
        self.view.addSubview(self.receiveButton)
        self.receiveButton.addTarget(self, action: #selector(receiveButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendButtonTapped() {
        print("sendButtonTapped")
    }
    
    @objc func receiveButtonTapped() {
        print("receiveButtonTapped")
    }

}

