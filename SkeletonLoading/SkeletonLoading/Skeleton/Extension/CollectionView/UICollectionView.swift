//
//  UICollectionView.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit


//MARK: Using for collectionView
extension UIView {
    
    func addDummyDataSourceIfNeeded() {
        guard let collection = self as? CollectionSkeleton else { return }
        _status = .on
        collection.addDummyDataSource()
        collection.disableUserInteraction()
    }
    
    func updateDummyDataSourceIfNeeded() {
        guard let collection = self as? CollectionSkeleton else { return }
        collection.updateDummyDataSource()
    }
    
    func removeDummyDataSourceIfNeeded(reloadAfter reload: Bool = true) {
        guard let collection = self as? CollectionSkeleton else { return }
        _status = .off
        collection.removeDummyDataSource(reloadAfter: reload)
        collection.enableUserInteraction()
    }
    
}


public extension UICollectionView {
    
    static let automaticNumberOfSkeletonItems = -1
    
    func prepareSkeleton(completion: @escaping (Bool) -> Void) {
        guard let originalDataSource = self.dataSource as? SkeletonCollectionViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        
        let dataSource = SkeletonCollectionDataSource(collectionViewDataSource: originalDataSource, rowHeight: 0.0)
        self.skeletonDataSource = dataSource
        performBatchUpdates({
            self.reloadData()
        }) { done in
            completion(done)
            
        }
    }
}


enum CollectionAssociatedKeys {
    static var dummyDataSource = "dummyDataSource"
    static var dummyDelegate = "dummyDelegate"
}

protocol CollectionSkeleton {
    
    var skeletonDataSource: SkeletonCollectionDataSource? { get set }
    var skeletonDelegate: SkeletonCollectionDelegate? { get set }
    var estimatedNumberOfRows: Int { get }
    
    func addDummyDataSource()
    func updateDummyDataSource()
    func removeDummyDataSource(reloadAfter: Bool)
    func disableUserInteraction()
    func enableUserInteraction()
    
}

extension CollectionSkeleton where Self: UIScrollView {
    
    var estimatedNumberOfRows: Int { return 0 }
    func addDummyDataSource() {}
    func removeDummyDataSource(reloadAfter: Bool) {}

    func disableUserInteraction() {
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = false
            isScrollEnabled = false
        }
    }
    
    func enableUserInteraction() {
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = true
            isScrollEnabled = true
        }
    }
    
}

extension UICollectionView: CollectionSkeleton {

    var skeletonDataSource: SkeletonCollectionDataSource? {
        get { return ao_get(pkey: &CollectionAssociatedKeys.dummyDataSource) as? SkeletonCollectionDataSource }
        set {
            ao_setOptional(newValue, pkey: &CollectionAssociatedKeys.dummyDataSource)
            self.dataSource = newValue
        }
    }
    
    var skeletonDelegate: SkeletonCollectionDelegate? {
        get { return ao_get(pkey: &CollectionAssociatedKeys.dummyDelegate) as? SkeletonCollectionDelegate }
        set {
            ao_setOptional(newValue, pkey: &CollectionAssociatedKeys.dummyDelegate)
            self.delegate = newValue
        }
    }
    
    func addDummyDataSource() {
        guard let originalDataSource = self.dataSource as? SkeletonCollectionViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        
        let dataSource = SkeletonCollectionDataSource(collectionViewDataSource: originalDataSource)
        self.skeletonDataSource = dataSource
        reloadData()
    }
    
    func updateDummyDataSource() {
        if (dataSource as? SkeletonCollectionDataSource) != nil {
            reloadData()
        } else {
            addDummyDataSource()
        }
    }
    
    func removeDummyDataSource(reloadAfter: Bool) {
        guard let dataSource = self.dataSource as? SkeletonCollectionDataSource else { return }
        self.skeletonDataSource = nil
        self.dataSource = dataSource.originalCollectionViewDataSource
        if reloadAfter { self.reloadData() }
    }
    
}
