//
//  SwipeInteractionController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/22/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    public var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        case .began:
            self.interactionInProgress = true
            self.viewController.dismiss(animated: true, completion: nil)
            
        case .changed:
            self.shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled:
            self.interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            
            if !self.shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
    }
    
    func bindToViewController(viewController: UIViewController) {
        self.viewController = viewController
        self.prepareGestureRecognizerInView(view: viewController.view)
    }
}
