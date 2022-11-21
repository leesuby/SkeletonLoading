//
//  Appearance.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit
public enum SkeletonAppearance {
    public static var `default` = SkeletonViewAppearance.shared
}

public class SkeletonViewAppearance {
    
    static var shared = SkeletonViewAppearance()

    public var tintColor: UIColor = .skeletonDefault

    public var gradient = SkeletonGradient(baseColor: .skeletonDefault)

    public var multilineHeight: CGFloat = 15
    
    public lazy var textLineHeight: SkeletonTextLineHeight = .fixed(multilineHeight)
    
    public var multilineSpacing: CGFloat = 10

    public var multilineLastLineFillPercent: Int = 70

    public var multilineCornerRadius: Int = 0

    public var renderSingleLineAsView: Bool = false
    
    public var skeletonCornerRadius: Float = 0

}
