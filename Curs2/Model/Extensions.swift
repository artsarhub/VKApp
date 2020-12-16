//
//  Extensions.swift
//  Curs2
//
//  Created by Артём Сарана on 13.12.2020.
//

import UIKit

extension UIImageView {

    func makeCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true;
    }
}
