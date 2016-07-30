//
//  CloudyView.swift
//  CloudySampleProject
//
//  Created by Bobo on 7/29/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

import UIKit

@IBDesignable
public class CloudyView: UIView {
    
    @IBInspectable public var cloudsColor = UIColor.whiteColor() {
        didSet {
            cloudsLayer.fillColor = cloudsColor.CGColor
            paddingLayer.backgroundColor = cloudsColor.CGColor
        }
    }
    
    @IBInspectable public var cloudsShadowColor = UIColor.darkGrayColor() {
        didSet {
            cloudsLayer.shadowColor = cloudsShadowColor.CGColor
        }
    }
    
    @IBInspectable public var cloudsShadowRadius: CGFloat = 1.0 {
        didSet {
            drawClouds()
        }
    }
    
    @IBInspectable public var cloudsShadowOpacity: Float = 1.0 {
        didSet {
            cloudsLayer.shadowOpacity = cloudsShadowOpacity
        }
    }
    
    public var cloudsShadowOffset = CGSize(width: 0.0, height: 1.0) {
        didSet {
            cloudsLayer.shadowOffset = cloudsShadowOffset
        }
    }
    
    @IBInspectable public var minCloudSizeRatio: CGFloat = 0.2 {
        didSet {
            drawClouds()
        }
    }
    
    @IBInspectable public var padding: CGFloat = 0.2 {
        didSet {
            drawClouds()
        }
    }
    
    public var orientation = Orientation.Down {
        didSet {
            reload()
        }
    }
    
    private var cloudsLayer = CAShapeLayer()
    private var paddingLayer = CAShapeLayer()
    
    // MARK: Life Cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        cloudsLayer.masksToBounds = true
    }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawClouds()
    }
    
    // MARK: Public Functions
    
    public func reload() {
        drawClouds()
    }
    
}

internal extension CloudyView {
    
    // - Drawings -
    
    internal func drawClouds() {
        let height = bounds.size.height - (cloudsShadowOffset.height + cloudsShadowRadius)
        let cloudsPath = pathForCloudsWithMinSize(height * minCloudSizeRatio, height: height)
        drawCloudsWithPath(cloudsPath)
    }
    
    internal func drawCloudsWithPath(cloudsPath: UIBezierPath) {
        cloudsLayer.removeFromSuperlayer()
        cloudsLayer.frame = bounds
        cloudsLayer.path = cloudsPath.CGPath
        cloudsLayer.fillColor = cloudsColor.CGColor
        cloudsLayer.shadowOffset = cloudsShadowOffset
        cloudsLayer.shadowColor = cloudsShadowColor.CGColor
        cloudsLayer.shadowRadius = cloudsShadowRadius
        cloudsLayer.shadowOpacity = cloudsShadowOpacity
        layer.addSublayer(cloudsLayer)
    }
    
}

internal extension CloudyView {
    
    // - Paths -
    
    internal func pathForCloudsWithMinSize(minSize: CGFloat, height: CGFloat) -> UIBezierPath {
        var xOffset: CGFloat = 0.0
        let cloudsPath = UIBezierPath()
        var previousCloudSize: CGFloat = 0.0
        
        while xOffset < bounds.size.width {
            let cloudPath = randomPathForCloudWithMinSize(minSize, maxSize: height)
            
            let minRange = max(previousCloudSize - (cloudPath.bounds.size.width / 2.0), previousCloudSize / 2.0)
            let maxRange = previousCloudSize - minRange
            let shouldInverse = maxRange < 0.0
            let uMaxRange = abs(maxRange)
            
            let uRandom = arc4random_uniform(UInt32(uMaxRange)) + UInt32(minRange)
            let random: CGFloat = shouldInverse ? -CGFloat(uRandom) : CGFloat(uRandom)
            
            xOffset = xOffset + random
            
            let yOffset = orientation == .Up ? height - (cloudPath.bounds.size.height / 2.0) : -(cloudPath.bounds.size.height / 2.0)
            
            cloudPath.applyTransform(CGAffineTransformMakeTranslation(xOffset, yOffset))
            cloudsPath.appendPath(cloudPath)
            
            previousCloudSize = cloudPath.bounds.size.width
        }
        
        return cloudsPath
    }
    
    internal func randomPathForCloudWithMinSize(minSize: CGFloat, maxSize: CGFloat) -> UIBezierPath {
        let randomSize = CGFloat(arc4random_uniform(UInt32(maxSize * 2 - minSize * 2)) + UInt32(minSize * 2))
        let cloudPath = UIBezierPath(ovalInRect: CGRectMake(0.0, 0.0, randomSize, randomSize))
        
        return cloudPath
    }
    
}

public enum Orientation {
    case Up
    case Down
}
