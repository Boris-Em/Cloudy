//
//  CloudyView.swift
//  CloudySampleProject
//
//  Created by Bobo on 7/29/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

import UIKit

/** Random Cloudy Skies - Cloudy is a simple UIView subclass that lets you generate random yet beautiful clouds.
 */
@IBDesignable
public class CloudyView: UIView {
    
    /** The color of the clouds. Defaults to white.
     */
    @IBInspectable public var cloudsColor = UIColor.whiteColor() {
        didSet {
            cloudsLayer.fillColor = cloudsColor.CGColor
            paddingLayer.backgroundColor = cloudsColor.CGColor
        }
    }
    
    /** The color of the clouds' shadow. Default to darkGrayColor.
     */
    @IBInspectable public var cloudsShadowColor = UIColor.darkGrayColor() {
        didSet {
            cloudsLayer.shadowColor = cloudsShadowColor.CGColor
        }
    }
    
    /** The radius of the clouds' shadow. Defaults to 1.0.
     */
    @IBInspectable public var cloudsShadowRadius: CGFloat = 1.0 {
        didSet {
            drawClouds()
        }
    }
    
    /** The opacity of the clouds' shadow. Defaults to 1.0.
     */
    @IBInspectable public var cloudsShadowOpacity: Float = 1.0 {
        didSet {
            cloudsLayer.shadowOpacity = cloudsShadowOpacity
        }
    }
    
    /** The offset of the clouds' shadow. Defaults to (0.0, 1.0).
     */
    public var cloudsShadowOffset = CGSize(width: 0.0, height: 1.0) {
        didSet {
            cloudsLayer.shadowOffset = cloudsShadowOffset
        }
    }
    
    /** The minimum size of the clouds as a ratio of the view's height. From 0.0 to 1.0, 0.0 being 0% of the view's height and 1.0 being 100% of the view's height.
     Defaults to 0.2.
     */
    @IBInspectable public var minCloudSizeRatio: CGFloat = 0.2 {
        didSet {
            drawClouds()
        }
    }
    
    /** A padding that will be filled with the color of `cloudsColor`. The padding will be at the top, or bottom of the view depending on the property `orientation`. It is expressed as a value between 0.0 and 1.0, 0.0 meaning no padding, and 1.0 that the view will be filled with the padding. Defaults to 0.2.
     */
    @IBInspectable public var padding: CGFloat = 0.2 {
        didSet {
            drawClouds()
        }
    }
    
    /** The orientation of the clouds. Defaults to `Down`.
     */
    public var orientation = Orientation.Down {
        didSet {
            reload()
        }
    }
    
    public enum Orientation {
        case Up
        case Down
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        drawClouds()
    }
    
    // MARK: Public Functions
    
    /** Reloads the view, redrawing the clouds.
     */
    public func reload() {
        drawClouds()
    }
    
}

internal extension CloudyView {
    
    // MARK: Drawings
    
    internal func drawClouds() {
        let cloudsHeight = bounds.size.height - (cloudsShadowOffset.height + cloudsShadowRadius * 2)
        if let cloudsPath = pathForCloudsWithMinSize(cloudsHeight * minCloudSizeRatio, height: bounds.size.height, cloudsHeight: cloudsHeight, padding: cloudsHeight * padding) {
            drawCloudsWithPath(cloudsPath)
            
            if padding > 0.0 {
                drawPaddingWithHeight(cloudsHeight * padding)
            }
        }
    }
    
    internal func drawPaddingWithHeight(height: CGFloat) {
        paddingLayer.removeFromSuperlayer()
        let yOffset = orientation == .Up ? bounds.size.height - height: 0.0
        paddingLayer.frame = CGRectMake(0.0, yOffset, bounds.size.width, height)
        paddingLayer.backgroundColor = cloudsColor.CGColor
        layer.addSublayer(paddingLayer)
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
    
    // MARK: Paths
    
    internal func pathForCloudsWithMinSize(minSize: CGFloat, height: CGFloat, cloudsHeight: CGFloat, padding: CGFloat) -> UIBezierPath? {
        let cloudsHeight = cloudsHeight - padding
        
        guard cloudsHeight > minSize else {
            return nil
        }
        
        var xOffset: CGFloat = 0.0
        let cloudsPath = UIBezierPath()
        var previousCloudSize: CGFloat = 0.0
        
        while xOffset < bounds.size.width {
            let cloudPath = CloudyView.randomPathForCloudWithMinSize(minSize, maxSize: cloudsHeight)
            
            if xOffset == 0.0 {
                xOffset = -CGFloat(arc4random_uniform(UInt32(cloudPath.bounds.size.width / 2.0)))
            }
            
            let minRange = max(previousCloudSize - (cloudPath.bounds.size.width / 2.0), previousCloudSize / 2.0)
            let maxRange = previousCloudSize - minRange
            let shouldInverse = maxRange < 0.0
            let uMaxRange = abs(maxRange)
            
            let uRandom = arc4random_uniform(UInt32(uMaxRange)) + UInt32(minRange)
            let random: CGFloat = shouldInverse ? -CGFloat(uRandom) : CGFloat(uRandom)
            
            xOffset = xOffset + random
            
            let yOffset = orientation == .Up ? height - (cloudPath.bounds.size.height / 2.0) : -(cloudPath.bounds.size.height / 2.0) + padding
            
            cloudPath.applyTransform(CGAffineTransformMakeTranslation(xOffset, yOffset))
            cloudsPath.appendPath(cloudPath)
            
            previousCloudSize = cloudPath.bounds.size.width
        }
        
        return cloudsPath
    }
    
    class internal func randomPathForCloudWithMinSize(minSize: CGFloat, maxSize: CGFloat) -> UIBezierPath {
        let randomSize = CGFloat(arc4random_uniform(UInt32(maxSize * 2 - minSize * 2)) + UInt32(minSize * 2))
        let cloudPath = UIBezierPath(ovalInRect: CGRectMake(0.0, 0.0, randomSize, randomSize))
        
        return cloudPath
    }
    
}
