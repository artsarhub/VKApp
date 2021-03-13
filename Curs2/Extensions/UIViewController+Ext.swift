//
//  UIViewController+Ext.swift
//  Curs2
//
//  Created by Артём Сарана on 02.02.2021.
//

import UIKit

extension UIViewController {
    func show(error: Error) {
        let alertVC = UIAlertController(title: "Ошибка",
                                        message: error.localizedDescription,
                                        preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                     style: .default)
        alertVC.addAction(okButton)
        present(alertVC, animated: true)
    }
}
