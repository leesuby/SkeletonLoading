//
//  PrepareView.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

extension UIView {
    
    @objc func prepareViewForSkeleton() {
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = false
        }
        
        startTransition { [weak self] in
            self?.backgroundColor = .clear
        }
    }
    
}

extension UILabel {
    
    override func prepareViewForSkeleton() {
        backgroundColor = .clear
        
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = false
        }
        
        resignFirstResponder()
        startTransition { [weak self] in
            self?.updateHeightConstraintsIfNeeded()
            self?.textColor = .clear
        }
    }
}

extension UITextView {
    
    override func prepareViewForSkeleton() {
        backgroundColor = .clear
        
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = false
        }
        
        resignFirstResponder()
        startTransition { [weak self] in
            self?.textColor = .clear
        }
    }
    
}

extension UITextField {
    
    override func prepareViewForSkeleton() {
        backgroundColor = .clear
        resignFirstResponder()

        startTransition { [weak self] in
            self?.textColor = .clear
            self?.placeholder = nil
        }
    }
    
}

extension UIImageView {
    
    override func prepareViewForSkeleton() {
        backgroundColor = .clear
        
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = false
        }
        
        startTransition { [weak self] in
            self?.image = nil
        }
    }
    
}

extension UIButton {
    
    override func prepareViewForSkeleton() {
        backgroundColor = .clear
        
        if isUserInteractionDisabledWhenSkeletonIsActive {
            isUserInteractionEnabled = false
        }
        
        startTransition { [weak self] in
            self?.setTitle(nil, for: .normal)
        }
    }
    
}
