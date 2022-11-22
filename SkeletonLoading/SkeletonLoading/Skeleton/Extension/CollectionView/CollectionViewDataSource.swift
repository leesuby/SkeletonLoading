//
//  CollectionViewDataSource.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

public typealias ReusableCellIdentifier = String

class SkeletonCollectionDataSource: NSObject {
    weak var originalCollectionViewDataSource: SkeletonCollectionViewDataSource?
    var rowHeight: CGFloat = 0.0
    var originalRowHeight: CGFloat = 0.0
    
    convenience init( collectionViewDataSource: SkeletonCollectionViewDataSource? = nil, rowHeight: CGFloat = 0.0, originalRowHeight: CGFloat = 0.0) {
        self.init()
        self.originalCollectionViewDataSource = collectionViewDataSource
        self.rowHeight = rowHeight
        self.originalRowHeight = originalRowHeight
    }
}

// MARK: - UICollectionViewDataSource
extension SkeletonCollectionDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        originalCollectionViewDataSource?.numSections(in: collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let originalCollectionViewDataSource = originalCollectionViewDataSource else {
            return 0
        }

        let numberOfItems = originalCollectionViewDataSource.collectionSkeletonView(collectionView, numberOfItemsInSection: section)

        if numberOfItems == UICollectionView.automaticNumberOfSkeletonItems {
            return collectionView.estimatedNumberOfRows
        } else {
            return numberOfItems
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = originalCollectionViewDataSource?.collectionSkeletonView(collectionView, skeletonCellForItemAt: indexPath) else {
            let cellIdentifier = originalCollectionViewDataSource?.collectionSkeletonView(collectionView, cellIdentifierForItemAt: indexPath) ?? ""
            let fakeCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            fakeCell.isSkeletonable = true
            
            skeletonizeViewIfContainerSkeletonIsActive(container: collectionView, view: fakeCell)
            return fakeCell
        }

        skeletonizeViewIfContainerSkeletonIsActive(container: collectionView, view: cell)
        return cell
    }
    
}

extension SkeletonCollectionDataSource {
    private func skeletonizeViewIfContainerSkeletonIsActive(container: UIView, view: UIView) {
        guard container.sk.isSkeletonActive,
              let skeletonConfig = container._currentSkeletonConfig else {
            return
        }

        view.showSkeleton(
            skeletonConfig: skeletonConfig
        )
    }
}
