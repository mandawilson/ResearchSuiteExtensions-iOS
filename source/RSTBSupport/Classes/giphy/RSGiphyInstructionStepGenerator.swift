//
//  RSGiphyInstructionStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 1/24/19.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import SwiftyMarkdown
import Mustache
import SwiftyGif

open class RSGiphyInstructionStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    open var supportedTypes: [String]! {
        return ["giphyInstruction"]
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSGiphyInstructionStepDescriptor(json:jsonObject) else {
                return nil
        }
        
        let step = RSGiphyInstructionStep(identifier: stepDescriptor.identifier)
        step.title = helper.localizationHelper.localizedString(stepDescriptor.title)
        step.text = helper.localizationHelper.localizedString(stepDescriptor.text)

        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, helper: helper)
        }

        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, helper: helper)
        }

        if let buttonText = stepDescriptor.buttonText {
            step.buttonText = helper.localizationHelper.localizedString(buttonText)
        }

        step.gifID = stepDescriptor.gifID
        step.giphyAPIKey = helper.stateHelper?.valueInState(forKey: stepDescriptor.apiTokenKey) as? String

        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    
    
}
