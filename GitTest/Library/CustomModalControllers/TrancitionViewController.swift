//
//  TrancitionViewController.swift
//  RecipesList
//
//  Created by Bondar Pavel on 12/13/16.
//  Copyright © 2016 Pavel Bondar. All rights reserved.
//

import UIKit

class TrancitionViewController: UIViewController {
    @IBOutlet var popView: UIView?
    
    var presentationManager = SlideInPresentationManager()
    
    func animateInfoView(scale: CGFloat, interval: TimeInterval) {
        let view = self.popView
        view?.transform = CGAffineTransform(scaleX: scale, y: scale)
        view?.alpha = 0.5
        UIView.animate(withDuration: interval) {
            view?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            view?.alpha = 1
        }
    }
    
    func roundPopView(miltiplier: CGFloat, borderColor: CGColor? = nil, borderWidth: CGFloat? = nil) {
        guard let view = self.popView else { return }
        let layer = view.layer
        let height = view.bounds.height
        let width = view.bounds.width
        let maxSize = max(width, height)
        
        layer.cornerRadius  = maxSize / miltiplier
        borderColor.map {  layer.borderColor = $0 }
        borderWidth.map { layer.borderWidth = $0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
