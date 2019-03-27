
//
//  RSEnhancedDateTimePickerStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/27/19.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder
import ResearchKit

open class RSEnhancedDateTimePickerStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "enhancedDateTimePicker"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper, identifierPrefix: String) -> [ORKStep]? {
        guard let stepDescriptor = RSEnhancedDateTimePickerStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let identifier = "\(identifierPrefix).\(stepDescriptor.identifier)"
        
        let step = RSEnhancedDateTimePickerStep(
            identifier: identifier,
            defaultDate: stepDescriptor.defaultDate,
            minimumDate: stepDescriptor.minimumDate,
            maximumDate: stepDescriptor.maximumDate,
            minuteInterval: stepDescriptor.minuteInterval
        )
        
        step.title = helper.localizationHelper.localizedString(stepDescriptor.title)
        step.text = helper.localizationHelper.localizedString(stepDescriptor.text)
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, helper: helper)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, helper: helper)
        }
        
        if let buttonText = stepDescriptor.buttonText {
            step.buttonText = buttonText
        }
        
        step.isOptional = stepDescriptor.optional
        return [step]
        
    }
    
    public func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
