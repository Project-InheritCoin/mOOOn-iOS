//
//  BalanceServiceProtocol.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 28..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import Foundation

protocol BalanceServiceProtocol {
    func fetchBalanceFromEtherscan(completion: @escaping (Double) -> Void);
}
