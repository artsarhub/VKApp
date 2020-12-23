//
//  NewsTableViewCell.swift
//  Curs2
//
//  Created by Артём Сарана on 23.12.2020.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: Avatar!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var likeControll: LikeControl!
    @IBOutlet weak var visitedCount: UILabel!
    
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
        
        self.textView.text = ""
        self.groupName.text = ""
        self.dateLabel.text = ""
    }

}
