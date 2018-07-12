//
//  RSEnhancedMultipleChoiceStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import Gloss
import ResearchSuiteTaskBuilder

open class RSAllowsEmptySelectionAlert: Gloss.JSONDecodable {
    
    public let title: String
    public let text: String?
    public let cancelText: String
    public let continueText: String
    
    required public init?(json: JSON) {
        
        guard let title: String = "title" <~~ json else {
            return nil
        }
        
        self.title = title
        self.text = "text" <~~ json
        self.cancelText = "cancelText" <~~ json ?? "Cancel"
        self.continueText = "continueText" <~~ json ?? "Cancel"
    }
    
}

public struct RSEnhancedMultipleChoiceAllowsEmptySelectionDescriptor: Gloss.JSONDecodable {
    
    public let allowed: Bool
    public let confirmationAlert: RSAllowsEmptySelectionAlert?
    
    public init?(json: JSON) {
        
        self.allowed = "allowed" <~~ json ?? false
        self.confirmationAlert = "confirmation" <~~ json
        
    }
    
    
}

open class RSEnhancedMultipleChoiceStepDescriptor: RSTBChoiceStepDescriptor<RSEnhancedChoiceItemDescriptor> {

    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    public let allowsEmptySelection: RSEnhancedMultipleChoiceAllowsEmptySelectionDescriptor?
    
    required public init?(json: JSON) {
        
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        self.allowsEmptySelection = "allowsEmptySelection" <~~ json
        
        super.init(json: json)
    }
    
}

