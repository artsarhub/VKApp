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
    
    func configureWith(post: Post) {
        
    }
    
}
