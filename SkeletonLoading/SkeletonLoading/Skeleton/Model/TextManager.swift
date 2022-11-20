//
//  TextManager.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

public enum SkeletonTextLineHeight: Equatable {
    
    /// Calculates the line height based on the font line height.
    case relativeToFont
    
    /// Calculates the line height based on the height constraints.
    ///
    /// If no constraints exist, the height will be set to the `multilineHeight`
    /// value defined in the `SkeletonAppearance`.
    case relativeToConstraints
    
    /// Returns the specific height specified as the associated value.
    case fixed(CGFloat)
    
}

public enum SkeletonTextNumberOfLines: Equatable, ExpressibleByIntegerLiteral {
    
    /// Returns `numberOfLines` value.
    case inherited
    
    /// Returns the specific number of lines specified as the associated value.
    case custom(Int)
    
}

public extension SkeletonTextNumberOfLines {
    
    init(integerLiteral value: Int) {
        self = .custom(value)
    }
    
}

protocol SkeletonTextNode {
    
    var textLineHeight: SkeletonTextLineHeight { get }
    var estimatedLineHeight: CGFloat { get }
    var estimatedNumberOfLines: Int { get }
    var textAlignment: NSTextAlignment { get }
    var lastLineFillingPercent: Int { get }
    var multilineCornerRadius: Int { get }
    var multilineSpacing: CGFloat { get }
    var paddingInsets: UIEdgeInsets { get }
    var shouldCenterTextVertically: Bool { get }
    
}

enum SkeletonTextNodeAssociatedKeys {
    
    static var lastLineFillingPercent = "lastLineFillingPercent"
    static var multilineCornerRadius = "multilineCornerRadius"
    static var multilineSpacing = "multilineSpacing"
    static var paddingInsets = "paddingInsets"
    static var backupHeightConstraints = "backupHeightConstraints"
    static var textLineHeight = "textLineHeight"
    static var skeletonNumberOfLines = "skeletonNumberOfLines"
    
}

extension UILabel: SkeletonTextNode {
    
    var estimatedLineHeight: CGFloat {
        switch textLineHeight {
        case .fixed(let height):
            return height
        case .relativeToFont:
            return fontLineHeight ?? SkeletonAppearance.default.multilineHeight
        case .relativeToConstraints:
            guard let constraintsLineHeight = heightConstraints.first?.constant,
                  estimatedNumberOfLines != 0 else {
                return SkeletonAppearance.default.multilineHeight
            }
            
            return constraintsLineHeight / CGFloat(estimatedNumberOfLines)
        }
    }
    
    var textLineHeight: SkeletonTextLineHeight {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.textLineHeight) as? SkeletonTextLineHeight ?? SkeletonAppearance.default.textLineHeight }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.textLineHeight) }
    }
    
    var skeletonNumberOfLines: SkeletonTextNumberOfLines {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.skeletonNumberOfLines) as? SkeletonTextNumberOfLines ?? SkeletonTextNumberOfLines.inherited }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.skeletonNumberOfLines) }
    }
    
    var estimatedNumberOfLines: Int {
        switch skeletonNumberOfLines {
        case .inherited:
            return numberOfLines
        case .custom(let lines):
            return lines >= 0 ? lines : 1
        }
    }
    
    var lastLineFillingPercent: Int {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.lastLineFillingPercent) as? Int ?? SkeletonAppearance.default.multilineLastLineFillPercent }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.lastLineFillingPercent) }
    }

    var multilineCornerRadius: Int {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.multilineCornerRadius) as? Int ?? SkeletonAppearance.default.multilineCornerRadius }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.multilineCornerRadius) }
    }

    var multilineSpacing: CGFloat {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.multilineSpacing) as? CGFloat ?? SkeletonAppearance.default.multilineSpacing }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.multilineSpacing) }
    }

    var paddingInsets: UIEdgeInsets {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.paddingInsets) as? UIEdgeInsets ?? .zero }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.paddingInsets) }
    }
    
    var backupHeightConstraints: [NSLayoutConstraint] {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.backupHeightConstraints) as? [NSLayoutConstraint] ?? [] }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.backupHeightConstraints) }
    }
    
    var shouldCenterTextVertically: Bool {
        true
    }
    
    var fontLineHeight: CGFloat? {
        if let attributedText = attributedText,
           attributedText.length > 0 {
            let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
            let fontAttribute = attributes.first(where: { $0.key == .font })
            return fontAttribute?.value as? CGFloat ?? font.lineHeight
        } else {
            return font.lineHeight
        }
    }

}

extension UITextView: SkeletonTextNode {
    
    var estimatedLineHeight: CGFloat {
        switch textLineHeight {
        case .fixed(let height):
            return height
        case .relativeToFont:
            return fontLineHeight ?? SkeletonAppearance.default.multilineHeight
        case .relativeToConstraints:
            return SkeletonAppearance.default.multilineHeight
        }
    }
    
    var textLineHeight: SkeletonTextLineHeight {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.textLineHeight) as? SkeletonTextLineHeight ?? SkeletonAppearance.default.textLineHeight }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.textLineHeight) }
    }
    
    var skeletonNumberOfLines: SkeletonTextNumberOfLines {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.skeletonNumberOfLines) as? SkeletonTextNumberOfLines ?? SkeletonTextNumberOfLines.inherited }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.skeletonNumberOfLines) }
    }
    
    var estimatedNumberOfLines: Int {
        switch skeletonNumberOfLines {
        case .inherited:
            return -1
        case .custom(let lines):
            return lines >= -1 ? lines : 1
        }
    }
    
    var lastLineFillingPercent: Int {
        get {
            let defaultValue = SkeletonAppearance.default.multilineLastLineFillPercent
            return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.lastLineFillingPercent) as? Int ?? defaultValue
        }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.lastLineFillingPercent) }
    }

    var multilineCornerRadius: Int {
        get {
            let defaultValue = SkeletonAppearance.default.multilineCornerRadius
            return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.multilineCornerRadius) as? Int ?? defaultValue
        }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.multilineCornerRadius) }
    }

    var multilineSpacing: CGFloat {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.multilineSpacing) as? CGFloat ?? SkeletonAppearance.default.multilineSpacing }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.multilineSpacing) }
    }

    var paddingInsets: UIEdgeInsets {
        get { return ao_get(pkey: &SkeletonTextNodeAssociatedKeys.paddingInsets) as? UIEdgeInsets ?? .zero }
        set { ao_set(newValue, pkey: &SkeletonTextNodeAssociatedKeys.paddingInsets) }
    }
    
    var shouldCenterTextVertically: Bool {
        false
    }
    
    var fontLineHeight: CGFloat? {
        if let attributedText = attributedText,
           attributedText.length > 0 {
            let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
            let fontAttribute = attributes.first(where: { $0.key == .font })
            return fontAttribute?.value as? CGFloat ?? font?.lineHeight
        } else {
            return font?.lineHeight
        }
    }
    
}


