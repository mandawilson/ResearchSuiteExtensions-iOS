//
//  RSEnhancedMultipleChoiceCellWithTextFieldAccessoryController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/25/18.
//

import UIKit
import ResearchKit

open class RSEnhancedMultipleChoiceCellWithTextFieldAccessoryController: RSEnhancedMultipleChoiceBaseCellController, UITextFieldDelegate {
    
    open override var isValid: Bool {
        return false
    }
    
    open override func viewForAuxiliaryItem(item: ORKFormItem, cell: RSEnhancedMultipleChoiceCell) -> UIView? {
        return nil
    }
    
    private var currentText: String?
    
    public override init?(textChoice: RSTextChoiceWithAuxiliaryAnswer, choiceSelection: RSEnahncedMultipleChoiceSelection?, onValidationFailed: ((String) -> ())?, onAuxiliaryItemResultChanged: (() -> ())?) {
        
        switch(choiceSelection?.auxiliaryResult) {
        case .some(let textResult as ORKTextQuestionResult):
            self.currentText = textResult.textAnswer
            
        case .some(let numericResult as ORKNumericQuestionResult):
            if let numericAnswer = numericResult.numericAnswer {
                self.currentText = String(describing: numericAnswer)
            }
        default:
            break
        }
        super.init(textChoice: textChoice, choiceSelection: choiceSelection, onValidationFailed: onValidationFailed, onAuxiliaryItemResultChanged: onAuxiliaryItemResultChanged)
        
    }
    
    //delegate
    open func textFieldDidEndEditing(_ textField: UITextField) {
//        self.delegate?.auxiliaryTextFieldDidEndEditing(textField, forCellId: self.identifier)
//        if !self.selected.contains(id) {
//            self.updateUI()
//            return
//        }
        
        assert(self.hasAuxiliaryItem)
        
        if !self.isSelected {
            return
        }
        
        //emtpy should be considered valid in all cases
        if let text = textField.text,
            text.count > 0 {
            
            self.currentText = textField.text
            
            //validate
            //if passes, convert into result
            //otherwise, throw message
            
            if self.validate(text: text) {
                self.validatedResult = self.convertToResult(text: text)
            }
            else {
                self.validatedResult = nil
            }
            
        }
        else {
            
            //clear the
            //is this empty?
//            self.currentText[id] = textField.text
            self.currentText = textField.text
            if !self.isAuxiliaryItemOptional! {
                self.showValidityAlertMessage(message: "The field associated with choice \"\(textChoice.text)\" is required.")
            }
        }
        
//        self.updateUI()
    }
    //delegate
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let startingText = textField.text {
            
            let start = startingText.index(startingText.startIndex, offsetBy: range.location)
            let end = startingText.index(startingText.startIndex, offsetBy: range.location + range.length)
            let stringRange = start..<end
            let text = startingText.replacingCharacters(in: stringRange, with: string)
            let textWithoutNewlines = text.components(separatedBy: CharacterSet.newlines).joined(separator: "")
            
            if self.validateTextForLength(text: textWithoutNewlines) == false {
                //                self.updateUI()
                return false
            }
            
            //set the state of text
            self.currentText = textWithoutNewlines
        }
        //        self.updateUI()
        return true
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.currentText = nil
//        self.updateUI()
        return true
       
    }

    func showValidityAlertMessage(message: String) {
        self.onValidationFailed?(message)
    }
    
    func convertToResult(text: String) -> ORKResult? {
        
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat else {
                return nil
        }
        
        switch(answerFormat) {
        case _ as ORKTextAnswerFormat:
            
            let result = ORKTextQuestionResult(identifier: auxItem.identifier)
            result.textAnswer = text
            return result
            
        case _ as ORKEmailAnswerFormat:
            
            let result = ORKTextQuestionResult(identifier: auxItem.identifier)
            result.textAnswer = text
            return result
            
        case let answerFormat as ORKNumericAnswerFormat:
            
            if answerFormat.style == .decimal {
                if let answer = Double(text) {
                    let result = ORKNumericQuestionResult(identifier: auxItem.identifier)
                    result.numericAnswer = NSNumber(floatLiteral: answer)
                    result.unit = answerFormat.unit
                    return result
                }
            }
            else {
                if let answer = Int(text) {
                    let result = ORKNumericQuestionResult(identifier: auxItem.identifier)
                    result.numericAnswer = NSNumber(integerLiteral: answer)
                    result.unit = answerFormat.unit
                    return result
                }
            }
            return nil
        default:
            return nil
        }
    }
    
    func validate(text: String) -> Bool {
        
        guard let auxItem = self.auxiliaryItem else {
            self.showValidityAlertMessage(message: "An eror occurred")
            return false
        }
        
        switch auxItem.answerFormat {
            
        case _ as ORKTextAnswerFormat:
            return self.validateTextForLength(text: text) && self.validateTextForRegEx(text: text)
            
        case _ as ORKEmailAnswerFormat:
            return self.validateTextForLength(text: text) && self.validateTextForRegEx(text: text)
            
        case _ as ORKNumericAnswerFormat:
            return self.validateNumericTextForRange(text: text)
            
        default:
            self.showValidityAlertMessage(message: "An eror occurred")
            return false
            
        }
    }
    
    //MARK: Validation Functions
    //returns true for empty text
    open func validateTextForRegEx(text: String) -> Bool {
        
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat as? ORKTextAnswerFormat,
            let regex = answerFormat.validationRegularExpression,
            let invalidMessage = answerFormat.invalidMessage else {
                return true
        }
        
        let matchCount = regex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        if matchCount != 1 {
            self.showValidityAlertMessage(message: invalidMessage)
            return false
        }
        return true
    }
    
    open func validateTextForLength(text: String) -> Bool {
        
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat as? ORKTextAnswerFormat,
            answerFormat.maximumLength > 0 else {
                return true
        }
        
        if text.count > answerFormat.maximumLength {
            self.showValidityAlertMessage(message: "Text content exceeding maximum length: \(answerFormat.maximumLength)")
            return false
        }
        else {
            return true
        }
        
    }
    
    open func validateNumericTextForRange(text: String) -> Bool {
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat as? ORKNumericAnswerFormat else {
                return true
        }
        
        if answerFormat.style == ORKNumericAnswerStyle.decimal,
            let decimalAnswer = Double(text) {
            
            if let minValue = answerFormat.minimum?.doubleValue,
                decimalAnswer < minValue {
                self.showValidityAlertMessage(message: "\(decimalAnswer) is less than the minimum allowed value \(minValue).")
                return false
            }
            
            if let maxValue = answerFormat.maximum?.doubleValue,
                decimalAnswer > maxValue {
                self.showValidityAlertMessage(message: "\(decimalAnswer) is more than the maximum allowed value \(maxValue).")
                return false
            }
            
            return true
        }
        else if answerFormat.style == ORKNumericAnswerStyle.integer,
            let integerAnswer = Int(text)  {
            
            if let minValue = answerFormat.minimum?.intValue,
                integerAnswer < minValue {
                self.showValidityAlertMessage(message: "\(integerAnswer) is less than the minimum allowed value \(minValue).")
                return false
            }
            
            if let maxValue = answerFormat.maximum?.intValue,
                integerAnswer > maxValue {
                self.showValidityAlertMessage(message: "\(integerAnswer) is more than the maximum allowed value \(maxValue).")
                return false
            }
            
            return true
        }
        else {
            return true
        }
    }
    
}
