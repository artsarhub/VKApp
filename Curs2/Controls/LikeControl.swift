//
//  LikeControl.swift
//  Curs2
//
//  Created by Артём Сарана on 20.12.2020.
//

import UIKit

class LikeControl: UIControl {
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            self.likeButton.addTarget(self, action: #selector(likeButtonHandler(_:)), for: .touchUpInside)
        }
    }
    
    var likesCount: Int = 0 {
        didSet {
            self.likeButton.setTitle("\(self.likesCount)", for: .normal)
            UIView.transition(with: self.likeButton,
                              duration: 0.2,
                              options: [.transitionFlipFromBottom]) {
                self.likeButton.setTitle("\(self.likesCount)", for: .normal)
            }
            let likeImage = self.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            let textColor = self.isLiked ? UIColor.red : UIColor.black
            self.likeButton.setImage(likeImage, for: .normal)
            self.likeButton.setTitleColor(textColor, for: .normal)
        }
    }
    var isLiked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc private func likeButtonHandler(_ sender: UIButton) {
        self.isLiked.toggle()
        isLiked ? self.likesCount += 1 : self.likesCount > 0 ? self.likesCount -= 1 : nil
//        self.sendActions(for: .valueChanged)
    }
    
}
