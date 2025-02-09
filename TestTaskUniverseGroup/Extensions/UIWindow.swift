//
//  UIWindow.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

extension UIWindow {
    
    func setRootViewController(_ newRootViewController: UIViewController,
                               duration: TimeInterval = 0.7,
                               completion: (() -> Void)? = nil) {
        guard let snapshot = self.snapshotView(afterScreenUpdates: true) else {
            self.rootViewController = newRootViewController
            self.makeKeyAndVisible()
            completion?()
            return
        }
        self.rootViewController = newRootViewController
        self.makeKeyAndVisible()
        
        newRootViewController.view.addSubview(snapshot)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = snapshot.bounds
        maskLayer.fillRule = .evenOdd
        
        snapshot.layer.mask = maskLayer
        
        // from
        let initialRadius = 1.0
        let initialCircleRect = CGRect(x: snapshot.bounds.midX - initialRadius,
                                       y: snapshot.bounds.midY - initialRadius,
                                       width: initialRadius * 2,
                                       height: initialRadius * 2)
        let initialPath = UIBezierPath(rect: snapshot.bounds)
        initialPath.append(UIBezierPath(ovalIn: initialCircleRect))
        
        // to
        let finalRadius = max(snapshot.bounds.width, snapshot.bounds.height)
        let finalCircleRect = CGRect(x: snapshot.bounds.midX - finalRadius,
                                     y: snapshot.bounds.midY - finalRadius,
                                     width: finalRadius * 2,
                                     height: finalRadius * 2)
        let finalPath = UIBezierPath(rect: snapshot.bounds)
        finalPath.append(UIBezierPath(ovalIn: finalCircleRect))
        
        // animation
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock {
            snapshot.removeFromSuperview()
            completion?()
        }
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = initialPath.cgPath
        pathAnimation.toValue = finalPath.cgPath
        pathAnimation.timingFunction = .init(name: .easeIn)
        maskLayer.add(pathAnimation, forKey: "pathAnimation")
        
        CATransaction.commit()
    }
}

