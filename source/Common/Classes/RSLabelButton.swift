//
//  RSLabelButton.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 1/2/18.
//

import UIKit

open class RSLabelButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initButton()
    }
    
    private func initButton() {
        self.titleLabel?.font = self.defaultFont
    }
    
    private func setTitleColor(_ color: UIColor?) {
        self.setTitleColor(color, for: UIControl.State.normal)
        self.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        self.setTitleColor(UIColor.white, for: UIControl.State.selected)
        self.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: UIControl.State.disabled)
    }
    
    var configuredColor: UIColor? {
        didSet {
            if let color = self.configuredColor {
                self.setTitleColor(color)
            }
            else {
                self.setTitleColor(self.tintColor)
            }
        }
    }
    
    override open func tintColorDidChange() {
        //if we have not configured the color, set
        super.tintColorDidChange()
        if let _ = self.configuredColor {
            return
        }
        else {
            self.setTitleColor(self.tintColor)
        }
    }
    
    open var defaultFont: UIFont {
        // regular, 14
        return RSLabelButton.defaultFont
    }
    
    open class var defaultFont: UIFont {
        // regular, 14
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.caption1)
        let fontSize: Double = (descriptor.object(forKey: UIFontDescriptor.AttributeName.size) as! NSNumber).doubleValue + 2.0
        return UIFont.systemFont(ofSize: CGFloat(fontSize))
    }

}
