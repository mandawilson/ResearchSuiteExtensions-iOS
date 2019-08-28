//
//  RSSlider.swift
//  Pods
//
//  Created by James Kizer on 8/3/17.
//
//

import UIKit
import SnapKit

open class RSSlider: UISlider {
    
    static let LineWidth: CGFloat = 1.0
    static let LineHeight: CGFloat = 4.0
    
    var numberLabels: [UILabel] = []
    var showNumbersAboveTicks = false {
        didSet {
            if !showNumbersAboveTicks {
                numberLabels.forEach { $0.removeFromSuperview() }
                numberLabels = []
            }
        }
    }
    
    func centerXForValue(value: Int, trackRect: CGRect) -> CGFloat? {
        
        let valueOffset = Float(value) - self.minimumValue
        let maximumOffset = self.maximumValue - self.minimumValue
        let offsetPercentage: CGFloat = CGFloat(valueOffset / maximumOffset)
        
        var x: CGFloat = trackRect.origin.x + ((trackRect.size.width - RSSlider.LineWidth) * offsetPercentage)
        
        x = x + (RSSlider.LineWidth / 2)
        
        return x
        
    }
    
    override open func draw(_ rect: CGRect) {
        
        let bounds = self.bounds
        let trackRect = self.trackRect(forBounds: bounds)
        
        let centerY = bounds.size.height / 2.0
        
        UIColor.black.set()
        
        let path = UIBezierPath()
        path.lineWidth = RSSlider.LineWidth
        
        let minimumValue = Int(round(self.minimumValue))
        let maximumValue = Int(round(self.maximumValue))
        
        //only mark values based on step size
        assert( (maximumValue - minimumValue) % self.stepSize == 0)
        let filteredRange = (minimumValue...maximumValue).filter { value in
            let offset = value - minimumValue
            return offset % self.stepSize == 0
        }
        
        filteredRange.forEach { (value) in
            
            if let centerX = self.centerXForValue(value: value, trackRect: trackRect) {
                path.move(to: CGPoint(x: centerX, y: centerY - RSSlider.LineHeight))
                path.addLine(to: CGPoint(x: centerX, y: centerY + RSSlider.LineHeight))
                
                if showNumbersAboveTicks {
                    let label = UILabel()
                    label.text = String(value)
                    
                    let center = CGPoint(x: centerX-1, y: 0)
                    self.addSubview(label)
                    label.snp.makeConstraints { (make) in
                        make.center.equalTo(center)
                    }
                    numberLabels = numberLabels + [label]
                }
            }
            
            
            
        }
        
        path.stroke()
        
        UIBezierPath.init(rect: trackRect).fill()
        
//        if showNumbersAboveTicks {
//            let bounds = self.bounds
//            let trackRect = self.trackRect(forBounds: bounds)
//
//            let minimumValue = Int(round(self.minimumValue))
//            let maximumValue = Int(round(self.maximumValue))
//
//            let filteredRange = (minimumValue...maximumValue).filter { value in
//                let offset = value - minimumValue
//                return offset % self.stepSize == 0
//            }
//
//            filteredRange.forEach { (value) in
//
//                let centerY = bounds.size.height
//
//                if let centerX = self.centerXForValue(value: value, trackRect: trackRect) {
//
//                    let label = UILabel()
//                    label.text = String(value)
//
//                    let center = CGPoint(x: centerX, y: centerY)
//                    self.addSubview(label)
//                    label.snp.makeConstraints { (make) in
//                        make.center.equalTo(center)
//                    }
//                    numberLabels = numberLabels + [label]
//                }
//            }
//        }
//        else {
//            numberLabels.forEach { $0.removeFromSuperview() }
//            numberLabels = []
//        }
    }
    
    open var showThumb = false
    open var stepSize: Int!
    
    open override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        
        var thumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        
        if !self.showThumb {
            thumbRect.origin.x = 1000
        }
        else {
            if let centerX = self.centerXForValue(value: Int(round(value)), trackRect: rect) {
                thumbRect.origin.x = centerX - (thumbRect.size.width / 2.0)
            }
            
        }
        
        return thumbRect
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.trackRect(forBounds: bounds)
        return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: 1)
    }
    
}
