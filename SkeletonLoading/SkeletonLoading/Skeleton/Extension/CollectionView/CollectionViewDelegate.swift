//
//  CollectionViewDelegate.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
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
