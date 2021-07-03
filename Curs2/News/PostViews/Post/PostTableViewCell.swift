//
//  PostTableViewCell.swift
//  Curs2
//
//  Created by Артём Сарана on 02.03.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let horizontalInset: CGFloat = 12
    static let verticalInset: CGFloat = 8
    
    private let postTextLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(postTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post, font: UIFont) {
        postTextLabel.text = post.text
        postTextLabel.numberOfLines = 0
        postTextLabel.contentMode = .scaleToFill
        postTextLabel.font = font
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postTextLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postTextLabel.frame = contentView.bounds.insetBy(dx: PostTableViewCell.horizontalInset, dy: PostTableViewCell.verticalInset)
    }
    
}
