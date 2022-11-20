//
//  SkeletonLoading.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

public extension UIView {
    /// Shows the gradient skeleton without animation using the view that calls this method as root view.
    ///
    /// If animation is nil, sliding animation will be used, with direction left to right.
    ///
    /// - Parameters:
    ///   - gradient: The gradient of the skeleton. Defaults to `SkeletonAppearance.default.gradient`.
    ///   - animation: The animation of the skeleton. Defaults to `nil`.
    ///   - transition: The style of the transition when the skeleton appears. Defaults to `.crossDissolve(0.25)`.
    func showAnimatedGradientSkeleton(usingGradient gradient: SkeletonGradient = SkeletonAppearance.default.gradient) {
        _delayedShowSkeletonWorkItem?.cancel()
        let config = SkeletonConfig(colors: gradient.colors)
        showSkeleton(skeletonConfig: config)
    }

    func updateAnimatedGradientSkeleton(usingGradient gradient: SkeletonGradient = SkeletonAppearance.default.gradient) {
        let config = SkeletonConfig(colors: gradient.colors)
        updateSkeleton(skeletonConfig: config)
    }

    func layoutSkeletonIfNeeded() {
        recursiveLayoutSkeletonIfNeeded(root: self)
    }
    
    func hideSkeleton(reloadDataAfter reload: Bool = true) {
        _delayedShowSkeletonWorkItem?.cancel()
        recursiveHideSkeleton(reloadDataAfter: reload, root: self)
    }
    
    func startSkeletonAnimation(_ anim: SkeletonLayerAnimation? = nil) {
        subviewsSkeletonables.recursiveSearch(leafBlock: startSkeletonLayerAnimationBlock(anim)) { subview in
            subview.startSkeletonAnimation(anim)
        }
    }
}
