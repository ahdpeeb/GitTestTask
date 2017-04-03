//
//  FlipAnimationController.swift
//  GuessThePet
//
//  Created by Nikola Andriiev on 2/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class FlipApperdAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // Original Frame of destination controoler root view before amination.
    // Default frame = 0
    public var originFrame = CGRect.zero
    
    // Default transition duretion = 2
    public var animationDuretion: TimeInterval = 2
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuretion
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        //initial state of snapshot
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = initialFrame
        snapshot?.layer.cornerRadius = 25
        snapshot?.layer.masksToBounds = true
        snapshot?.layer.transform = self.gorizontalRotationAnimation(angle: M_PI_2)
        
        containerView.addSubview(snapshot!)
        containerView.addSubview(toVC.view)
        toVC.view.isHidden = true
        
        self.perspectiveTransformForContainerView(containerView)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                    fromVC.view.layer.transform = self.gorizontalRotationAnimation(angle: -M_PI_2)
                })
            
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                    snapshot?.layer.transform = self.gorizontalRotationAnimation(angle: 0)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    snapshot?.frame = finalFrame
                })
                
        }, completion: { _ in
                toVC.view.isHidden = false
                fromVC.view.layer.transform = self.gorizontalRotationAnimation(angle: 0)
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    // MARK: Accessory methods
    
    //this method create copy(snapshot) of destination controllerView
    private func snapshot(origin: UIView, customithationBlock: (_ copy: UIView) -> ()) -> UIView? {
        let snapshot = origin.snapshotView(afterScreenUpdates: true) // make snapshot of destination controller view
        if let snapshot = snapshot {
            customithationBlock(snapshot)
        }
        
        return snapshot
    }
    
    private func perspectiveTransformForContainerView(_ containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        // add transform to all layers in hierarchy
        containerView.layer.sublayerTransform = transform
    }
    
    private func gorizontalRotationAnimation(angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
}
