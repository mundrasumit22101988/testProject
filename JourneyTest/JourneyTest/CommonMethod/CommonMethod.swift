//
//  CommonMethod.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import Foundation
import UIKit

class CommonMethod {
    @discardableResult static func showAlert(title: String? = nil, alert: String?, delegate: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController? {
        let titleString: String
        let messageStr: String
        if let title = title {
            titleString = title
        } else {
            titleString = ""
        }
        
        if let message = alert {
            messageStr = message
        } else {
            messageStr = "Unexpected error"
        }
       
        let alertController = UIAlertController(title: titleString,
                message: messageStr,
                preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: .default,
                                                handler: handler))
        DispatchQueue.main.async {
            delegate.present(alertController, animated: true)
        }
        return alertController
    }
}
