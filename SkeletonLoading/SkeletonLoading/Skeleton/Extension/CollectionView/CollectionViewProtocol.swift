//
//  CollectionViewProtocol.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

public protocol SkeletonCollectionViewDataSource: UICollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell?
}

public extension SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        nil
    }
}

public protocol SkeletonCollectionViewDelegate: UICollectionViewDelegate { }

