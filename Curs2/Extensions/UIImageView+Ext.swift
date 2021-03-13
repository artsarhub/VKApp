//
//  UIImageView+Ext.swift
//  Curs2
//
//  Created by Артём Сарана on 02.02.2021.
//

import UIKit

extension UIImageView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true;
    }
}
