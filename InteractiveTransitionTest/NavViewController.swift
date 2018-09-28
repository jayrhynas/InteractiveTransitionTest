//
//  NavViewController.swift
//  InteractiveTransitionTest
//
//  Created by Jayson Rhynas on 2018-09-28.
//  Copyright © 2018 Jayson Rhynas. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController, UINavigationControllerDelegate {

    private lazy var edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanned(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    @objc private func edgePanned(_ pan: UIScreenEdgePanGestureRecognizer) {
        guard let view = pan.view else { return }
        
        let percentComplete = pan.translation(in: view).x / view.bounds.width
        
        switch pan.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
            
        case .changed:
            interactionController?.update(percentComplete)
            
        case .ended, .cancelled:
            if percentComplete > 0.5 && pan.state != .cancelled {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
            
        default:
            break
        }
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DetailTransitionController(operation: operation)
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

