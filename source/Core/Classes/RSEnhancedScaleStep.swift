//
//  RSEnhancedScaleStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/26/18.
//

import UIKit
import ResearchKit

class RSEnhancedScaleStep: RSStep {
    
    let answerFormat: ORKAnswerFormat
    let autoAdvance: Bool
    open override func stepViewControllerClass() -> AnyClass {
        return RSEnhancedScaleStepViewController.self
    }
    
    public init(identifier: String, answerFormat: ORKAnswerFormat, autoAdvance: Bool) {
        self.answerFormat = answerFormat
        self.autoAdvance = autoAdvance
        super.init(identifier: identifier)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
