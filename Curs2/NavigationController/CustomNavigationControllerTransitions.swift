//
//  CustomNavigationControllerTransitions.swift
//  Curs2
//
//  Created by Артём Сарана on 06.01.2021.
//

import UIKit

class PushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        transitionContext.containerView.addSubview(destination.view)

        source.view.frame = transitionContext.containerView.frame
        destination.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        destination.view.frame = transitionContext.containerView.frame
        destination.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)

        UIView.animate(withDuration: self.duration) {
            destination.view.transform = .identity
        } completion: { completed in
            transitionContext.completeTransition(completed && !transitionContext.transitionWasCancelled)
        }

    }
}

class PopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        UIView.animate(withDuration: self.duration) {
            source.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        } completion: { completed in
            transitionContext.completeTransition(completed && !transitionContext.transitionWasCancelled)
        }

    }
}

class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    var animatedViewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            animatedViewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var recognizerViewController: UIViewController?
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false

    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.animatedViewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizerViewController!.view)
            let relativeTranslation = translation.x / (recognizerViewController!.view.bounds.width )
            let progress = max(0, min(1, relativeTranslation))
            
            self.shouldFinish = progress > 0.3

            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }
}
