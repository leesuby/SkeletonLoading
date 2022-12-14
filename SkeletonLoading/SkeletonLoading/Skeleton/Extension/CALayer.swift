//
//  CALayer.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    override func tint(withColors colors: [UIColor], traitCollection: UITraitCollection?) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            if #available(iOS 13.0, tvOS 13, *), let traitCollection = traitCollection {
                self.colors = colors.map { $0.resolvedColor(with: traitCollection).cgColor }
            } else {
                self.colors = colors.map { $0.cgColor }
            }
        }) {
            $0.tint(withColors: colors, traitCollection: traitCollection)
        }
    }
    
}

extension CALayer {
    
    enum Constants {
        static let skeletonSubLayersName = "SkeletonSubLayersName"
    }
    
    var skeletonSublayers: [CALayer] {
        return sublayers?.filter { $0.name == Constants.skeletonSubLayersName } ?? [CALayer]()
    }
    
    @objc func tint(withColors colors: [UIColor], traitCollection: UITraitCollection?) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            if #available(iOS 13.0, tvOS 13, *), let traitCollection = traitCollection {
                backgroundColor = colors.first?.resolvedColor(with: traitCollection).cgColor
            } else {
                backgroundColor = colors.first?.cgColor
            }
        }) {
            $0.tint(withColors: colors, traitCollection: traitCollection)
        }
    }
    
    func playAnimation(_ anim: SkeletonLayerAnimation, key: String, completion: (() -> Void)? = nil) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            DispatchQueue.main.async { CATransaction.begin() }
            DispatchQueue.main.async { CATransaction.setCompletionBlock(completion) }
            add(anim(self), forKey: key)
            DispatchQueue.main.async { CATransaction.commit() }
        }) {
            $0.playAnimation(anim, key: key, completion: completion)
        }
    }
    
    func stopAnimation(forKey key: String) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            removeAnimation(forKey: key)
        }) {
            $0.stopAnimation(forKey: key)
        }
    }
    
    func setOpacity(from: Int, to: Int, duration: TimeInterval, completion: (() -> Void)?) {
        DispatchQueue.main.async { CATransaction.begin() }
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        DispatchQueue.main.async { CATransaction.setCompletionBlock(completion) }
        add(animation, forKey: "setOpacityAnimation")
        DispatchQueue.main.async { CATransaction.commit() }
    }
    
    func insertSkeletonLayer(_ sublayer: SkeletonLayer, atIndex index: UInt32, completion: (() -> Void)? = nil) {
        insertSublayer(sublayer.contentLayer, at: index)
        sublayer.contentLayer.setOpacity(from: 0, to: 1, duration: 0.25, completion: completion)
    }
    
}

private extension CALayer {
    
    func alignLayerFrame(_ rect: CGRect, paddingInsets: UIEdgeInsets, alignment: NSTextAlignment) -> CGRect {
        var newRect = rect
        let superlayerWidth = (superlayer?.bounds.width ?? 0)

        switch alignment {
        case .right:
            newRect.origin.x = superlayerWidth - rect.width - paddingInsets.right
        case .center:
            newRect.origin.x = (superlayerWidth + paddingInsets.left - paddingInsets.right - rect.width) / 2
        case .natural, .left, .justified:
            break
        @unknown default:
            break
        }

        return newRect
    }
    
    func calculatedWidthForLine(at index: Int, totalLines: Int, lastLineFillPercent: Int, paddingInsets: UIEdgeInsets) -> CGFloat {
        var width = bounds.width - paddingInsets.left - paddingInsets.right
        if index == totalLines - 1 {
            width = width * CGFloat(lastLineFillPercent) / 100
        }
        return width
    }
 
