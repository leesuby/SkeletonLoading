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

extension UIView: Recoverable {
    
    var viewState: RecoverableViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.viewState) as? RecoverableViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.viewState) }
    }
    
    @objc func saveViewState() {
        viewState = RecoverableViewState(view: self)
    }
    
    @objc func recoverViewState(forced: Bool) {
        guard let storedViewState = viewState else { return }
        
        startTransition { [weak self] in
            guard let self = self else { return }
            
            self.layer.cornerRadius = storedViewState.cornerRadius
            self.layer.masksToBounds = storedViewState.clipToBounds
            
            if self.isUserInteractionDisabledWhenSkeletonIsActive {
                self.isUserInteractionEnabled = storedViewState.isUserInteractionsEnabled
            }
            
            if self.backgroundColor == .clear || forced {
                self.backgroundColor = storedViewState.backgroundColor
            }
        }
    }
    
}

extension UILabel {
    
    var labelState: RecoverableLabelState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.labelViewState) as? RecoverableLabelState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.labelViewState) }
    }
    
    override func saveViewState() {
        super.saveViewState()
        labelState = RecoverableLabelState(view: self)
    }
    
    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        startTransition { [weak self] in
            guard let self = self,
                  let storedLabelState = self.labelState else {
                return
            }
            
            NSLayoutConstraint.deactivate(self.skeletonHeightConstraints)
            self.restoreBackupHeightConstraintsIfNeeded()
            
            if self.textColor == .clear || forced {
                self.textColor = storedLabelState.textColor
                if let attributedText = storedLabelState.attributedText {
                    self.attributedText = attributedText
                } else {
                    self.text = storedLabelState.text
                }
            }
        }
    }
    
}

extension UITextView {
    
    var textState: RecoverableTextViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.labelViewState) as? RecoverableTextViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.labelViewState) }
    }
    
    override func saveViewState() {
        super.saveViewState()
        textState = RecoverableTextViewState(view: self)
    }
    
    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        startTransition { [weak self] in
            guard let storedLabelState = self?.textState else { return }
            
            if self?.textColor == .clear || forced {
                self?.textColor = storedLabelState.textColor
                if let attributedText = storedLabelState.attributedText {
                    self?.attributedText = attributedText
                }
            }
        }
    }
    
}

extension UITextField {
    
    var textState: RecoverableTextFieldState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.labelViewState) as? RecoverableTextFieldState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.labelViewState) }
    }

    override func saveViewState() {
        super.saveViewState()
        textState = RecoverableTextFieldState(view: self)
    }

    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        startTransition { [weak self] in
            guard let storedLabelState = self?.textState else { return }

            if self?.textColor == .clear || forced {
                self?.textColor = storedLabelState.textColor
                if let attributedText = storedLabelState.attributedText {
                    self?.attributedText = attributedText
                }
            }

            if self?.placeholder == nil || forced {
                self?.placeholder = storedLabelState.placeholder
            }
        }
    }
    
}

extension UIImageView {
    
    var imageState: RecoverableImageViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.imageViewState) as? RecoverableImageViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.imageViewState) }
    }
    
    override func saveViewState() {
        super.saveViewState()
        imageState = RecoverableImageViewState(view: self)
    }
    
    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        startTransition { [weak self] in
            self?.image = self?.image == nil || forced ? self?.imageState?.image : self?.image
        }
    }
    
}

extension UIButton {
    
    var buttonState: RecoverableButtonViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.buttonViewState) as? RecoverableButtonViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.buttonViewState) }
    }
    
    override func saveViewState() {
        super.saveViewState()
        buttonState = RecoverableButtonViewState(view: self)
    }
    
    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        startTransition { [weak self] in
            if self?.title(for: .normal) == nil {
                self?.setTitle(self?.buttonState?.title, for: .normal)
            }
        }
    }
    
}
