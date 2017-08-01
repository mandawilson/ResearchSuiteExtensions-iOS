//
//  RSEnhancedInstructionStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/30/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import SwiftyMarkdown
import Mustache

open class RSEnhancedInstructionStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    open var supportedTypes: [String]! {
        return ["RSEnhancedInstructionStep"]
    }
    
    open func registerFormatters(template: Template) {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        
        template.register(percentFormatter,  forKey: "percent")
    }
    
    open var defaultTitleAttributes = [
        NSFontAttributeName: UIFont.preferredFont(forTextStyle: .title1)
    ]
    
    open var defaultTextAttributes = [
        NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline)
    ]
    
    open func generateAttributedString(descriptor: RSTemplatedTextDescriptor, stateHelper: RSTBStateHelper, defaultAttributes: [String : Any]? = nil) -> NSAttributedString? {
        
        var arguments: [String: Any] = [:]
        
        descriptor.arguments.forEach { argumentKey in
            if let value: Any = stateHelper.valueInState(forKey: argumentKey) {
                arguments[argumentKey] = value
            }
        }
        
        var renderedString: String?
        //check for mismatch in argument length
        guard descriptor.arguments.count == arguments.count else {
            return nil
        }
        
        //then pass through handlebars
        do {
            let template = try Template(string: descriptor.template)
            self.registerFormatters(template: template)
            renderedString = try template.render(arguments)
        }
        catch let error {
            debugPrint(error)
            return nil
        }
        
        guard let markdownString = renderedString else {
            return nil
        }
        
        //finally through markdown -> NSAttributedString
//        let attributedString = TSMarkdownParser.standard().attributedString(fromMarkdown: markdownString, attributes: defaultAttributes)
//        debugPrint(TSMarkdownParser.standard().strongAttributes)
        
        let md = SwiftyMarkdown(string: markdownString)
        md.h1.fontName = UIFont.preferredFont(forTextStyle: .title1).fontName
        let attributedString = md.attributedString()
        
        debugPrint(attributedString)
        return attributedString
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSEnhancedInstructionStepDescriptor(json:jsonObject),
            let stateHelper = helper.stateHelper else {
                return nil
        }
        
        let step = RSEnhancedInstructionStep(identifier: stepDescriptor.identifier)
        step.title = stepDescriptor.title
        step.text = stepDescriptor.text
        step.detailText = stepDescriptor.detailText
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, stateHelper: stateHelper, defaultAttributes: defaultTitleAttributes)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, stateHelper: stateHelper, defaultAttributes: defaultTextAttributes)
        }
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    

}
