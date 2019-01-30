//
//  RSEnhancedTextScaleStep.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedTextScaleStep: RSStep {
    
    let answerFormat: RSEnhancedTextScaleAnswerFormat
    let autoAdvance: Bool
    
    open override func stepViewControllerClass() -> AnyClass {
        return RSEnhancedTextScaleStepViewController.self
    }
    
    public init(identifier: String, answerFormat: RSEnhancedTextScaleAnswerFormat, autoAdvance: Bool) {
        self.answerFormat = answerFormat
        self.autoAdvance = autoAdvance
        super.init(identifier: identifier)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
