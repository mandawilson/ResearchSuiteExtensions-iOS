//
//  RSEnhancedDateTimePickerStepDescriptor.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/27/19.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchKit

open class RSEnhancedDateTimePickerStepDescriptor: RSTBDateTimePickerStepDescriptor {
    
    public let buttonText: String?
    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    
    public let minuteInterval: Int?
    
    public required init?(json: JSON) {
        
        self.buttonText = "buttonText" <~~ json
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json

        self.minuteInterval = "minuteInterval" <~~ json
        
        super.init(json: json)
        
    }
    
}
