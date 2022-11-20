//
//  Copyright SkeletonView. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  UIView+SkeletonView.swift
//
//  Created by Juanpe Catalán on 19/8/21.

import UIKit

extension UIView: SkeletonViewExtended { }

extension UIView {
    
    func showSkeleton(
        skeletonConfig config: SkeletonConfig,
        notifyDelegate: Bool = true
    ) {
        recursiveShowSkeleton(skeletonConfig: config, root: self)
    }

    func updateSkeleton(
        skeletonConfig config: SkeletonConfig,
        notifyDelegate: Bool = true
    ) {
        recursiveUpdateSkeleton(skeletonConfig: config, root: self)
    }

    func recursiveLayoutSkeletonIfNeeded(root: UIView? = nil) {
        subviewsSkeletonables.recursiveSearch(leafBlock: {
            guard isSkeletonable, sk.isSkeletonActive else { return }
            layoutSkeletonLayerIfNeeded()
            startSkeletonAnimation()
        }) { subview in
            subview.recursiveLayoutSkeletonIfNeeded()
        }
    }

    func recursiveHideSkeleton(reloadDataAfter reload: Bool, root: UIView? = nil) {
        guard sk.isSkeletonActive else { return }
        if isHiddenWhenSkeletonIsActive {
            isHidden = false
        }
       
        unSwizzleLayoutSubviews()
        unSwizzleTraitCollectionDidChange()
        removeDummyDataSourceIfNeeded(reloadAfter: reload)
        subviewsSkeletonables.recursiveSearch(leafBlock: {
            recoverViewState(forced: false)
            removeSkeletonLayer()
        }) { subview in
            subview.recursiveHideSkeleton(reloadDataAfter: reload)
        }
    }
    
}

private extension UIView {
    
    func showSkeletonIfNotActive(skeletonConfig config: SkeletonConfig) {
        guard !sk.isSkeletonActive else { return }
        saveViewState()

        prepareViewForSkeleton()
        addSkeletonLayer(skeletonConfig: config)
    }
    
    func recursiveShowSkeleton(skeletonConfig config: SkeletonConfig, root: UIView? = nil) {
        if isHiddenWhenSkeletonIsActive {
            isHidden = true
        }
        guard isSkeletonable && !sk.isSkeletonActive else { return }
        _currentSkeletonConfig = config
        swizzleLayoutSubviews()
        swizzleTraitCollectionDidChange()
        addDummyDataSourceIfNeeded()
        subviewsSkeletonables.recursiveSearch(leafBlock: {
            showSkeletonIfNotActive(skeletonConfig: config)
        }) { subview in
            subview.recursiveShowSkeleton(skeletonConfig: config)
        }
    }
    
    func recursiveUpdateSkeleton(skeletonConfig config: SkeletonConfig, root: UIView? = nil) {
        guard sk.isSkeletonActive else { return }
        _currentSkeletonConfig = config
        updateDummyDataSourceIfNeeded()
        subviewsSkeletonables.recursiveSearch(leafBlock: {
            if _skeletonLayer != nil{
                removeSkeletonLayer()
                addSkeletonLayer(skeletonConfig: config)
            } else {
                updateSkeletonLayer(skeletonConfig: config)
            }
        }) { subview in
            subview.recursiveUpdateSkeleton(skeletonConfig: config)
        }
    }
    
}


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


