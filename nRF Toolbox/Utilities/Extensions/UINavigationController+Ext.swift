//
//  UINavigationController+Ext.swift
//  nRF Toolbox
//
//  Created by Nick Kibysh on 22/08/2019.
//  Copyright © 2019 Nordic Semiconductor. All rights reserved.
//

import UIKit

extension UINavigationController {
    static func nordicBranded(rootViewController: UIViewController) -> UINavigationController {
        let nc = UINavigationController(rootViewController: rootViewController)
        nc.navigationBar.tintColor = .almostWhite
        nc.navigationBar.barTintColor = .nordicBlue
        
        if #available(iOS 11.0, *) {
            let attributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : UIColor.almostWhite
            ]
            
            nc.navigationBar.titleTextAttributes = attributes
            nc.navigationBar.largeTitleTextAttributes = attributes
            nc.navigationBar.prefersLargeTitles = true
        }
        
        return nc
    }
}
