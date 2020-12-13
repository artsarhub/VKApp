//
//  Avatar.swift
//  Curs2
//
//  Created by Артём Сарана on 11.12.2020.
//

import UIKit

@IBDesignable class Avatar: UIView {
    
    var image: UIImage?
    
    @IBInspectable var shadowRadius: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowOpacityPercent: CGFloat = 100 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let image = self.image else { return }
        
        print(image)
        
        let imageView = self.getImageView(rect, image)
        self.addSubview(imageView)
        
        let shadowedView = self.getShadowedView(rect)
        self.insertSubview(shadowedView, belowSubview: imageView)
    }
    
    private func getImageView(_ rect: CGRect, _ image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: rect)
        imageView.image = image
        imageView.makeCircle()
        return imageView
    }
    
    private func getShadowedView(_ rect: CGRect) -> UIView {
        let shadowView = UIView()
        let shadowLayer = CAShapeLayer()
        shadowLayer.fillColor = UIColor.black.cgColor
        shadowLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2).cgPath
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowColor = self.shadowColor.cgColor
        shadowLayer.shadowOffset = self.shadowOffset
        shadowLayer.shadowOpacity = Float(self.shadowOpacityPercent / 100)
        shadowLayer.shadowRadius = self.shadowRadius
        shadowView.layer.insertSublayer(shadowLayer, at: 0)
        return shadowView
    }
}