    func calculateNumLines(for config: SkeletonMultilinesLayerConfig) -> Int {
        let definedNumberOfLines = config.lines
        let requiredSpaceForEachLine = config.lineHeight + config.multilineSpacing
        let neededLines = round(CGFloat(bounds.height - config.paddingInsets.top - config.paddingInsets.bottom) / CGFloat(requiredSpaceForEachLine))
        guard neededLines.isNormal else {
            return 0
        }

        let calculatedNumberOfLines = Int(neededLines)
        guard calculatedNumberOfLines > 0 else {
            return 1
        }
        
        if definedNumberOfLines > 0, definedNumberOfLines <= calculatedNumberOfLines {
            return definedNumberOfLines
        }
        
        return calculatedNumberOfLines
    }
}

extension CALayer {
    
    func addMultilinesLayers(for config: SkeletonMultilinesLayerConfig) {
        let numberOfSublayers = config.lines > 0 ? config.lines : calculateNumLines(for: config)
        var height = config.lineHeight
        
        if numberOfSublayers == 1 && SkeletonAppearance.default.renderSingleLineAsView {
            height = bounds.height
        }

        let layerBuilder = SkeletonMultilineLayerBuilder()
            .setCornerRadius(config.multilineCornerRadius)
            .setMultilineSpacing(config.multilineSpacing)
            .setPadding(config.paddingInsets)
            .setHeight(height)
            .setAlignment(config.alignment)
    
        (0..<numberOfSublayers).forEach { index in
            let width = calculatedWidthForLine(at: index, totalLines: numberOfSublayers, lastLineFillPercent: config.lastLineFillPercent, paddingInsets: config.paddingInsets)
            if let layer = layerBuilder
                .setIndex(index)
                .setWidth(width)
                .build() {
                addSublayer(layer)
            }
        }
    }

    func updateMultilinesLayers(for config: SkeletonMultilinesLayerConfig) {
        let currentSkeletonSublayers = skeletonSublayers
        let numberOfSublayers = currentSkeletonSublayers.count
        let lastLineFillPercent = config.lastLineFillPercent
        let paddingInsets = config.calculatedPaddingInsets
        let multilineSpacing = config.multilineSpacing
        var height = config.lineHeight
        
        if numberOfSublayers == 1 && SkeletonAppearance.default.renderSingleLineAsView {
            height = bounds.height
        }
        
        for (index, layer) in currentSkeletonSublayers.enumerated() {
            let width = calculatedWidthForLine(at: index, totalLines: numberOfSublayers, lastLineFillPercent: lastLineFillPercent, paddingInsets: paddingInsets)
            layer.updateLayerFrame(for: index,
                                   totalLines: numberOfSublayers,
                                   size: CGSize(width: width, height: height),
                                   multilineSpacing: multilineSpacing,
                                   paddingInsets: paddingInsets,
                                   alignment: config.alignment
            )
        }
        
        guard config.shouldCenterVertically,
              let maxY = currentSkeletonSublayers.last?.frame.maxY else {
            return
        }
        let verticallyCenterAlignedFrames = currentSkeletonSublayers.map { layer -> CGRect in
            let moveDownBy = (bounds.height - (maxY + paddingInsets.top + paddingInsets.bottom)) / 2
            return layer.frame.offsetBy(dx: 0, dy: moveDownBy)
        }
        
        for (index, layer) in currentSkeletonSublayers.enumerated() {
            layer.frame = verticallyCenterAlignedFrames[index]
        }
    }

    func updateLayerFrame(for index: Int, totalLines: Int, size: CGSize, multilineSpacing: CGFloat, paddingInsets: UIEdgeInsets, alignment: NSTextAlignment) {
        let spaceRequiredForEachLine = size.height + multilineSpacing
        let newFrame = CGRect(x: paddingInsets.left,
                              y: CGFloat(index) * spaceRequiredForEachLine + paddingInsets.top,
                              width: size.width,
                              height: size.height)

        if index == totalLines - 1 {
            frame = alignLayerFrame(newFrame, paddingInsets: paddingInsets, alignment: alignment)
        } else {
            frame = newFrame
        }
    }
    
}
