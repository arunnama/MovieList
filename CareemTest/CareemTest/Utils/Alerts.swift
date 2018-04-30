//
//  Alerts.swift
//  MovieTest
//
//  Created by Arun Kumar Nama on 27/4/18.
//  Copyright © 2018 idpmobile. All rights reserved.
//

import UIKit

extension UIViewController {

    func showErrorAlert(error:MovieError)
    {
            let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        
    }
}
