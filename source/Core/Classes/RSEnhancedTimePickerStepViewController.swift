//
//  RSEnhancedTimePickerStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 10/19/18.
//

import UIKit
import ResearchKit

open class RSEnhancedTimePickerStepViewController: RSQuestionViewController {

    var value: Int?
    
    static func getDateForComponents(timeOfDayComponents: DateComponents, date: Date = Date()) -> Date? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return calendar.date(byAdding: timeOfDayComponents, to: startOfDay)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let timePickerStep = self.step as? RSEnhancedTimePickerStep else {
            return
        }
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        
        let dateForComponents: (DateComponents?) -> Date? = { components in
            if let components = components {
                return RSEnhancedTimePickerStepViewController.getDateForComponents(timeOfDayComponents: components)
            }
            else {
                return nil
            }
        }
        
        if let defaultDate = dateForComponents(timePickerStep.defaultComponents) {
            datePicker.setDate(defaultDate, animated: false)
        }
        
        datePicker.maximumDate = dateForComponents(timePickerStep.maximumComponents)
        datePicker.minimumDate = dateForComponents(timePickerStep.minimumComponents)
        
        datePicker.minuteInterval = timePickerStep.minuteInterval ?? 1
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.frame = self.contentView.bounds
        self.contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(UIView())
        
        //
        
//        let answerFormat = textScaleStep.answerFormat
//
//        guard let sliderView = RSSliderView.newView(minimumValue: 0, maximumValue: answerFormat.textChoices.count - 1) else {
//            return
//        }
//
//        sliderView.minValueLabel.text = answerFormat.minValueLabel
//        sliderView.maxValueLabel.text = answerFormat.maxValueLabel
//        sliderView.minValueDescriptionLabel.text = answerFormat.minimumValueDescription
//        sliderView.neutralValueDescriptionLabel.text = answerFormat.neutralValueDescription
//        sliderView.maxValueDescriptionLabel.text = answerFormat.maximumValueDescription
//
//        sliderView.textLabel.text = nil
//
//        sliderView.onValueChanged = { value in
//            self.value = value
//            if value >= 0 && value < answerFormat.textChoices.count {
//                sliderView.currentValueLabel.text = answerFormat.textChoices[value].text
//                self.continueButtonEnabled = true
//            }
//            else {
//                self.continueButtonEnabled = false
//            }
//
//            sliderView.setNeedsLayout()
//            self.contentView.setNeedsLayout()
//
//
//        }
//
//        if let initializedResult = self.initializedResult as? ORKStepResult,
//            let result = initializedResult.firstResult as? ORKChoiceQuestionResult,
//            let choice = result.choiceAnswers?.first as? ORKTextChoice,
//            let index = textScaleStep.answerFormat.textChoices.index(of: choice) {
//            sliderView.setValue(value: index, animated: false)
//        }
//        else {
//            sliderView.setValue(value: answerFormat.defaultIndex, animated: false)
//        }
//
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.frame = self.contentView.bounds
//        self.contentView.addSubview(stackView)
//
//        stackView.addArrangedSubview(sliderView)
//        stackView.addArrangedSubview(UIView())
        
    }
    
    override open func validate() -> Bool {
//        guard let value = self.value,
//            let textScaleStep = self.step as? RSEnhancedTextScaleStep,
//            value >= 0 && value < textScaleStep.answerFormat.textChoices.count else {
//                return false
//        }
        return true
    }
    
    override open var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        if self.hasAppeared,
            let value = self.value,
            let step = self.step as? RSEnhancedTextScaleStep,
            value >= 0 && value < step.answerFormat.textChoices.count {
            
            let choiceResult = ORKChoiceQuestionResult(identifier: step.identifier)
            choiceResult.startDate = parentResult.startDate
            choiceResult.endDate = parentResult.endDate
            choiceResult.choiceAnswers = [step.answerFormat.textChoices[value]]
            
            parentResult.results = [choiceResult]
        }
        
        return parentResult
    }
}
