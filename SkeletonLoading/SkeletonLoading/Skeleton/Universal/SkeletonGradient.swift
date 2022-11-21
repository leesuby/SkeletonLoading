//
//  SkeletonGradient.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

public struct SkeletonGradient {
    
    private let gradientColors: [UIColor]
    
    public var colors: [UIColor] {
        return gradientColors
    }
    
    public init(baseColor: UIColor, secondaryColor: UIColor? = nil) {
        if let secondary = secondaryColor {
            self.gradientColors = [baseColor, secondary, baseColor]
        } else {
            self.gradientColors = baseColor.makeGradient()
        }
    }
    
    public init(colors: [UIColor]) {
        self.gradientColors = colors
    }
    
}

