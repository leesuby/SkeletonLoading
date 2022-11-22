//
//  UIView.swift
//  SkeletonLoading
//
//  Created by LAP15335 on 21/11/2022.
//

import Foundation
import UIKit


//MARK: Generic Type
public struct SkeletonViewExtension<T> {
    public private(set) var type: T

    public init(_ type: T) {
        self.type = type
    }
}

public extension SkeletonViewExtension where T: UIView {

    var isSkeletonActive: Bool {
        type._status == .on || type.subviewsSkeletonables.contains(where: { $0.sk.isSkeletonActive })
    }
    
}


public protocol SkeletonViewExtended {
    associatedtype T

    var sk: SkeletonViewExtension<T> { get set }
}

extension SkeletonViewExtended {
    public var sk: SkeletonViewExtension<Self> {
        get { SkeletonViewExtension(self) }
        
        set {}
    }
}

extension UIView: SkeletonViewExtended { }


//MARK: Swizzle
extension UIView {

    @objc func skeletonLayoutSubviews() {
        guard Thread.isMainThread else { return }
        skeletonLayoutSubviews()
        guard sk.isSkeletonActive else { return }
        layoutSkeletonIfNeeded()
    }

    @objc func skeletonTraitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        skeletonTraitCollectionDidChange(previousTraitCollection)
        guard isSkeletonable, sk.isSkeletonActive, let config = _currentSkeletonConfig else { return }
        updateSkeleton(skeletonConfig: config)
    }
    
    func swizzleLayoutSubviews() {
        DispatchQueue.main.async {
            DispatchQueue.once(token: "UIView.SkeletonView.swizzleLayoutSubviews") {
                swizzle(selector: #selector(UIView.layoutSubviews),
                        with: #selector(UIView.skeletonLayoutSubviews),
                        inClass: UIView.self,
                        usingClass: UIView.self)
                self.layoutSkeletonIfNeeded()
            }
        }
    }
    
    func unSwizzleLayoutSubviews() {
        DispatchQueue.main.async {
            DispatchQueue.removeOnce(token: "UIView.SkeletonView.swizzleLayoutSubviews") {
                swizzle(selector: #selector(UIView.skeletonLayoutSubviews),
                        with: #selector(UIView.layoutSubviews),
                        inClass: UIView.self,
                        usingClass: UIView.self)
            }
        }
    }
    
    func swizzleTraitCollectionDidChange() {
        DispatchQueue.main.async {
            DispatchQueue.once(token: "UIView.SkeletonView.swizzleTraitCollectionDidChange") {
                swizzle(selector: #selector(UIView.traitCollectionDidChange(_:)),
                        with: #selector(UIView.skeletonTraitCollectionDidChange(_:)),
                        inClass: UIView.self,
                        usingClass: UIView.self)
            }
        }
    }
    
    func unSwizzleTraitCollectionDidChange() {
        DispatchQueue.main.async {
            DispatchQueue.removeOnce(token: "UIView.SkeletonView.swizzleTraitCollectionDidChange") {
                swizzle(selector: #selector(UIView.skeletonTraitCollectionDidChange(_:)),
                        with: #selector(UIView.traitCollectionDidChange(_:)),
                        inClass: UIView.self,
                        usingClass: UIView.self)
            }
        }
    }
}



//MARK: Association Object
enum ViewAssociatedKeys {
    
    static var skeletonable = "skeletonable"
    static var hiddenWhenSkeletonIsActive = "hiddenWhenSkeletonIsActive"
    static var status = "status"
    static var skeletonLayer = "layer"
    static var isSkeletonAnimated = "isSkeletonAnimated"
    static var viewState = "viewState"
    static var labelViewState = "labelViewState"
    static var imageViewState = "imageViewState"
    static var buttonViewState = "buttonViewState"
    static var currentSkeletonConfig = "currentSkeletonConfig"
    static var skeletonCornerRadius = "skeletonCornerRadius"
    static var disabledWhenSkeletonIsActive = "disabledWhenSkeletonIsActive"
    static var delayedShowSkeletonWorkItem = "delayedShowSkeletonWorkItem"
    
}

extension UIView {
    
    enum SkeletonStatus {
        case on
        case off
    }

