//
//  AnimationCreator.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit
public typealias SkeletonLayerAnimation = (CALayer) -> CAAnimation

public class AnimationCreator {
    
    public init() { }
    
    public func makeSlidingAnimation(duration: CFTimeInterval = 1.5, autoreverses: Bool = false) -> SkeletonLayerAnimation {
        { _ in
            let startPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
            startPointAnim.fromValue = CGPoint(x: -1, y: 0.5)
            startPointAnim.toValue = CGPoint(x: 1, y: 0.5)
            
            let endPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
            endPointAnim.fromValue = CGPoint(x: 0, y: 0.5)
            endPointAnim.toValue = CGPoint(x: 2, y: 0.5)
            
            let animGroup = CAAnimationGroup()
            animGroup.animations = [startPointAnim, endPointAnim]
            animGroup.duration = duration
            animGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            animGroup.repeatCount = .infinity
            animGroup.autoreverses = autoreverses
            animGroup.isRemovedOnCompletion = false
            
            return animGroup
        }
    }
}
