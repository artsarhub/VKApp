//
//  FriendsSectionHeader.swift
//  Curs2
//
//  Created by Артём Сарана on 20.12.2020.
//

import UIKit

class FriendsSectionHeader: UITableViewHeaderFooterView {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = ""
        self.detailTextLabel?.text = ""
    }
}