    var _skeletonLayer: SkeletonLayer? {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonLayer) as? SkeletonLayer }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.skeletonLayer) }
    }

    var _currentSkeletonConfig: SkeletonConfig? {
        get { return ao_get(pkey: &ViewAssociatedKeys.currentSkeletonConfig) as? SkeletonConfig }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.currentSkeletonConfig) }
    }

    var _status: SkeletonStatus {
        get { return ao_get(pkey: &ViewAssociatedKeys.status) as? SkeletonStatus ?? .off }
        set { ao_set(newValue, pkey: &ViewAssociatedKeys.status) }
    }

    var _isSkeletonAnimated: Bool {
        get { return ao_get(pkey: &ViewAssociatedKeys.isSkeletonAnimated) as? Bool ?? false }
        set { ao_set(newValue, pkey: &ViewAssociatedKeys.isSkeletonAnimated) }
    }
    
    var _delayedShowSkeletonWorkItem: DispatchWorkItem? {
        get { return ao_get(pkey: &ViewAssociatedKeys.delayedShowSkeletonWorkItem) as? DispatchWorkItem }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.delayedShowSkeletonWorkItem) }
    }
    
    var _skeletonable: Bool {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonable) as? Bool ?? false }
        set { ao_set(newValue, pkey: &ViewAssociatedKeys.skeletonable) }
    }
    
    var _hiddenWhenSkeletonIsActive: Bool {
        get { return ao_get(pkey: &ViewAssociatedKeys.hiddenWhenSkeletonIsActive) as? Bool ?? false }
        set { ao_set(newValue, pkey: &ViewAssociatedKeys.hiddenWhenSkeletonIsActive) }
    }
    
    var _disabledWhenSkeletonIsActive: Bool {
        get { return ao_get(pkey: &ViewAssociatedKeys.disabledWhenSkeletonIsActive) as? Bool ?? true }
        set { ao_set(newValue, pkey: &ViewAssociatedKeys.disabledWhenSkeletonIsActive) }
    }

    var _skeletonableCornerRadius: Float {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonCornerRadius) as? Float ?? SkeletonViewAppearance.shared.skeletonCornerRadius }
        set { ao_set(newValue, pkey: &ViewAssociatedKeys.skeletonCornerRadius) }
    }
}

//MARK: Transition

extension UIView{
    func startTransition(transitionBlock: @escaping () -> Void) {
        transitionBlock()}
}

//MARK: Skeleton Recursive

extension UIView {
    
    func showSkeleton(
        skeletonConfig config: SkeletonConfig
    ) {
        recursiveShowSkeleton(skeletonConfig: config, root: self)
    }

    func updateSkeleton(
        skeletonConfig config: SkeletonConfig
    ) {
        recursiveUpdateSkeleton(skeletonConfig: config, root: self)
    }

    func recursiveLayoutSkeletonIfNeeded(root: UIView? = nil) {
        subviewsSkeletonables.recursiveSearch(leafBlock: {
            guard isSkeletonable, sk.isSkeletonActive else { return }
            layoutSkeletonLayerIfNeeded()
            startSkeletonAnimation()
        }) { subview in
            subview.recursiveLayoutSkeletonIfNeeded()
        }
    }

    func recursiveHideSkeleton(reloadDataAfter reload: Bool, root: UIView? = nil) {
        guard sk.isSkeletonActive else { return }
        if isHiddenWhenSkeletonIsActive {
            isHidden = false
        }
       
        unSwizzleLayoutSubviews()
        unSwizzleTraitCollectionDidChange()
        removeDummyDataSourceIfNeeded(reloadAfter: reload)
        subviewsSkeletonables.recursiveSearch(leafBlock: {
            recoverViewState(forced: false)
            removeSkeletonLayer()
        }) { subview in
            subview.recursiveHideSkeleton(reloadDataAfter: reload)
        }
    }
    
}

private extension UIView {
    
    func showSkeletonIfNotActive(skeletonConfig config: SkeletonConfig) {
        guard !sk.isSkeletonActive else { return }
        saveViewState()

        prepareViewForSkeleton()
        addSkeletonLayer(skeletonConfig: config)
    }
    
    func recursiveShowSkeleton(skeletonConfig config: SkeletonConfig, root: UIView? = nil) {
        if isHiddenWhenSkeletonIsActive {
            isHidden = true
        }
        guard isSkeletonable && !sk.isSkeletonActive else { return }
        _currentSkeletonConfig = config
        swizzleLayoutSubviews()
        swizzleTraitCollectionDidChange()
        addDummyDataSourceIfNeeded()
        subviewsSkeletonables.recursiveSearch(leafBlock: {
            showSkeletonIfNotActive(skeletonConfig: config)
        }) { subview in
            subview.recursiveShowSkeleton(skeletonConfig: config)
        }
    }
    
    func recursiveUpdateSkeleton(skeletonConfig config: SkeletonConfig, root: UIView? = nil) {
        guard sk.isSkeletonActive else { return }
        _currentSkeletonConfig = config
        updateDummyDataSourceIfNeeded()
        subviewsSkeletonables.recursiveSearch(leafBlock: {
            if _skeletonLayer != nil{
                removeSkeletonLayer()
                addSkeletonLayer(skeletonConfig: config)
            } else {
                updateSkeletonLayer(skeletonConfig: config)
            }
        }) { subview in
            subview.recursiveUpdateSkeleton(skeletonConfig: config)
        }
    }
    
}

//MARK: Subview
extension UIView {
    
    @objc var subviewsSkeletonables: [UIView] {
        subviewsToSkeleton.filter { $0.isSkeletonable }
    }

    @objc var subviewsToSkeleton: [UIView] {
        subviews
    }
    
}

extension UICollectionView {
    override var subviewsToSkeleton: [UIView] {
        subviews
    }
}


//MARK: Convenience
extension UIView {
    /// Flags
    var isSuperviewAStackView: Bool {
        superview is UIStackView
    }
    
