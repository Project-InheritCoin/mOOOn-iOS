//
//  QRCodeService.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 28..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit

enum QRServiceError: Error {
    case cantCreateQR
}

class QRCodeService: QRServiceProtocol {
    
    func createQR(fromString string: String, size: CGSize) throws -> UIImage {
        guard
            let data = string.data(using: String.Encoding.utf8),
            let filter = CIFilter(name: "CIQRCodeGenerator"),
            let colorFilter = CIFilter(name: "CIFalseColor") else {
                throw QRServiceError.cantCreateQR
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("L", forKey: "inputCorrectionLevel")
        
        colorFilter.setValue(filter.outputImage, forKey: "inputImage")
        
        guard let qrCodeImage = colorFilter.outputImage else {
            throw QRServiceError.cantCreateQR
        }
        
        let scaleX = size.width / qrCodeImage.extent.size.width
        let scaleY = size.height / qrCodeImage.extent.size.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        guard let output = filter.outputImage?.transformed(by: transform) else {
            throw QRServiceError.cantCreateQR
        }
        
        return UIImage(ciImage: output)
    }
    
}
