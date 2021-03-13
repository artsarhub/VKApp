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
    
    func configure(with post: Post) {
        self.nameLabel.text = "TEST"
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        self.dateLabel.text = dateFormatter.string(from: post.date)
        
        self.avatarImageView.image = UIImage(named: "moscow")
        self.avatarImageView.makeCircle()
    }
    
}
