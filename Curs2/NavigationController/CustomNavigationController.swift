//
//  CustomNavigationController.swift
//  Curs2
//
//  Created by Артём Сарана on 06.01.2021.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let interactiveTransition = InteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            self.interactiveTransition.animatedViewController = toVC
            self.interactiveTransition.recognizerViewController = fromVC
            return PushTransition()
        case .pop:
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.recognizerViewController = fromVC
                self.interactiveTransition.animatedViewController = toVC
            }
            return PopTransition()
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactiveTransition.hasStarted ? self.interactiveTransition : nil
    }
}
