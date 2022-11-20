// Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

/// Used to store all config needed to activate the skeleton layer.
struct SkeletonConfig {
    
    /// Colors used in skeleton layer
    let colors: [UIColor]
    
//    ///  Transition style
//    var transition: SkeletonTransitionStyle
    
    init(colors: [UIColor]) {
        self.colors = colors
//        self.transition = transition
    }
}
