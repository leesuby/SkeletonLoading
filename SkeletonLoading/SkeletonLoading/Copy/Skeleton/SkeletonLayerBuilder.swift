// Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

/// Object that facilitates the creation of skeleton layers,
/// based on the builder pattern
class SkeletonLayerBuilder {
    
    var colors: [UIColor] = []
    var holder: UIView?


    @discardableResult
    func addColor(_ color: UIColor) -> SkeletonLayerBuilder {
        addColors([color])
    }

    @discardableResult
    func addColors(_ colors: [UIColor]) -> SkeletonLayerBuilder {
        self.colors.append(contentsOf: colors)
        return self
    }

    @discardableResult
    func setHolder(_ holder: UIView) -> SkeletonLayerBuilder {
        self.holder = holder
        return self
	}
	
    @discardableResult
	func build() -> SkeletonLayer? {
		guard let holder = holder
			else { return nil }
		
		return SkeletonLayer(colors: colors,
							 skeletonHolder: holder)
	}
    
}
