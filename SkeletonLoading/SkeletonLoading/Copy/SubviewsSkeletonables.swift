//  Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

extension UIView {
    
    @objc var subviewsSkeletonables: [UIView] {
        subviewsToSkeleton.filter { $0.isSkeletonable }
    }

    @objc var subviewsToSkeleton: [UIView] {
        subviews
    }
    
}

extension UICollectionView {
    override var subviewsToSkeleton: [UIView] {
        subviews
    }
}

extension UICollectionViewCell {
    override var subviewsToSkeleton: [UIView] {
        contentView.subviews
    }
}

