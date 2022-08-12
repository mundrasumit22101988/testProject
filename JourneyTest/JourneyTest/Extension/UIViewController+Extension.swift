//
//  UIViewController+Extension.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import Foundation
import UIKit

protocol PropertyStoring {
    associatedtype T
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T
}

extension PropertyStoring {
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
}

extension UIViewController: PropertyStoring {
    public typealias T = UIActivityIndicatorView
    
    private struct CustomProperties {
        static var activity = UIActivityIndicatorView()
    }
    
    var activity: UIActivityIndicatorView {
        get {
            return getAssociatedObject(&CustomProperties.activity, defaultValue: CustomProperties.activity)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.activity, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func showControllerActivity() {
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.startAnimating()
        activity.style = .large
        view.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func stopControllerActivity() {
        DispatchQueue.main.async {
            guard self.activity.superview != nil else {
                return
            }
            
            self.activity.stopAnimating()
            self.activity.removeFromSuperview()
        }
    }
}
