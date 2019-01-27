//
//  RSGiphyInstructionStepDescriptor.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 1/24/19.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSGiphyInstructionStepDescriptor: RSTBInstructionStepDescriptor {
    
    public let buttonText: String?
    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    public let gifID: String
    public let apiTokenKey: String
    
    required public init?(json: JSON) {
        
        guard let apiTokenKey: String = "apiTokenKey" <~~ json else {
            return nil
        }
        
        let gifIDOpt: String? = {
            if let gifIDJSON: JSON = "gifID" <~~ json,
                let urlArray: [String] = "selectOne" <~~ gifIDJSON {
                return urlArray.random()
            }
            else {
                return "gifID" <~~ json
            }
        }()
        
        guard let gifID = gifIDOpt else {
            return nil
        }
        
        self.apiTokenKey = apiTokenKey
        self.buttonText = "buttonText" <~~ json
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        self.gifID = gifID
        
        super.init(json: json)
    }
    
}
