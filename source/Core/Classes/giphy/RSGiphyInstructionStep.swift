//
//  RSGiphyInstructionStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 1/24/19.
//

import UIKit
import ResearchKit

open class RSGiphyInstructionStep: RSStep {
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSGiphyInstructionStepViewController.self
    }
    
    open var gifID: String?
    open var giphyAPIKey: String?
    
}
