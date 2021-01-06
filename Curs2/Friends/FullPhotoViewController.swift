//
//  FullPhotoViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 31.12.2020.
//

import UIKit

class FullPhotoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    var album = [UIImage]()
    var index: Int = 0
    
    var panGR: UIPanGestureRecognizer!
    var animator: UIViewPropertyAnimator!
    var swipeGR: UISwipeGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupImage()
    }
    
    private func setupImage() {
        let centerFramePosition = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let rightFramePosition = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let leftFramePosition = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.imageView1.frame = centerFramePosition
        self.imageView2.frame = leftFramePosition
        self.imageView3.frame = rightFramePosition
        
        self.imageView1.image = album[self.index]
        
        if self.index + 1 < self.album.count {
            self.imageView3.image = self.album[index + 1]
        }
        if self.index - 1 >= 0 {
            self.imageView2.image = self.album[self.index - 1]
        }
        
        self.panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.panGR.delegate = self
        self.view.addGestureRecognizer(self.panGR)
        
        self.swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        self.swipeGR.delegate = self
        self.swipeGR.direction = .down
        self.view.addGestureRecognizer(self.swipeGR)
    }
    
    @objc func didSwipe(_ swipeGesture: UISwipeGestureRecognizer) {
        print("Unwind Segue")
    }
    
    @objc func didPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            print("began")
        case .changed:
            print(panGesture.velocity(in: self.view))
        default:
            return
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
