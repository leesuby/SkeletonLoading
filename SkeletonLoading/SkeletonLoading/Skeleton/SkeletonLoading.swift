//
//  SkeletonLoading.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

public extension UIView {
    func showSkeleton(usingGradient gradient: SkeletonGradient = SkeletonAppearance.default.gradient) {
        _delayedShowSkeletonWorkItem?.cancel()
        let config = SkeletonConfig(colors: gradient.colors)
        showSkeleton(skeletonConfig: config)
    }

    func updateSkeleton(usingGradient gradient: SkeletonGradient = SkeletonAppearance.default.gradient) {
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
