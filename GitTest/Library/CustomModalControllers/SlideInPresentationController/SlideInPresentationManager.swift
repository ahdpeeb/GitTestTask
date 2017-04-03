//
//  SlideInPresentationManager.swift
//  RecipesList
//
//  Created by Bondar Pavel on 12/13/16.
//  Copyright © 2016 Pavel Bondar. All rights reserved.
//

import UIKit

enum SlideInPresentationManagerDirection {
    case left
    case top
    case right
    case bottom
}

enum SlideInPresentationManagerSize {
    case all
    case twoThirds
}

class SlideInPresentationManager: NSObject {
    var direction = SlideInPresentationManagerDirection.right
    var size = SlideInPresentationManagerSize.all
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        var presentationController: UIPresentationController
        
        switch size {
        case SlideInPresentationManagerSize.twoThirds:
            presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
        case SlideInPresentationManagerSize.all:
            presentationController = UIPresentationController(presentedViewController: presented, presenting: presenting)
        }
        
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return SlideInPresentationAnimator(direction: direction, isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return SlideInPresentationAnimator(direction: direction, isPresentation: false)
    }
    
}
