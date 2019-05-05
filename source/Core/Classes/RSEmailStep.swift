//
//  RSEmailStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/7/18.
//

import UIKit

open class RSEmailStep: RSStep {

    public let recipientAddreses: [String]
    public let messageSubject: String?
    public let messageBody: String?
    public let errorMessage: String?
    public let bodyIsHTML: Bool
    
    public init(
        identifier: String,
        recipientAddreses: [String],
        messageSubject: String?,
        messageBody: String?,
        bodyIsHTML: Bool,
        errorMessage: String,
        buttonText: String
    ) {
        
        self.recipientAddreses = recipientAddreses
        self.messageSubject = messageSubject
        self.messageBody = messageBody
        self.bodyIsHTML = bodyIsHTML
        self.errorMessage = errorMessage
        super.init(identifier: identifier)
        
        self.buttonText = buttonText
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSEmailStepViewController.self
    }
    
}
