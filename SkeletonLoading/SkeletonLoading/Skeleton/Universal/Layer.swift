//
//  Layer.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

struct SkeletonMultilinesLayerConfig {
    
    var lines: Int
    var lineHeight: CGFloat
    var lastLineFillPercent: Int
    var multilineCornerRadius: Int
    var multilineSpacing: CGFloat
    var paddingInsets: UIEdgeInsets
    var alignment: NSTextAlignment
    var shouldCenterVertically: Bool

    var calculatedPaddingInsets: UIEdgeInsets {
        UIEdgeInsets(top: paddingInsets.top,
                     left: paddingInsets.left,
                     bottom: paddingInsets.bottom,
                     right: paddingInsets.right)
    }
    
}

class SkeletonMultilineLayerBuilder {
    
    var index: Int?
    var height: CGFloat?
    var width: CGFloat?
    var cornerRadius: Int?
    var multilineSpacing: CGFloat = SkeletonAppearance.default.multilineSpacing
    var paddingInsets: UIEdgeInsets = .zero
    var alignment: NSTextAlignment = .natural


    @discardableResult
    func setIndex(_ index: Int) -> SkeletonMultilineLayerBuilder {
        self.index = index
        return self
    }
    
    @discardableResult
    func setHeight(_ height: CGFloat) -> SkeletonMultilineLayerBuilder {
        self.height = height
        return self
    }
    
    @discardableResult
    func setWidth(_ width: CGFloat) -> SkeletonMultilineLayerBuilder {
        self.width = width
        return self
    }

    @discardableResult
    func setCornerRadius(_ radius: Int) -> SkeletonMultilineLayerBuilder {
        self.cornerRadius = radius
        return self
    }

    @discardableResult
    func setMultilineSpacing(_ spacing: CGFloat) -> SkeletonMultilineLayerBuilder {
        self.multilineSpacing = spacing
        return self
    }

    @discardableResult
    func setPadding(_ insets: UIEdgeInsets) -> SkeletonMultilineLayerBuilder {
        self.paddingInsets = insets
        return self
    }

    @discardableResult
    func setAlignment(_ alignment: NSTextAlignment) -> SkeletonMultilineLayerBuilder {
        self.alignment = alignment
        return self
    }
    
    func build() -> CALayer? {
        guard let index = index,
              let width = width,
              let height = height,
              let radius = cornerRadius
            else { return nil }

        let layer = CAGradientLayer()
        layer.anchorPoint = .zero
        layer.name = CALayer.Constants.skeletonSubLayersName
        layer.updateLayerFrame(for: index,
                               totalLines: layer.skeletonSublayers.count,
                               size: CGSize(width: width, height: height),
                               multilineSpacing: multilineSpacing,
                               paddingInsets: paddingInsets,
                               alignment: alignment)

        layer.cornerRadius = CGFloat(radius)
        layer.masksToBounds = true

        return layer
    }
    
}

struct SkeletonLayer {
    
    private var maskLayer: CALayer
    private weak var holder: UIView?
    
    var contentLayer: CALayer {
        return maskLayer
    }
    
    init(colors: [UIColor], skeletonHolder holder: UIView) {
        self.holder = holder
        self.maskLayer = CAGradientLayer()
        self.maskLayer.anchorPoint = .zero
        self.maskLayer.bounds = holder.definedMaxBounds
        self.maskLayer.cornerRadius = CGFloat(holder.skeletonCornerRadius)
        addTextLinesIfNeeded()
        self.maskLayer.tint(withColors: colors, traitCollection: holder.traitCollection)
    }
    
    func update(usingColors colors: [UIColor]) {
        layoutIfNeeded()
        maskLayer.tint(withColors: colors, traitCollection: holder?.traitCollection)
    }

    func layoutIfNeeded() {
        if let bounds = holder?.definedMaxBounds {
            maskLayer.bounds = bounds
        }
        updateLinesIfNeeded()
    }
    
    func removeLayer(completion: (() -> Void)? = nil) {
        maskLayer.setOpacity(from: 1, to: 0, duration: 0.25) {
            self.maskLayer.removeFromSuperlayer()
            completion?()
        }
    }

    /// If there is more than one line, or custom preferences have been set for a single line, draw custom layers
    func addTextLinesIfNeeded() {
        guard let textView = holderAsTextView else { return }
        let config = SkeletonMultilinesLayerConfig(lines: textView.estimatedNumberOfLines,
                                                   lineHeight: textView.estimatedLineHeight,
                                                   lastLineFillPercent: textView.lastLineFillingPercent,
                                                   multilineCornerRadius: textView.multilineCornerRadius,
                                                   multilineSpacing: textView.multilineSpacing,
                                                   paddingInsets: textView.paddingInsets,
                                                   alignment: textView.textAlignment,
                                                   shouldCenterVertically: textView.shouldCenterTextVertically)

        maskLayer.addMultilinesLayers(for: config)
    }
    
    func updateLinesIfNeeded() {
        guard let textView = holderAsTextView else { return }
        let config = SkeletonMultilinesLayerConfig(lines: textView.estimatedNumberOfLines,
                                                   lineHeight: textView.estimatedLineHeight,
                                                   lastLineFillPercent: textView.lastLineFillingPercent,
                                                   multilineCornerRadius: textView.multilineCornerRadius,
                                                   multilineSpacing: textView.multilineSpacing,
                                                   paddingInsets: textView.paddingInsets,
                                                   alignment: textView.textAlignment,
                                                   shouldCenterVertically: textView.shouldCenterTextVertically)
        
        maskLayer.updateMultilinesLayers(for: config)
    }
    
    var holderAsTextView: SkeletonTextNode? {
        guard let textView = holder as? SkeletonTextNode,
            (textView.estimatedNumberOfLines == -1 || textView.estimatedNumberOfLines == 0 || textView.estimatedNumberOfLines > 1 || textView.estimatedNumberOfLines == 1 && !SkeletonAppearance.default.renderSingleLineAsView) else {
                return nil
        }
        return textView
    }
    
}

extension SkeletonLayer {
    
    func start(_ anim: SkeletonLayerAnimation? = nil, completion: (() -> Void)? = nil) {
        contentLayer.playAnimation(AnimationCreator().makeSlidingAnimation(), key: "skeletonAnimation", completion: completion)
    }

    func stopAnimation() {
        contentLayer.stopAnimation(forKey: "skeletonAnimation")
    }
    
}

class SkeletonLayerBuilder {
    
    var colors: [UIColor] = []
    var holder: UIView?


    @discardableResult
    func addColor(_ color: UIColor) -> SkeletonLayerBuilder {
        addColors([color])
    }

    @discardableResult
    func addColors(_ colors: [UIColor]) -> SkeletonLayerBuilder {
        self.colors.append(contentsOf: colors)
        return self
    }

    @discardableResult
    func setHolder(_ holder: UIView) -> SkeletonLayerBuilder {
        self.holder = holder
        return self
    }
    
    @discardableResult
    func build() -> SkeletonLayer? {
        guard let holder = holder
            else { return nil }
        
        return SkeletonLayer(colors: colors,
                             skeletonHolder: holder)
    }
    
}


