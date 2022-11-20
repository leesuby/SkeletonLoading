//
//  SkeletonCollectionDelegate.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 30/03/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

class SkeletonCollectionDelegate: NSObject {
    
    weak var originalCollectionViewDelegate: SkeletonCollectionViewDelegate?
    
    init(
        collectionViewDelegate: SkeletonCollectionViewDelegate? = nil
    ) {
        self.originalCollectionViewDelegate = collectionViewDelegate
    }
    
}

// MARK: - UICollectionViewDelegate
extension SkeletonCollectionDelegate: UICollectionViewDelegate { }

private extension SkeletonCollectionDelegate {
    
    func skeletonizeViewIfContainerSkeletonIsActive(container: UIView, view: UIView) {
        guard container.sk.isSkeletonActive,
              let skeletonConfig = container._currentSkeletonConfig
        else {
            return
        }

        view.showSkeleton(
            skeletonConfig: skeletonConfig,
            notifyDelegate: false
        )
    }
}
