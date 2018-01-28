//
//  Token.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 16..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Foundation

class Token {
    var contractAddress: String!
    var symbol: String!
    var decimals: String!
}

class mOOOn: Token {
    override init() {
        super.init()
        self.contractAddress = "0x77777777777"
        self.symbol = "OOO"
        self.decimals = "????????"
    }
}
