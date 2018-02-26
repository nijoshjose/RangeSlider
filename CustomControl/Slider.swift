//
//  Slider.swift
//  CustomControl
//
//  Created by uvionics on 2/26/18.
//  Copyright © 2018 uvionics. All rights reserved.
//

import UIKit
import QuartzCore

class Slider: UIControl {
    let minimumValue = 0.0
    let maximumValue = 1.0
    var lowerValue = 0.2
    var upperValue = 0.8
    let trackLayer = SliderLayer()
    var trackTintColor = UIColor(white: 0.9, alpha: 1.0)
    var trackHighLightTintColor = UIColor(red: 0.0, green: 0.54, blue: 0.94, alpha: 1.0)
    var thumbTintColor = UIColor.white
    var unknown: CGFloat = 1.0
//    var value
    let lowerLayer = SliderThumbLayer()
    let upperLayer = SliderThumbLayer()

    var previousLocation = CGPoint()
    var thumbWidth: CGFloat {
        return bounds.height
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lowerLayer.slider = self
        upperLayer.slider = self
        trackLayer.slider = self
        
        // Setting User Intration To the Layers By Default It is True
        lowerLayer.editEnable = false
        
        //trackLayer.backgroundColor = UIColor.red.cgColor
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
       // lowerLayer.backgroundColor = UIColor.black.cgColor
        lowerLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerLayer)
        upperLayer.contentsScale = UIScreen.main.scale
       // upperLayer.backgroundColor = UIColor.black.cgColor
        layer.addSublayer(upperLayer)
    }
    override var frame: CGRect{
        didSet {
            updateLayer()
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        if lowerLayer.frame.contains(previousLocation) {
            lowerLayer.highLighted = true
        } else if upperLayer.frame.contains(previousLocation) {
            upperLayer.highLighted = true
        }
        
        return upperLayer.highLighted || lowerLayer.highLighted
        
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(self.bounds.width - thumbWidth)
        previousLocation = location
        if lowerLayer.highLighted {
            lowerValue += deltaValue
            lowerValue = minimumBoundValue(value: lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperLayer.highLighted {
            upperValue += deltaValue
            upperValue = minimumBoundValue(value: upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayer()
        CATransaction.commit()
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerLayer.highLighted = false
        upperLayer.highLighted = false
    }
    func minimumBoundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    func updateLayer() {
    
        trackLayer.frame = self.bounds.insetBy(dx: 0.0, dy: self.bounds.height / 3)
        trackLayer.setNeedsDisplay()
        let lowerThumbCenter = positionValue(value: lowerValue)
        lowerLayer.frame = CGRect(x: (CGFloat(lowerThumbCenter) - (thumbWidth / 2)), y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerLayer.setNeedsDisplay()
        let upperThumbCenter = positionValue(value: upperValue)
        upperLayer.frame = CGRect(x: (CGFloat(upperThumbCenter) - (thumbWidth / 2)), y: 0.0, width: thumbWidth, height: thumbWidth)
        upperLayer.setNeedsDisplay()
    }
    
    func positionValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * value - minimumValue / (maximumValue - minimumValue) + Double(thumbWidth/2.0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class SliderLayer : CALayer {
    var highLighted = false
    weak var slider: Slider?
    
     override func draw(in ctx: CGContext) {
        if let sliderObject = slider {
            let _cornerRadius = self.bounds.height * sliderObject.unknown / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: _cornerRadius)
            ctx.addPath(path.cgPath)
            ctx.setFillColor((slider?.trackTintColor.cgColor)!)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            
            ctx.setFillColor((slider?.trackHighLightTintColor.cgColor)!)
            let lowerValuePosition =  CGFloat((slider?.positionValue(value: (slider?.lowerValue)!))!)
            let higherValuePosition = CGFloat((slider?.positionValue(value: (slider?.upperValue)!))!)
            ctx.fill(CGRect(x: lowerValuePosition, y: 0.0, width: higherValuePosition - lowerValuePosition, height: bounds.height))
        }
    }
}
class SliderThumbLayer : CALayer {
    var highLighted = false
    weak var slider: Slider?
     var editEnable = true
    
    override func draw(in ctx: CGContext) {
        self.slider?.isUserInteractionEnabled = editEnable
        self.slider?.upperLayer.isHidden = !editEnable
        self.slider?.lowerLayer.isHidden = !editEnable
        if let sliderObject = slider {
            let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
            let _cornerRadius = thumbFrame.height * sliderObject.unknown / 2.0
            let path = UIBezierPath(roundedRect: thumbFrame, cornerRadius: _cornerRadius)
            ctx.addPath(path.cgPath)
            ctx.setFillColor((slider?.trackTintColor.cgColor)!)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
        }
    }
}
