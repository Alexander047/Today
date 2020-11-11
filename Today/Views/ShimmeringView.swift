//
//  ShimmeringView.swift
//  SkeletonViewExample
//
//  Created by Alexander on 15.10.2020.
//  Copyright © 2020 Roni Leshes. All rights reserved.
//

import UIKit

private enum Constants {
    static let startPoint = CGPoint(x: 0.0, y: 1.0)
    static let endPoint = CGPoint(x: 1.0, y: 1.0)
    
    static var startLocations: [NSNumber] = [-1.0,-0.5, 0.0]
    static var endLocations: [NSNumber] = [1.0,1.5, 2.0]
    
    static var gradientColors: [CGColor] = [UIColor(hex: 0xFFFFFF, alpha: 0).cgColor,
                                            UIColor(hex: 0xECEBF1, alpha: 0.7).cgColor,
                                            UIColor(hex: 0xFFFFFF, alpha: 0).cgColor]
    
    static var movingAnimationDuration : CFTimeInterval = 0.8
    static var delayBetweenAnimationLoops : CFTimeInterval = 1.0
}

class ShimmeringView: UIView {
    
    private lazy var gradientLayer = makeGradientLayer()
    private lazy var shimmeringLayer: CALayer = {
        let layer = CALayer()
        layer.addSublayer(gradientLayer)
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    
    private var isAnimating: Bool = false
    private var needRestoreAnimationAfterBackground: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setGradientColors(_ colors: [UIColor]) {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
    
    internal func startShimmering() {
        guard !isAnimating else { return }
        isAnimating = true
        layer.addSublayer(shimmeringLayer)
        gradientLayer.add(makeAnimationGroup(), forKey: "shimmer")
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.subviews.forEach { $0.alpha = 0.6 }
        }
    }

    internal func stopShimmering() {
        guard isAnimating else { return }
        isAnimating = false
        shimmeringLayer.removeFromSuperlayer()
        gradientLayer.removeAllAnimations()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.subviews.forEach { $0.alpha = 1 }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        shimmeringLayer.frame = bounds
        updateMaskLayer()
    }
    
    private func updateMaskLayer() {
        let mutablePath = CGMutablePath()
        for view in subviews where !view.isHidden {
            if view.layer.cornerRadius > 0, view.layer.cornerRadius * 2 <= min(view.frame.width, view.frame.height), view.layer.masksToBounds {
                mutablePath.addRoundedRect(in: view.frame, cornerWidth: view.layer.cornerRadius, cornerHeight: view.layer.cornerRadius)
            } else {
                mutablePath.addRect(view.frame)
            }
        }
        let maskLayer = CAShapeLayer()
        maskLayer.path = mutablePath
        shimmeringLayer.mask = maskLayer
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if self.window != nil && isAnimating {
            startShimmering()
        }
    }
    
    private func setup() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(animationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animationWillMoveToBackground),
                                               name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc
    func animationWillMoveToBackground() {
        if isAnimating {
            needRestoreAnimationAfterBackground = true
            stopShimmering()
        }
    }
    
    @objc
    func animationWillEnterForeground() {
        if needRestoreAnimationAfterBackground {
            startShimmering()
            needRestoreAnimationAfterBackground = false
        }
    }
    
    private func makeGradientLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.startPoint = Constants.startPoint
        layer.endPoint = Constants.endPoint
        layer.colors = Constants.gradientColors
        layer.locations = Constants.startLocations
        return layer
    }
    
    private func makeAnimationGroup() -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.duration = Constants.movingAnimationDuration + Constants.delayBetweenAnimationLoops
        group.animations = [makeAnimation()]
        group.repeatCount = .infinity
        return group
    }
    
    private func makeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = Constants.startLocations
        animation.toValue = Constants.endLocations
        animation.duration = Constants.movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }
}
