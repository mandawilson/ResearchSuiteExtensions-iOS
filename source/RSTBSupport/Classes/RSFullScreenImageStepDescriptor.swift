//
//  RSFullScreenImageStepDescriptor.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/6/19.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSFullScreenImageStepDescriptor: RSTBStepDescriptor {
    
    public let imageTitle: String
    public let buttonText: String?
    
    required public init?(json: JSON) {
        
        guard let imageTitle: String = "image" <~~ json else {
            return nil
        }
        
        self.imageTitle = imageTitle
        self.buttonText = "buttonText" <~~ json
        super.init(json: json)
        
    }
    
}
