//
//  Recoverable.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit

struct RecoverableViewState {
    
    var backgroundColor: UIColor?
    var cornerRadius: CGFloat
    var clipToBounds: Bool
    var isUserInteractionsEnabled: Bool
    
    init(view: UIView) {
        self.backgroundColor = view.backgroundColor
        self.clipToBounds = view.layer.masksToBounds
        self.cornerRadius = view.layer.cornerRadius
        self.isUserInteractionsEnabled = view.isUserInteractionEnabled
    }
    
}

struct RecoverableLabelState {
    var attributedText: NSAttributedString?
    var text: String?
    var textColor: UIColor?

    init(view: UILabel) {
        if let attributedText = view.attributedText {
            self.attributedText = attributedText
        } else {
            self.text = view.text
        }
        self.textColor = view.textColor
    }
}

struct RecoverableTextViewState {
    var attributedText: NSAttributedString?
    var textColor: UIColor?
    
    init(view: UITextView) {
        self.attributedText = view.attributedText
        self.textColor = view.textColor
    }
}

struct RecoverableTextFieldState {
    var attributedText: NSAttributedString?
    var textColor: UIColor?
    var placeholder: String?

    init(view: UITextField) {
        self.attributedText = view.attributedText
        self.textColor = view.textColor
        self.placeholder = view.placeholder
    }
}

struct RecoverableImageViewState {
    var image: UIImage?
    
    init(view: UIImageView) {
        self.image = view.image
    }
}

struct RecoverableButtonViewState {
    var title: String?
    
    init(view: UIButton) {
        self.title = view.titleLabel?.text
    }
}

protocol Recoverable {
    func saveViewState()
    func recoverViewState(forced: Bool)
}

