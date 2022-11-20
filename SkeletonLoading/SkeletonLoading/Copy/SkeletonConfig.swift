// Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

/// Used to store all config needed to activate the skeleton layer.
struct SkeletonConfig {
    
    /// Colors used in skeleton layer
    let colors: [UIColor]
    
    ///  Transition style
    var transition: SkeletonTransitionStyle
    
    init(colors: [UIColor],
         transition: SkeletonTransitionStyle = .crossDissolve(0.25)) {
        self.colors = colors
        self.transition = transition
    }
}
