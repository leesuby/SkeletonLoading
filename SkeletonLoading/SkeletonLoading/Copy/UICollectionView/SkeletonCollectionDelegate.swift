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
    
    func headerOrFooterView(_ tableView: UITableView, for viewIdentifier: String? ) -> UIView? {
        guard let viewIdentifier = viewIdentifier,
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewIdentifier)
        else {
            return nil
        }
        
        skeletonizeViewIfContainerSkeletonIsActive(
            container: tableView,
            view: header
        )
        
        return header
    }
    
}
