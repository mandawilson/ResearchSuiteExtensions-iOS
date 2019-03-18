//
//  RSFullScreenImageStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/6/19.
//

import UIKit
import ResearchKit

open class RSFullScreenImageStep: RSStep {
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSFullScreenImageStepViewController.self
    }
    
    open var image: UIImage!
    
}
