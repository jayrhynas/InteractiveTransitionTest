//
//  DetailTransitionController.swift
//  InteractiveTransitionTest
//
//  Created by Jayson Rhynas on 2018-09-28.
//  Copyright © 2018 Jayson Rhynas. All rights reserved.
//

import UIKit

class DetailTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    let operation: UINavigationController.Operation
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator = getAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if animator == nil {
            animator = getAnimator(using: transitionContext)
        }
        return animator
    }
    
    private var animator: UIViewPropertyAnimator!
    
    private func getAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator? {
        let container = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC   = transitionContext.viewController(forKey: .to),
            
              let rootVC   = (operation == .push ? fromVC : toVC) as? RootViewController,
              let detailVC = (operation == .push ? toVC : fromVC) as? DetailViewController,
            
              let indexPath = rootVC.lastSelectedIndexPath,
              let cell = rootVC.tableView.cellForRow(at: indexPath)
        else {
            return nil
        }
        
        if operation == .push {
            container.addSubview(toVC.view)
        } else {
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        
        toVC.view.layoutIfNeeded()
        
        guard let cellText = cell.textLabel,
              let detailSnapshot = detailVC.detailText.snapshotView(afterScreenUpdates: true)
        else {
            return nil

        }

        let titleClone = UILabel()
        titleClone.font = cellText.font
        titleClone.text = cellText.text
        
        container.addSubview(titleClone)
        container.addSubview(detailSnapshot)
        
        let titleEndFrame = detailVC.titleLabel.convert(detailVC.titleLabel.bounds, to: container)
        let detailEndFrame = detailVC.detailText.convert(detailVC.detailText.bounds, to: container)
        
        let titleStartFrame = cellText.convert(cellText.bounds, to: container)
        var detailStartFrame = detailEndFrame
        detailStartFrame.origin.y = titleStartFrame.maxY + 20
        
        titleClone.frame = titleStartFrame
        detailSnapshot.frame = detailStartFrame
        detailSnapshot.alpha = 0
        detailVC.view.alpha = 0
        
        DispatchQueue.main.async {
            cellText.isHidden = true
            detailVC.titleLabel.isHidden = true
            detailVC.detailText.isHidden = true
        }
        
        let dur = transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(duration: dur, curve: .easeInOut) {
            titleClone.frame = titleEndFrame
            detailSnapshot.frame = detailEndFrame
            detailSnapshot.alpha = 1.0
            detailVC.view.alpha = 1.0
        }
        
        animator.addCompletion { pos in
            cellText.isHidden = false
            detailVC.titleLabel.isHidden = false
            detailVC.detailText.isHidden = false
            
            titleClone.removeFromSuperview()
            detailSnapshot.removeFromSuperview()
            
            let completePos: UIViewAnimatingPosition = self.operation == .push ? .end : .start
            let didComplete = pos == completePos
            
            if transitionContext.transitionWasCancelled && !didComplete {
                toVC.view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(didComplete)
        }
        
        if operation == .pop {
            animator.fractionComplete = 1.0
            animator.isReversed = true
        }
        
        return animator
    }
}
