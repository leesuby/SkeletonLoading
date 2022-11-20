//
//  UILabel.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

public extension UILabel {
    
    @IBInspectable
    var lastLineFillPercent: Int {
        get { return lastLineFillingPercent }
        set { lastLineFillingPercent = min(newValue, 100) }
    }
    
    @IBInspectable
    var linesCornerRadius: Int {
        get { return multilineCornerRadius }
        set { multilineCornerRadius = newValue }
    }
    
    @IBInspectable
    var skeletonLineSpacing: CGFloat {
        get { return multilineSpacing }
        set { multilineSpacing = newValue }
    }
    
}

extension UILabel {
    
    var desiredHeightBasedOnNumberOfLines: CGFloat {
        let spaceNeededForEachLine = estimatedLineHeight * CGFloat(estimatedNumberOfLines)
        let spaceNeededForSpaces = skeletonLineSpacing * CGFloat(estimatedNumberOfLines - 1)
        let padding = paddingInsets.top + paddingInsets.bottom
        
        return spaceNeededForEachLine + spaceNeededForSpaces + padding
    }
    
    func updateHeightConstraintsIfNeeded() {
        guard estimatedNumberOfLines > 1 || estimatedNumberOfLines == 0 else { return }
        
        // Workaround to simulate content when the label is contained in a `UIStackView`.
        if isSuperviewAStackView, bounds.height == 0, (text?.isEmpty ?? true) {
            // This is a placeholder text to simulate content because it's contained in a stack view in order to prevent that the content size will be zero.
            text = " "
        }
        
        let desiredHeight = desiredHeightBasedOnNumberOfLines
        if desiredHeight > definedMaxHeight {
            backupHeightConstraints = heightConstraints
            NSLayoutConstraint.deactivate(heightConstraints)
            setHeight(equalToConstant: desiredHeight)
        }
    }
    
    func restoreBackupHeightConstraintsIfNeeded() {
        guard !backupHeightConstraints.isEmpty else { return }
        NSLayoutConstraint.activate(backupHeightConstraints)
        backupHeightConstraints.removeAll()
    }
    
}

