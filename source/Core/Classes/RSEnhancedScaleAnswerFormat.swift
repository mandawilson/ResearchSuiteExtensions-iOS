//
//  RSEnhancedScaleAnswerFormat.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/26/18.
//

import UIKit
import ResearchKit

open class RSEnhancedScaleAnswerFormat: ORKScaleAnswerFormat {
    
    public let maxValueLabel: String?
    public let minValueLabel: String?
    public let neutralValueDescription: String?
    public let _numberFormatter: NumberFormatter?
    
    override open var numberFormatter: NumberFormatter {
        return self._numberFormatter ?? super.numberFormatter
    }
    
    public init(
        maximumValue: Int,
        minimumValue: Int,
        defaultValue: Int,
        stepValue: Int,
        vertical: Bool,
        maxValueLabel: String?,
        minValueLabel: String?,
        maximumValueDescription: String?,
        neutralValueDescription: String?,
        minimumValueDescription: String?,
        numberFormatter: NumberFormatter?
        ) {
        self.maxValueLabel = maxValueLabel
        self.minValueLabel = minValueLabel
        self.neutralValueDescription = neutralValueDescription
        self._numberFormatter = numberFormatter
        
        super.init(
            maximumValue: maximumValue,
            minimumValue: minimumValue,
            defaultValue: defaultValue,
            step: stepValue,
            vertical: vertical,
            maximumValueDescription: maximumValueDescription,
            minimumValueDescription: minimumValueDescription
        )
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
