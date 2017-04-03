//
//  FlipTransitionDelegate.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/22/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import Foundation

class FlipTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let swipeInteractionController = SwipeInteractionController()
    
    func animationController(forPresented presented: UIViewController,
                                         presenting: UIViewController,
                                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    {
        return FlipApperdAnimationController()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
}
