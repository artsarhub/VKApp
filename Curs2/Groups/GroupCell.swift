//
//  GroupCell.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: Avatar!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.avatar.imageView.image = nil
    }
    
    func configure(with group: Group) {
        self.nameLabel.text = group.name
        let url = URL(string: group.photo100)
        self.avatar.imageView.kf.setImage(with: url)
    }

}
