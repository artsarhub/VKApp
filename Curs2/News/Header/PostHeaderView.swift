//
//  PostHeaderView.swift
//  Curs2
//
//  Created by Артём Сарана on 28.02.2021.
//

import UIKit

class PostHeaderView: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImageView.image = nil
        self.nameLabel.text = nil
        self.dateLabel.text = nil
    }
    
    func configure(with postHeader: PostHeaderDisplayItem) {
        self.nameLabel.text = postHeader.name
        self.avatarImageView.kf.setImage(with: postHeader.avatarUrl)
        self.dateLabel.text = postHeader.dateString
        self.avatarImageView.makeCircle()
    }
    
}