    /// Math
    var definedMaxBounds: CGRect {
        if let parentStackView = (superview as? UIStackView) {
            var origin: CGPoint = .zero
            switch parentStackView.alignment {
            case .trailing:
                origin.x = definedMaxWidth
            default:
                break
            }
            return CGRect(origin: origin, size: definedMaxSize)
        }
        return CGRect(origin: .zero, size: definedMaxSize)
    }
    
    var definedMaxSize: CGSize {
        CGSize(width: definedMaxWidth, height: definedMaxHeight)
    }
    
    var definedMaxWidth: CGFloat {
        let constraintsMaxWidth = widthConstraints
            .map { $0.constant }
            .max() ?? 0

        return max(frame.size.width, constraintsMaxWidth)
    }
    
    var definedMaxHeight: CGFloat {
        let constraintsMaxHeight = heightConstraints
            .map { $0.constant }
            .max() ?? 0

        return max(frame.size.height, constraintsMaxHeight)
    }
    
    /// Autolayout
    var widthConstraints: [NSLayoutConstraint] {
        nonContentSizeLayoutConstraints.filter { $0.firstAttribute == NSLayoutConstraint.Attribute.width }
    }
    
    var heightConstraints: [NSLayoutConstraint] {
        nonContentSizeLayoutConstraints.filter { $0.firstAttribute == NSLayoutConstraint.Attribute.height }
    }
    
    var skeletonHeightConstraints: [NSLayoutConstraint] {
        nonContentSizeLayoutConstraints.filter {
            $0.firstAttribute == NSLayoutConstraint.Attribute.height
                && $0.identifier?.contains("SkeletonView.Constraint.Height") ?? false
        }
    }
    
    @discardableResult
    func setHeight(equalToConstant constant: CGFloat) -> NSLayoutConstraint {
        let heightConstraint = heightAnchor.constraint(equalToConstant: constant)
        heightConstraint.identifier = "SkeletonView.Constraint.Height.\(constant)"
        NSLayoutConstraint.activate([heightConstraint])
        return heightConstraint
    }
    
    var nonContentSizeLayoutConstraints: [NSLayoutConstraint] {
        constraints.filter({ "\(type(of: $0))" != "NSContentSizeLayoutConstraint" })
    }
    
    /// Animations
    func startSkeletonLayerAnimationBlock(_ anim: SkeletonLayerAnimation? = nil) -> VoidBlock {
        {
            self._isSkeletonAnimated = true
            guard let layer = self._skeletonLayer else { return }
            layer.start(anim) { [weak self] in
                self?._isSkeletonAnimated = false
            }
        }
    }
    var stopSkeletonLayerAnimationBlock: VoidBlock {
        {
            self._isSkeletonAnimated = false
            guard let layer = self._skeletonLayer else { return }
            layer.stopAnimation()
        }
    }
    
    /// Skeleton Layer
    
    func addSkeletonLayer(skeletonConfig config: SkeletonConfig) {
        guard let skeletonLayer = SkeletonLayerBuilder()
            .addColors(config.colors)
            .setHolder(self)
            .build()
            else { return }
        
        self._skeletonLayer = skeletonLayer
        layer.insertSkeletonLayer(
            skeletonLayer,
            atIndex: UInt32.max
        ) { [weak self] in
            guard let self = self else { return }
            
            (self as? UITextView)?.setContentOffset(.zero, animated: false)
            self.startSkeletonAnimation()
            
        }
        _status = .on
    }
    
    func updateSkeletonLayer(skeletonConfig config: SkeletonConfig) {
        guard let skeletonLayer = _skeletonLayer else { return }
        skeletonLayer.update(usingColors: config.colors)
        
        startSkeletonAnimation()
    }

    func layoutSkeletonLayerIfNeeded() {
        guard let skeletonLayer = _skeletonLayer else { return }
        skeletonLayer.layoutIfNeeded()
    }
    
    func removeSkeletonLayer() {
        guard sk.isSkeletonActive,
            let skeletonLayer = _skeletonLayer else { return }
        skeletonLayer.stopAnimation()
        _status = .off
        skeletonLayer.removeLayer() {
            self._skeletonLayer = nil
            self._currentSkeletonConfig = nil
        }
    }
    
}

//MARK: @IBInspectable
public extension UIView {
    
    @IBInspectable
    var isSkeletonable: Bool {
        get { _skeletonable }
        set { _skeletonable = newValue }
    }
    
    @IBInspectable
    var isHiddenWhenSkeletonIsActive: Bool {
        get { _hiddenWhenSkeletonIsActive }
        set { _hiddenWhenSkeletonIsActive = newValue }
    }
    
    @IBInspectable
    var isUserInteractionDisabledWhenSkeletonIsActive: Bool {
        get { _disabledWhenSkeletonIsActive }
        set { _disabledWhenSkeletonIsActive = newValue }
    }

    @IBInspectable
    var skeletonCornerRadius: Float {
        get { _skeletonableCornerRadius }
        set { _skeletonableCornerRadius = newValue }
    }
    
}

