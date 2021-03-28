//
//  PhotoTableViewCell.swift
//  Curs2
//
//  Created by Артём Сарана on 13.03.2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with post: Post) {
        guard let photoURL = URL(string: post.postPhotoURL) else { return }
        self.photoView.kf.setImage(with: photoURL)
    }
    
}
