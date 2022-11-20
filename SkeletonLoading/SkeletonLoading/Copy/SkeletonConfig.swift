// Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

/// Used to store all config needed to activate the skeleton layer.
struct SkeletonConfig {
    
    /// Colors used in skeleton layer
    let colors: [UIColor]

    /// Used to execute a custom animation
    let animation: SkeletonLayerAnimation?
    
    ///  Transition style
    var transition: SkeletonTransitionStyle
    
    init(colors: [UIColor],
         animation: SkeletonLayerAnimation? = nil,
         transition: SkeletonTransitionStyle = .crossDissolve(0.25)) {
        self.colors = colors
        self.animation = animation
        self.transition = transition
    }
}
