//
//  UIViewControllerExtension.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 31.12.19.
//  Copyright © 2019 Henrik Peters. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showWarning(title:String, body:String, then:(()->Void)? = nil, cancel:(()->Void)? = nil) {
        DispatchQueue.main.async {
            
            let alertController:UIAlertController = UIAlertController(title: title, message: body,
                                                                      preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction!) -> Void in
                cancel?()
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action:UIAlertAction!) -> Void in
                then?()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
