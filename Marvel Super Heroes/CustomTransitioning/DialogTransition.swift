//
//  DialogTransition.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/23/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

class DialogTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: main protocol impl.
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DialogTransitionAnimator()
        animator.forDismiss = false
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DialogTransitionAnimator()
        animator.forDismiss = true
        return animator
    }
}



class DialogTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate struct AssociatedKeys {
        static var backgroundView = "bg_view"
    }
    
    // MARK: lets & vars
    
    fileprivate var forDismiss = false
    
    
    
    // MARK: main protocol impl.
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                return
        }
        let containerView = transitionContext.containerView
        
        let movingVc = (forDismiss ? fromVc : toVc)
        guard let dialogVc = movingVc as? PresentableAsDialog else {
            return
        }
        
        // calculate needed frames
        let startingFrame = forDismiss ? frameWhenVisibleForVc(dialogVc, inContainer: containerView) : frameWhenNotVisibleForVc(dialogVc, inContainer: containerView)
        let finalFrame = forDismiss ? frameWhenNotVisibleForVc(dialogVc, inContainer: containerView) : frameWhenVisibleForVc(dialogVc, inContainer: containerView)
        let finalAlpha = CGFloat(forDismiss ? 0.0 : 0.7)
        let duration = transitionDuration(using: transitionContext)
        
        // add background view on appearance or use existing one for dismiss
        var backgoundView: UIView!
        if forDismiss {
            backgoundView = objc_getAssociatedObject(containerView, &AssociatedKeys.backgroundView) as? UIView
        }
        else {
            backgoundView = createBackgroundViewAddedToContainer(containerView, tapHandler: dialogVc)
            movingVc.view.frame = startingFrame
            containerView.addSubview(toVc.view)
        }
        
        UIView.animate(withDuration: duration, animations: {
            movingVc.view.frame = finalFrame
            backgoundView.alpha = finalAlpha
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if self.forDismiss { self.removeBackgroundView(backgoundView, fromContainer: containerView) }
        })
        
    }
    
    
    
    // MARK: private
    
    fileprivate func frameWhenNotVisibleForVc(_ vc: PresentableAsDialog, inContainer containerView: UIView) -> CGRect {
        if UIDevice.current.isIPhone() {
            return CGRect(x: 0,
                          y: containerView.bounds.size.height,
                          width: containerView.bounds.size.width,
                          height: vc.dialogSize.height)
        }
        else {
            return CGRect(x: (containerView.bounds.size.width - vc.dialogSize.width) / 2.0,
                          y: containerView.bounds.size.height,
                          width: vc.dialogSize.width,
                          height: vc.dialogSize.height)
        }
    }
    
    fileprivate func frameWhenVisibleForVc(_ vc: PresentableAsDialog, inContainer containerView: UIView) -> CGRect {
        if UIDevice.current.isIPhone() {
            return CGRect(x: 0,
                          y: containerView.bounds.size.height - vc.dialogSize.height,
                          width: containerView.bounds.size.width,
                          height: vc.dialogSize.height)
        }
        else {
            return CGRect(x: (containerView.bounds.size.width - vc.dialogSize.width) / 2.0,
                          y: (containerView.bounds.size.height - vc.dialogSize.height) / 2.0,
                          width: vc.dialogSize.width,
                          height: vc.dialogSize.height)
        }
    }
    
    fileprivate func createBackgroundViewAddedToContainer(_ containerView: UIView, tapHandler: PresentableAsDialog) -> UIView {
        let view = UIView(frame: containerView.bounds)
        view.alpha = 0.0
        view.backgroundColor = UIColor.black
        let tapGr = UITapGestureRecognizer(target: tapHandler, action: #selector(PresentableAsDialog.dialogBackgroundTapped))
        view.addGestureRecognizer(tapGr)
        
        containerView.addSubview(view)
        objc_setAssociatedObject(containerView, &AssociatedKeys.backgroundView, view, .OBJC_ASSOCIATION_ASSIGN)
        
        return view
    }
    
    fileprivate func removeBackgroundView(_ view: UIView, fromContainer: UIView) {
        view.removeFromSuperview()
        objc_setAssociatedObject(fromContainer, &AssociatedKeys.backgroundView, nil, .OBJC_ASSOCIATION_ASSIGN)
    }
}
