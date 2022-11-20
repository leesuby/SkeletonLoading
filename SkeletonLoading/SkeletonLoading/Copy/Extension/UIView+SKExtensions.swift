//
//  Copyright SkeletonView. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  UIView+SKExtensions.swift
//
//  Created by Juanpe Catalán on 18/8/21.

import UIKit

public extension SkeletonViewExtension where ExtendedType: UIView {
    
    /// Returns a string that describes the hierarchy of the skeleton, indicating
    /// whether the receiver is skeletonable and all skeletonable children.
    var isSkeletonActive: Bool {
        type._status == .on || type.subviewsSkeletonables.contains(where: { $0.sk.isSkeletonActive })
    }
    
}
