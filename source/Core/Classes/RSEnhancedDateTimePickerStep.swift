//
//  RSEnhancedDateTimePickerStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/27/19.
//

import UIKit

open class RSEnhancedDateTimePickerStep: RSStep {
    
    open override func stepViewControllerClass() -> AnyClass {
        return RSEnhancedDateTimePickerStepViewController.self
    }
    
    public let defaultDate: Date?
    public let minimumDate: Date?
    public let maximumDate: Date?
    
    public let minuteInterval: Int?
    
    public init(
        identifier: String,
        defaultDate: Date?,
        minimumDate: Date?,
        maximumDate: Date?,
        minuteInterval: Int?
        ) {
        self.defaultDate = defaultDate
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.minuteInterval = minuteInterval
        super.init(identifier: identifier)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
