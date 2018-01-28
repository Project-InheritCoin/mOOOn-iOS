//
//  ReceiveViewController.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 28..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit
import Geth

class ReceiveViewController : UIViewController {
    
    var qrCodeImageView: UIImageView!
    var addressLabel: UILabel!
    var copyButton: UIButton!
    var account: GethAccount!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        loadAccountInfo()
        setupViewComponents()
    }
    
    func loadAccountInfo() {
        let keystoreService = KeystoreService()
        
        do {
            let account = try keystoreService.getAccount(at: 0)
            self.account = account
        } catch {
            print("KetstoreService Error : Cannot access an account")
        }
    }
    
    func setupViewComponents() {
        setupQRCodeImageView()
        setupAddressLabel()
        setupCopyButton()
        setupConstraints()
    }
    
    func setupQRCodeImageView() {
        let qrCodeService = QRCodeService()
        do {
            self.qrCodeImageView = UIImageView()
            self.qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
            self.qrCodeImageView.image = try qrCodeService.createQR(fromString: account.getAddress().getHex(), size: CGSize(width: 300, height: 300))
        } catch {
            print("Error : QRCodeImage Generating Error")
        }
        self.view.addSubview(self.qrCodeImageView)
    }
    
    func setupAddressLabel() {
        self.addressLabel = UILabel()
        self.addressLabel.text = account.getAddress().getHex()
        self.addressLabel.font = UIFont.systemFont(ofSize: 13)
        self.addressLabel.textAlignment = .center
        self.addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.addressLabel)
    }
    
    func setupCopyButton() {
        self.copyButton = UIButton()
        self.copyButton.backgroundColor = UIColor.blue
        self.copyButton.setTitle("Copy", for: .normal)
        self.copyButton.translatesAutoresizingMaskIntoConstraints = false
        self.copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.copyButton)
    }
    
    func setupConstraints() {
        let views: [String : UIView] = ["qrCode" : self.qrCodeImageView,
                                        "addressLabel" : self.addressLabel,
                                        "copyButton" : copyButton]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[qrCode(300)]-20-[addressLabel(30)]-20-[copyButton(50)]",
                                                                options: .alignAllCenterX,
                                                                metrics: nil,
                                                                views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[qrCode(300)]",
                                                                options: .directionLeadingToTrailing,
                                                                metrics: nil,
                                                                views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[addressLabel]|",
                                                                options: .directionLeadingToTrailing,
                                                                metrics: nil,
                                                                views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[copyButton(100)]",
                                                                options: .directionLeadingToTrailing,
                                                                metrics: nil,
                                                                views: views))
    }
    
    @objc func copyButtonTapped() {
        UIPasteboard.general.string = self.account.getAddress().getHex()
    }
}
