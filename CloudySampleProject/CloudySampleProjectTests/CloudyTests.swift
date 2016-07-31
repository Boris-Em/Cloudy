//
//  CloudyTests.swift
//  CloudySampleProject
//
//  Created by Bobo on 7/30/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

import XCTest

@testable import CloudySampleProject

class CloudyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitWithFrame() {
        let cloudyView = CloudyView(frame: CGRectMake(0.0, 0.0, 500.0, 500.0))
        XCTAssertNotNil(cloudyView, "A fully initialized CloudyView instance should be instanciated.")
    }
    
    func testReload() {
        let cloudyView = CloudyView(frame: CGRectMake(0.0, 0.0, 500.0, 500.0))
        cloudyView.reload()
        if let cloudsLayer = cloudyView.layer.sublayers?.first as? CAShapeLayer {
            XCTAssertEqual(cloudsLayer.frame, cloudyView.bounds)
            let path = cloudsLayer.path
            cloudyView.reload()
            XCTAssertFalse(CGPathEqualToPath(path, cloudsLayer.path))
        }
    }
    
    func testRandomPathForCloudWithMinSize() {
        let numberOfTests = 500
        
        for _ in 0..<numberOfTests {
            let maxSize = arc4random_uniform(UInt32(500)) + 100
            let minSize = arc4random_uniform(maxSize)
            let cloudPath = CloudyView.randomPathForCloudWithMinSize(CGFloat(minSize), maxSize: CGFloat(maxSize))
            let pathWidth = cloudPath.bounds.size.width / 2.0
            
            XCTAssertGreaterThanOrEqual(pathWidth, CGFloat(minSize))
            XCTAssertLessThanOrEqual(pathWidth, CGFloat(maxSize))
            XCTAssertEqual(cloudPath.bounds.size.width, cloudPath.bounds.size.height)
        }
    }
    
}
