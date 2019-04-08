//
//  RSEnhancedScaleStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/26/18.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder
import ResearchKit

open class RSEnhancedScaleStepGenerator: RSTBBaseStepGenerator, RSTBAnswerFormatGenerator {
    public func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    public func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    public init(){}
    
    let _supportedTypes = [
        "enhancedScale"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
//    open func generateChoices(items: [RSTBChoiceItemDescriptor]) -> [ORKTextChoice] {
//
//        return items.map { item in
//
//            return ORKTextChoice(
//                text: helper.localizationHelper.localizedString(item.text),
//                detailText: helper.localizationHelper.localizedString(item.detailText),
//                value: item.value,
//                exclusive: item.exclusive)
//        }
//    }
    
    open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        
        guard let stepDescriptor = RSEnhancedScaleStepDescriptor(json: jsonObject) else {
            return nil
        }

        let numberFormatter: NumberFormatter? = {
            if stepDescriptor.percentage {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .percent
                numberFormatter.multiplier = 1.0
                return numberFormatter
            }
            else {
                return nil
            }
        }()
        
        let answerFormat = RSEnhancedScaleAnswerFormat(
            maximumValue: stepDescriptor.maximumValue,
            minimumValue: stepDescriptor.minimumValue,
            defaultValue: stepDescriptor.defaultValue,
            stepValue: stepDescriptor.stepValue,
            vertical: stepDescriptor.vertical,
            maxValueLabel: helper.localizationHelper.localizedString(stepDescriptor.maximumValueLabel),
            minValueLabel: helper.localizationHelper.localizedString(stepDescriptor.minimumValueLabel),
            maximumValueDescription: helper.localizationHelper.localizedString(stepDescriptor.maximumValueDescription),
            neutralValueDescription: helper.localizationHelper.localizedString(stepDescriptor.neutralValueDescription),
            minimumValueDescription: helper.localizationHelper.localizedString(stepDescriptor.minimumValueDescription),
            numberFormatter: numberFormatter
        )
        
        return answerFormat
        
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper, identifierPrefix: String) -> [ORKStep]? {
        guard let answerFormat = self.generateAnswerFormat(type: type, jsonObject: jsonObject, helper: helper) as? RSEnhancedScaleAnswerFormat,
            let stepDescriptor = RSEnhancedScaleStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        let identifier = "\(identifierPrefix).\(stepDescriptor.identifier)"
        
        let step = RSEnhancedScaleStep(identifier: identifier, answerFormat: answerFormat, autoAdvance: stepDescriptor.autoAdvance)
        step.title = helper.localizationHelper.localizedString(stepDescriptor.title)
        step.text = helper.localizationHelper.localizedString(stepDescriptor.text)
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, helper: helper)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, helper: helper)
        }
        
        step.isOptional = stepDescriptor.optional
        return [step]
        
    }

}
