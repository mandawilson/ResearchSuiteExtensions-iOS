//
//  RSEnhancedTextScaleAnswerFormat.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedTextScaleAnswerFormat: ORKTextScaleAnswerFormat {
    
    public let maxValueLabel: String?
    public let minValueLabel: String?
    public let maximumValueDescription: String?
    public let neutralValueDescription: String?
    public let minimumValueDescription: String?
    public let valueLabelHeight: Int?
    
    public init(
        textChoices: [ORKTextChoice],
        defaultIndex: Int,
        vertical: Bool,
        maxValueLabel: String?,
        minValueLabel: String?,
        maximumValueDescription: String?,
        neutralValueDescription: String?,
        minimumValueDescription: String?,
        valueLabelHeight: Int?
        ) {
        self.maxValueLabel = maxValueLabel
        self.minValueLabel = minValueLabel
        self.maximumValueDescription = maximumValueDescription
        self.neutralValueDescription = neutralValueDescription
        self.minimumValueDescription = minimumValueDescription
        self.valueLabelHeight = valueLabelHeight
        
        super.init(textChoices: textChoices, defaultIndex: defaultIndex, vertical: vertical)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
