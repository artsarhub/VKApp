//
//  PostTableViewCell.swift
//  Curs2
//
//  Created by Артём Сарана on 02.03.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with post: Post) {
        self.postTextLabel.text = post.text
        self.postTextLabel.numberOfLines = 0
        self.postTextLabel.contentMode = .scaleToFill
    }
    
    override func prepareForReuse() {
        postTextLabel.text = nil
    }
    
}
