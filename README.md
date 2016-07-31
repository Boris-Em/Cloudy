# Cloudy

[![Build Status](https://travis-ci.org/Boris-Em/Cloudy.svg?branch=master)](https://travis-ci.org/Boris-Em/Cloudy)
[![Version](https://img.shields.io/cocoapods/v/Cloudy.svg?style=flat)](http://cocoadocs.org/docsets/Cloudy)
[![License](https://img.shields.io/cocoapods/l/Cloudy.svg?style=flat)](http://cocoadocs.org/docsets/Cloudy)
[![Platform](https://img.shields.io/cocoapods/p/Cloudy.svg?style=flat)](http://cocoadocs.org/docsets/Cloudy)

<p align="center"><img src="https://s31.postimg.org/a0lsa8b2z/Banner.jpg"/></p>	

## Table of Contents

* [**Project Details**](#project-details)  
  * [Requirements](#requirements)
  * [License](#license)
  * [Support](#support)
  * [Sample App](#sample-app)
* [**Getting Started**](#getting-started)
  * [Installation](#installation)
  * [Setup](#setup)
* [**Documentation**](#documentation)

## Project Details

Learn more about the **Cloudy** project, licensing, support etc.

### Requirements
 - Requires iOS 7 or later. The sample project is optimized for iOS 9.
 - Requires Automatic Reference Counting (ARC).
 - Optimized for ARM64 Architecture.

### License
See the [License](https://github.com/Boris-Em/Cloudy/blob/master/LICENSE). You are free to make changes and use this in either personal or commercial projects. Attribution is not required, but highly appreciated. A little "Thanks!" (or something to that affect) is always welcome. If you use **Cloudy** in your app, please let us know!

### Support
[![https://gitter.im/Boris-Em/Cloudy](https://badges.gitter.im/Boris-Em/Cloudy.svg)](https://gitter.im/Boris-Em/Cloudy?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)  

Join us on gitter if you have any question!

### Sample App
The iOS Sample App included with this project demonstrates one way to correctly setup and use **Cloudy**. It also offers the possibility to customize the view within the app.

## Getting Started

It only takes a few simple steps to install and setup **Cloudy** to your project.

###Installation
The easiest way to install **Cloudy** is to use <a href="http://cocoapods.org/" target="_blank">CocoaPods</a>. To do so, simply add the following line to your `Podfile`:
	<pre><code>pod 'Cloudy'</code></pre>
	
The other way to install **Cloudy**, is to drag and drop the *Cloudy* folder into your Xcode project. When you do so, make sure to check the "*Copy items into destination group's folder*" box.

### Setup
**Cloudy** is a simple UIView subclass. It can be initialized with Interface Builder, or programatically.
 
 **Interface Builder Initialization**  
 1 - Drag a `UIView` to your `UIViewController`.  
 2 - Change the class of the new `UIView` to `Cloudy`.  
 3 - Select the `Cloudy` and open the Attributes Inspector. Most of the customizable properties can easily be set from the Attributes Inspector. The Sample App demonstrates this capability.
 
 **Programmatical Initialization**  
 Here is an example illustrating how to initialize a Cloudy instance programmatically:

 ```swift
 let cloudyView = Cloudy(frame: CGRectMake(0.0, 0.0, 200.0, 200.0))
 view.addSubview(Cloudy)
 ```
## Documentation
All of the methods and properties available for **Cloudy** are documented below.

##### `cloudsColor`  
The color of the clouds. Defaults to white.

##### `cloudsShadowColor`  
The color of the clouds' shadow. Default to darkGrayColor.

##### `cloudsShadowRadius`  
The radius of the clouds' shadow. Defaults to 1.0.

##### `cloudsShadowOpacity`  
The opacity of the clouds' shadow. Defaults to 1.0.

##### `cloudsShadowOffset`  
The offset of the clouds' shadow. Defaults to (0.0, 1.0).

##### `minCloudSizeRatio`  
The minimum size of the clouds as a ratio of the view's height. From 0.0 to 1.0, 0.0 being 0% of the view's height and 1.0 being 100% of the view's height. Defaults to 0.2.

##### `padding`  
A padding that will be filled with the color of `cloudsColor`. The padding will be at the top, or bottom of the view depending on the property `orientation`. It is expressed as a value between 0.0 and 1.0, 0.0 meaning no padding, and 1.0 that the view will be filled with the padding. Defaults to 0.2.

##### `orientation`  
The orientation of the clouds. Defaults to `Down`.
