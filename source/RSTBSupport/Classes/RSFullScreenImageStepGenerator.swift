//
//  RSFullScreenImageStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/6/19.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import SwiftyMarkdown
import Mustache
import SwiftyGif

open class RSFullScreenImageStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    open var supportedTypes: [String]! {
        return ["fullScreenImage"]
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSFullScreenImageStepDescriptor(json:jsonObject),
            let image = UIImage(named: stepDescriptor.imageTitle) else {
                return nil
        }
        
        let step = RSFullScreenImageStep(identifier: stepDescriptor.identifier)
        step.image = image
        step.buttonText = stepDescriptor.buttonText
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    
    
}
