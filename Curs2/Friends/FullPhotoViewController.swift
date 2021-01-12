//
//  FullPhotoViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 31.12.2020.
//

import UIKit

class FullPhotoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    enum PhotoSwipeDirection {
        case left, right
    }
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    var panGR: UIPanGestureRecognizer!
    var animator: UIViewPropertyAnimator!
    var swipeGR: UISwipeGestureRecognizer!
    
    var direction: PhotoSwipeDirection = .left
    
    var centerImageView: UIImageView!
    var rightImageView: UIImageView!
    var leftImageView: UIImageView!
    
    var centerFramePosition: CGRect!
    var rightFramePosition: CGRect!
    var leftFramePosition: CGRect!
    
    var album =  [UIImage]()
    var index: Int = 0
    
    var toLeftAnimation = {}
    var toRightAnimation = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGallery()
        setupAnimations()
    }
    
    private func setupGallery() {
        self.centerFramePosition = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.rightFramePosition = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.leftFramePosition = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.imageView1.frame = centerFramePosition
        self.imageView2.frame = rightFramePosition
        self.imageView3.frame = leftFramePosition
        
        self.centerImageView = imageView1
        self.rightImageView = imageView2
        self.leftImageView = imageView3
        
        centerImageView.image = album[index]
        if index + 1 < album.count {
            rightImageView.image = album[index + 1]
        } else {
            rightImageView.image = album[0]
        }
        if index - 1 >= 0 {
            leftImageView.image = album[index - 1]
        } else {
            leftImageView.image = album[album.count - 1]
        }
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(panGR)
        panGR.delegate = self
        
        swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGR.direction = .down
        view.addGestureRecognizer(swipeGR)
        swipeGR.delegate = self
        
    }
    
    private func setupAnimations() {
        toLeftAnimation = self.getAnimation(to: .left)
        toRightAnimation = self.getAnimation(to: .right)
    }
    
    private func getAnimation(to direction: PhotoSwipeDirection) -> () -> Void {
        let finalPosition = UIScreen.main.bounds.width
        return {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                    self.centerImageView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
                    switch direction {
                    case .left:
                        self.centerImageView.frame  =  self.centerImageView.frame.offsetBy(dx:  -finalPosition, dy: 0.0)
                        self.rightImageView.frame  =  self.rightImageView.frame.offsetBy(dx:  -finalPosition, dy: 0.0)
                    case .right:
                        self.centerImageView.frame  =  self.centerImageView.frame.offsetBy(dx:  finalPosition, dy: 0.0)
                        self.leftImageView.frame  =  self.leftImageView.frame.offsetBy(dx:  finalPosition, dy: 0.0)
                    }
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1) {
                    self.centerImageView.alpha  = 0.0
                }
            })
        }
    }
    
    private func reconfigureImageViews(to direction: PhotoSwipeDirection) {
        switch direction {
        case .left:
            let tmpIV = centerImageView
            centerImageView = rightImageView
            rightImageView = tmpIV
            
            rightImageView.frame = rightFramePosition
            rightImageView.alpha  = 1
            rightImageView.transform = .identity
            
            index = index + 1 < album.count ? index + 1 : 0
        case .right:
            let tmpIV = centerImageView
            centerImageView = leftImageView
            leftImageView = tmpIV
            
            leftImageView.frame = leftFramePosition
            leftImageView.alpha  = 1
            leftImageView.transform = .identity
            
            index = index - 1 >= 0 ? index - 1 : album.count - 1
        }
        
        if index == album.count-1 {
            rightImageView.image = album[0]
        } else {
            rightImageView.image = album[index + 1]
        }
        
        if index == 0 {
            leftImageView.image = album[album.count-1]
        } else {
            leftImageView.image = album[index - 1]
        }
        
    }
    
    @objc func didPan( _ panGesture: UIPanGestureRecognizer) {
        let finalPosition = UIScreen.main.bounds.width
        
        switch panGesture.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
            direction = panGesture.velocity(in: self.view).x > 0 ? .right : .left
            
            switch direction {
            case .left:
                animator.addAnimations(self.toLeftAnimation)
            case .right:
                animator.addAnimations(self.toRightAnimation)
            }
            
            animator.addCompletion { _ in
                if !self.animator.isReversed {
                    self.reconfigureImageViews(to: self.direction)
                }
            }
            
            animator.pauseAnimation()
            
        case .changed:
            let translation = panGesture.translation(in: self.view)
            let multiplayer = direction == .left ?  -1 : 1
            animator.fractionComplete = CGFloat(multiplayer) * translation.x / finalPosition
            
        case .ended:
            let velocity = panGesture.velocity(in: self.view)
            let shouldCancel = direction == .left && velocity.x > 0 || direction == .right && velocity.x < 0 || animator.fractionComplete < 0.25
            if shouldCancel && !animator.isReversed { animator.isReversed.toggle() }
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)
            
        default: return
        }
        
        
    }
    
    @objc func didSwipe(_ swipeGesture: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "closeFullPhotoView", sender: nil)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.swipeGR &&
            otherGestureRecognizer == self.panGR {
            return true
        }
        return false
    }
    
}
