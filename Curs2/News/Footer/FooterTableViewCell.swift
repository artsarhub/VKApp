//
//  FooterTableViewCell.swift
//  Curs2
//
//  Created by Артём Сарана on 28.02.2021.
//

import UIKit

class FooterTableViewCell: UITableViewCell {

    @IBOutlet weak var likesControl: LikeControl!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var repostsButton: UIButton!
    @IBOutlet weak var viewsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.likesControl.isLiked = false
        self.likesControl.likesCount = 0
        self.commentsButton.setTitle("0", for: .normal)
        self.repostsButton.setTitle("0", for: .normal)
        self.viewsButton.setTitle("0", for: .normal)
    }
    
    func configure(with post: Post) {
        self.likesControl.likesCount = post.likesCount
        self.commentsButton.setTitle("\(post.commentsCount)", for: .normal)
        self.repostsButton.setTitle("\(post.repostsCount)", for: .normal)
        self.viewsButton.setTitle("1", for: .normal)
    }
    
}
