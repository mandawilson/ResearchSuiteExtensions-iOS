//
//  RSEnhancedDateTimePickerStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/27/19.
//

import UIKit
import ResearchKit

open class RSEnhancedDateTimePickerStepViewController: RSQuestionViewController {
    
    var datePicker: UIDatePicker?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dateTimePickerStep = self.step as? RSEnhancedDateTimePickerStep else {
            return
        }
        
        let datePicker = UIDatePicker()
        self.datePicker = datePicker
        datePicker.datePickerMode = .dateAndTime
        
        datePicker.minuteInterval = dateTimePickerStep.minuteInterval ?? 1
        
        datePicker.maximumDate = dateTimePickerStep.maximumDate
        datePicker.minimumDate = dateTimePickerStep.minimumDate
        
        let initialDate = dateTimePickerStep.defaultDate ?? Date()
        datePicker.setDate(initialDate, animated: false)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.frame = self.contentView.bounds
        self.contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(UIView())
        
    }
    
    override open var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        
        if self.hasAppeared,
            let step = self.step,
            let pickerDate = self.datePicker?.date {

            let dateResult = ORKDateQuestionResult(identifier: step.identifier)
            dateResult.dateAnswer = pickerDate
            dateResult.startDate = parentResult.startDate
            dateResult.endDate = parentResult.endDate
            
            parentResult.results = [dateResult]
        }
        
        return parentResult
    }
}
