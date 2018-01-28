//
//  ViewController.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 14..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit
import Geth

class BalanceViewController: UIViewController {
    
    var newAddressButton: UIButton!
    var addressLabel: UILabel!
    
    var walletBriefViewContainer: UIView!
    var walletTitleContainer: UIView!
    var tokenSymbolImageView: UIImageView!
    var tokenNameLabel: UILabel!
    var walletInfoTableView: UITableView!
    let walletInfoCellIdentifier = "walletInfoCell"
    var walletInfos: [String : String] = [String : String]()
    
    var walletTransactionsViewContainer: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupStandardSyncCoordinator()
        startSynchronization()
        setupSubviews()
        fetchWalletInfos()
    }
    
    func fetchWalletInfos() {
        fetchAccount()
        fetchBalance()
    }
    
    func fetchAccount() {
        let keystoreService = KeystoreService()
        do {
            let account = try keystoreService.getAccount(at: 0)
            walletInfos["Address"] = account.getAddress().getHex()
            self.walletInfoTableView.reloadData()
        } catch {
            print("KetstoreService Error : Cannot access an account")
        }
    }
    
    func fetchBalance() {
        let balanceService = BalanceService()
        balanceService.fetchBalanceFromEtherscan(completion: {
            [weak self] balance in
            self?.walletInfos["Balance"] = balance.description
            self?.walletInfoTableView.reloadData()
        })
    }
    
    func setupSubviews() {
        setupWalletBrifView()
        setupWalletTransactionsView()
        setupConstraints()
    }
    
    func setupWalletBrifView() {
        self.walletBriefViewContainer = UIView()
        self.walletBriefViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.walletBriefViewContainer)
        
        self.walletTitleContainer = UIView()
        self.walletTitleContainer.translatesAutoresizingMaskIntoConstraints = false
        self.walletBriefViewContainer.addSubview(self.walletTitleContainer)
        
        self.tokenSymbolImageView = UIImageView()
        self.tokenSymbolImageView.image = UIImage(named: "mOOOn")
        self.tokenSymbolImageView.translatesAutoresizingMaskIntoConstraints = false
        self.walletTitleContainer.addSubview(self.tokenSymbolImageView)
        
        self.tokenNameLabel = UILabel()
        self.tokenNameLabel.text = "mOOOn"
        self.tokenNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.walletTitleContainer.addSubview(self.tokenNameLabel)
        
        self.walletInfoTableView = UITableView()
        self.walletInfoTableView.translatesAutoresizingMaskIntoConstraints = false
        self.walletBriefViewContainer.addSubview(self.walletInfoTableView)
        self.walletInfoTableView.delegate = self
        self.walletInfoTableView.dataSource = self
        self.walletInfoTableView.register(WalletInfoTableViewCell.self, forCellReuseIdentifier: walletInfoCellIdentifier)
        
        self.walletBriefViewContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[walletTitleContainer]|",
                                    options: .directionLeadingToTrailing,
                                    metrics: nil,
                                      views: ["walletTitleContainer" : self.walletTitleContainer]))
        self.walletBriefViewContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[walletTitleContainer(70)][walletInfoTableView(100)]",
                                           options: .directionLeadingToTrailing,
                                           metrics: nil,
                                           views: ["walletTitleContainer" : self.walletTitleContainer,
                                                   "walletInfoTableView" : self.walletInfoTableView]))
        self.walletTitleContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[symbol(70)][tokenName]|",
                                           options: .directionLeadingToTrailing,
                                           metrics: nil,
                                           views: ["symbol" : self.tokenSymbolImageView,
                                                   "tokenName" : self.tokenNameLabel]))
        self.walletTitleContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[symbol]|",
                                           options: .directionLeadingToTrailing,
                                           metrics: nil,
                                           views: ["symbol" : self.tokenSymbolImageView]))
        self.walletTitleContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[tokenName]|",
                                           options: .directionLeadingToTrailing,
                                           metrics: nil,
                                           views: ["tokenName" : self.tokenNameLabel]))
        self.walletBriefViewContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[walletInfoTableView]|",
                                                    options: .directionLeadingToTrailing,
                                                    metrics: nil,
                                                      views: ["walletInfoTableView" : self.walletInfoTableView]))
    }
    
    func setupWalletTransactionsView() {
        
    }
    
    func setupConstraints() {
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[briefContainer]|",
                                                                options: .directionLeadingToTrailing,
                                                                metrics: nil,
                                                                views: ["briefContainer" : self.walletBriefViewContainer]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[briefContainer(170)]",
                                                                options: .directionLeadingToTrailing,
                                                                metrics: nil,
                                                                views: ["briefContainer" : self.walletBriefViewContainer]))
    }
    
    @objc func newAddressButtonTapped() {
        // 새로운 account 만들기 샘플
        let keystoreService = KeystoreService()
        do {
            let account = try keystoreService.createAccount(passphrase: "1212")
            print("KeystoreService : New account is created")
            self.addressLabel.text = account.getAddress().getHex()
        } catch {
            print("KeystoreService Error : Cannot create new account")
            do {
                let account = try keystoreService.getAccount(at: 0)
                self.addressLabel.text = account.getAddress().getHex()
            } catch {
                print("KetstoreService Error : Cannot access an account")
            }
        }
    }
    
    func setupStandardSyncCoordinator() {
        let ethereumCore = Ethereum.core
        ethereumCore.syncCoordinator = StandardSyncCoordinator()
    }
    
    func startSynchronization() {
        Ethereum.syncQueue.async { [unowned self] in
            do  {
                try Ethereum.core.start(chain: Chain.mainnet, delegate: self)
                
            } catch {
                DispatchQueue.main.async { [unowned self] in
                    print("sync faild.")
                }
            }
        }
    }
}

extension BalanceViewController : SyncCoordinatorDelegate {
    // 싱크를 맞추면서 호출되는 델리게이트에 따라 데이터가 업데이트 될 것이고, 업데이트 된 데이터에 맞추어 뷰를 업데이트 해주어야한다.
    // 일단 테스트를 위해 임시로 BalanceViewController가 델리게이트롤 수행하도록 지정
    
    func syncDidChangeProgress(current: Int64, max: Int64) {
        
    }
    
    func syncDidFinished() {
        
    }
    
    func syncDidUpdateBalance(_ balanceHex: String, timestamp: Int64) {
        
    }
    
    func syncDidUpdateGasLimit(_ gasLimit: Int64) {
        
    }
    
    func syncDidReceiveTransactions(_ transactions: [GethTransaction], timestamp: Int64) {
        
    }
}

extension BalanceViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: walletInfoCellIdentifier)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.detailTextLabel?.text = self.walletInfos["Address"]
        } else  if indexPath.row == 1 {
            cell.textLabel?.text = "Balance"
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.detailTextLabel?.text = self.walletInfos["Balance"]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
