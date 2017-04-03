//
//  FlipDismissAnimationControllerViewController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/22/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public var destinationFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
