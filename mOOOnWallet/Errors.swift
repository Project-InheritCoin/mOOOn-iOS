//
//  Errors.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 15..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit


protocol CustomError: Error {
    typealias ErrorInfo = (title: String?, message: String?, showing: Bool)
    var description: ErrorInfo? { get }
}

extension CustomError {
    var criticalError: ErrorInfo {
        return (title: "Critical error", message: "Something went wront. Please contact with developers", showing: true)
    }
}

enum EthereumError: CustomError {
    
    case nodeStartFailed(error: NSError)
    case accountExist
    case couldntGetNonce
    case alreadySubscribed
    
    var description: ErrorInfo? {
        switch self {
        case .nodeStartFailed(let error):
            return ("Starting node error", error.localizedDescription, true)
        case .accountExist:
            return (nil, "Account already exist", true)
        default:
            return nil
        }
    }
    
}
