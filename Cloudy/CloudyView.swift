//
//  CloudyView.swift
//  CloudySampleProject
//
//  Created by Bobo on 7/29/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

import UIKit

public class CloudyView: UIView {
    
    public var cloudsColor = UIColor.whiteColor()
    public var cloudsShadowOffset = CGSize(width: 0.0, height: 1.0)
    public var cloudsShadowColor = UIColor.darkGrayColor()
    public var cloudsShadowRadius: CGFloat = 1.0
    public var cloudsShadowOpacity: Float = 1.0
    public var minCloudSize = 10.0
    public var maxCloudSize = 100.0
    
    private var cloudsLayer = CAShapeLayer() {
        didSet {
            self.layer.addSublayer(cloudsLayer)
        }
    }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let cloudsPath = pathForCloudsWithMinSize(minCloudSize, maxSize: maxCloudSize, height: bounds.size.height)
        drawCloudsWithPath(cloudsPath)
    }
    
}

internal extension CloudyView {
    
    // - Drawings -
    
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
    
    internal func pathForCloudsWithMinSize(minSize: Double, maxSize: Double, height: CGFloat) -> UIBezierPath {
        var offset: CGFloat = 0.0
        let cloudsPath = UIBezierPath()
        var previousCloudSize: CGFloat = 0.0
        
        while offset < bounds.size.width {
            let cloudPath = randomPathForCloudWithMinSize(minSize, maxSize: maxSize)
            
            let minRange = max(previousCloudSize - (cloudPath.bounds.size.width / 2.0), previousCloudSize / 2.0)
            let maxRange = previousCloudSize - minRange
            let shouldInverse = maxRange < 0.0
            let uMaxRange = abs(maxRange)
            
            let uRandom = arc4random_uniform(UInt32(uMaxRange)) + UInt32(minRange)
            let random: CGFloat = shouldInverse ? -CGFloat(uRandom) : CGFloat(uRandom)
            
            offset = offset + random
            
            cloudPath.applyTransform(CGAffineTransformMakeTranslation(offset, height - (cloudPath.bounds.size.height / 2.0)))
            cloudsPath.appendPath(cloudPath)
            
            previousCloudSize = cloudPath.bounds.size.width
        }
        
        return cloudsPath
    }
    
    internal func randomPathForCloudWithMinSize(minSize: Double, maxSize: Double) -> UIBezierPath {
        let randomSize = CGFloat(arc4random_uniform(UInt32(maxSize)) + UInt32(minSize))
        let cloudPath = UIBezierPath(ovalInRect: CGRectMake(0.0, 0.0, randomSize, randomSize))
        
        return cloudPath
    }
    
}
