//
//  RSEnhancedMultipleChoiceStepViewController.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedMultipleChoiceStepViewController: RSQuestionTableViewController {

    static let EmailValidationRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    
    var enhancedMultiChoiceStep: RSEnhancedMultipleChoiceStep!
    
    var cellControllerMap: [Int: RSEnhancedMultipleChoiceCellController]!
    
    var selected: Set<Int> {
        
        let selectedControllers: [Int: RSEnhancedMultipleChoiceCellController]  = self.cellControllerMap.filter { (pair) -> Bool in
            return pair.1.isSelected
        }
        
        return Set(selectedControllers.keys)
        
    }
    
    var auxiliaryResultOptional: Set<Int>! {
        
        let selectedControllers: [Int: RSEnhancedMultipleChoiceCellController]  = self.cellControllerMap.filter { (pair) -> Bool in
            
            if let auxItem = pair.1.auxiliaryItem {
                return auxItem.isOptional
            }
            else {
                return true
            }
            
        }
        
        return Set(selectedControllers.keys)
    
    }
    
//    var auxiliaryResultForIndex: [Int: ORKResult]!
    var validatedAuxiliaryResultForIndex: [Int: ORKResult]! {
        var auxResults: [Int: ORKResult] = [:]
        
        self.cellControllerMap.forEach { (pair) in
            
            if let result = pair.value.auxiliaryItemResult {
                auxResults[pair.key] = result
            }
            
        }
        
        return auxResults
    }
    
//    var currentText: [Int: String]!
    
    convenience init(step: ORKStep?) {
        self.init(step: step, result: nil)
    }
    
    func generateCellController(for textChoice: RSTextChoiceWithAuxiliaryAnswer, choiceSelection: RSEnahncedMultipleChoiceSelection?) -> RSEnhancedMultipleChoiceCellController? {
        
        let onValidationFailed: (String) -> () = { message in
            self.showValidityAlertMessage(message: message )
        }
        
        let onAuxiliaryItemResultChanged:(() -> ()) = {
            self.updateUI()
        }
        
        switch textChoice.auxiliaryItem?.answerFormat {
        case .some(_ as RSEnhancedScaleAnswerFormat):
            return RSEnhancedMultipleChoiceCellWithNumericScaleAccessoryController(
                textChoice: textChoice,
                choiceSelection: choiceSelection,
                onValidationFailed: onValidationFailed,
                onAuxiliaryItemResultChanged: onAuxiliaryItemResultChanged
            )
            
        case .some(_ as RSEnhancedTextScaleAnswerFormat):
            return RSEnhancedMultipleChoiceCellWithTextScaleAccessoryController(
                textChoice: textChoice,
                choiceSelection: choiceSelection,
                onValidationFailed: onValidationFailed,
                onAuxiliaryItemResultChanged: onAuxiliaryItemResultChanged
            )
            
        case .some(_ as ORKTextAnswerFormat):
            fallthrough
        case .some(_ as ORKEmailAnswerFormat):
            fallthrough
        case .some(_ as ORKNumericAnswerFormat):
            return RSEnhancedMultipleChoiceCellWithTextFieldAccessoryController(
                textChoice: textChoice,
                choiceSelection: choiceSelection,
                onValidationFailed: onValidationFailed,
                onAuxiliaryItemResultChanged: onAuxiliaryItemResultChanged
            )
            
        default:
            return RSEnhancedMultipleChoiceBaseCellController(
                textChoice: textChoice,
                choiceSelection: choiceSelection,
                onValidationFailed: onValidationFailed,
                onAuxiliaryItemResultChanged: onAuxiliaryItemResultChanged
            )
            
        }
    }
    
    convenience init(step: ORKStep?, result: ORKResult?) {
        
        let framework = Bundle(for: RSQuestionTableViewController.self)
        self.init(nibName: "RSQuestionTableViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        
        self.enhancedMultiChoiceStep = step as! RSEnhancedMultipleChoiceStep
        
        
        guard let answerFormat = self.enhancedMultiChoiceStep.answerFormat,
            let textChoices = answerFormat.textChoices as? [RSTextChoiceWithAuxiliaryAnswer] else {
                assertionFailure("Text choices must be of type RSTextChoiceWithAuxiliaryAnswer")
                return
        }
        
        let stepResult: ORKStepResult? = result as? ORKStepResult
        let choiceResult: RSEnhancedMultipleChoiceResult? = stepResult?.results?.first as? RSEnhancedMultipleChoiceResult
        
        var cellControllerMap: [Int: RSEnhancedMultipleChoiceCellController] = [:]
        
        textChoices.enumerated().forEach { offset, textChoice in
            
            cellControllerMap[offset] = self.generateCellController(for: textChoice, choiceSelection: choiceResult?.choiceAnswer(for: textChoice.identifier) )
            
        }
        
        self.cellControllerMap = cellControllerMap
//
//        //compute the set of optional selections
//        if let textChoices = self.enhancedMultiChoiceStep.answerFormat?.textChoices {
//            //if regular text choice, optional is true
//            //if RSTextChoiceWithAuxiliaryAnswer, but auxiliaryItem is nil, optional is true
//            //if RSTextChoiceWithAuxiliaryAnswer and auxiliaryItem is optional, optional is true
//            let optionalIndexes: [Int] = textChoices.enumerated().filter { offset, textChoice in
//
//                if let textChoiceWithAux = textChoice as? RSTextChoiceWithAuxiliaryAnswer,
//                    let formItem = textChoiceWithAux.auxiliaryItem {
//                    return formItem.isOptional
//                }
//
//                return true
//                }.map { offset, textChoice in return offset }
//
//            self.auxiliaryResultOptional = Set(optionalIndexes)
//        }
//
//
//
//        //configure based on result result
//        if let stepResult = result as? ORKStepResult,
//            let choiceResult = stepResult.results?.first as? RSEnhancedMultipleChoiceResult,
//            let choiceAnswers = choiceResult.choiceAnswers {
//            //set selected
//
////            var selected: Set<Int> = Set()
////            var auxiliaryResultForIndex: [Int: ORKResult] = [:]
//            var initialText: [Int: String] = [:]
//            choiceAnswers.forEach({ (choiceSelection) in
//
//                if let index = self.index(value: choiceSelection.value) {
//                    selected = selected.union(Set([index]))
//                    if let auxiliaryResult = choiceSelection.auxiliaryResult {
//
//                        switch(auxiliaryResult) {
//                        case let textResult as ORKTextQuestionResult:
//                            initialText[index] = textResult.textAnswer
//                            auxiliaryResultForIndex[index] = auxiliaryResult
//
//                        case let numericResult as ORKNumericQuestionResult:
//                            if let numericAnswer = numericResult.numericAnswer {
//                                initialText[index] = String(describing: numericAnswer)
//                                auxiliaryResultForIndex[index] = auxiliaryResult
//                            }
//
//                        case _ as ORKChoiceQuestionResult:
//                            auxiliaryResultForIndex[index] = auxiliaryResult
//
//                        default:
//                            break
//                        }
//                    }
//                }
//
//            })
//
////            self.selected = selected
////            self.validatedAuxiliaryResultForIndex = auxiliaryResultForIndex
//            self.currentText = initialText
//        }
//        else {
////            self.selected = Set()
////            self.validatedAuxiliaryResultForIndex = [:]
//            self.currentText = [:]
//        }
//
//
//
        
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()

//        let enhancedMultiNIB = UINib(nibName: "RSEnhancedMultipleChoiceCellWithTextFieldAccessory", bundle: Bundle(for: RSEnhancedMultipleChoiceStepViewController.self))
//        self.tableView.register(enhancedMultiNIB, forCellReuseIdentifier: "enhanced_multi_choice")
        
        let enhancedMultiWithAccessoryNIB = UINib(nibName: "RSEnhancedMultipleChoiceCell", bundle: Bundle(for: RSEnhancedMultipleChoiceStepViewController.self))
        self.tableView.register(enhancedMultiWithAccessoryNIB, forCellReuseIdentifier: "enhanced_multi_choice")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        // Do any additional setup after loading the view.
        guard let enhancedMultiChoiceStep = step as? RSEnhancedMultipleChoiceStep,
            let answerFormat = enhancedMultiChoiceStep.answerFormat else {
            return
        }
        
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = answerFormat.style == .multipleChoice
        
        self.selected.forEach( { index in
            self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none )
        })
        
        
        self.updateUI()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.visibleCells.forEach { $0.setNeedsLayout() }
    }
    
    func updateUI() {
        if let selectedPaths = self.tableView.indexPathsForSelectedRows,
            selectedPaths.count > 0 {
            
            //for each selected value, need to see if the aux result is optional or not,
            //check to see if we have a result if it is
            
            //we can do this via set math
            //iff selected set - optional set - results set = 0, we should be good
//            let indicesWithText = self.currentText.filter{ index, value in
//
//                return value.count > 0
//
//                }.map { index, value in return index}
//
//            let remainingSet = self.selected.subtracting(self.auxiliaryResultOptional).subtracting(indicesWithText)
            
            
            let invalidCellControllers = self.cellControllerMap.values.filter { $0.isSelected && !$0.isValid }
            
            self.continueButton.isEnabled = invalidCellControllers.count == 0
        }
        else {
            self.continueButton.isEnabled = false
        }
        
        
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.enhancedMultiChoiceStep.answerFormat?.textChoices.count ?? 0
    }
    
//    open func textChoice(id: Int) -> RSTextChoiceWithAuxiliaryAnswer? {
//
//        guard let textChoices = self.enhancedMultiChoiceStep?.answerFormat?.textChoices,
//            textChoices.count > id,
//            let textChoice = textChoices[id] as? RSTextChoiceWithAuxiliaryAnswer
//            else {
//            return nil
//        }
//        return textChoice
//    }
    
//    open func auxFormItem(id: Int) -> ORKFormItem? {
//        return self.textChoice(id: id)?.auxiliaryItem
//    }
//
//    open func index(value: NSCoding & NSCopying & NSObjectProtocol) -> Int? {
//
//        guard let textChoices = self.enhancedMultiChoiceStep.answerFormat?.textChoices else {
//            return nil
//        }
//
//        if let value = value as? String {
//
//            ///iterate over textChoices, look for right answer
//            let matchingPairs = textChoices.enumerated().filter({ pair in
//
//                if let val = pair.1.value as? String,
//                    val == value {
//                    return true
//                }
//                return false
//            })
//
//            assert(matchingPairs.count <= 1)
//
//            return matchingPairs.first?.0
//        }
//        else if let value = value as? Int {
//
//            ///iterate over textChoices, look for right answer
//            let matchingPairs = textChoices.enumerated().filter({ pair in
//
//                if let val = pair.1.value as? Int,
//                    val == value {
//                    return true
//                }
//                return false
//            })
//
//            assert(matchingPairs.count <= 1)
//
//            return matchingPairs.first?.0
//
//        }
//        else if let value = value as? Double {
//
//            ///iterate over textChoices, look for right answer
//            let matchingPairs = textChoices.enumerated().filter({ pair in
//
//                if let val = pair.1.value as? Double,
//                    val == value {
//                    return true
//                }
//                return false
//            })
//
//            assert(matchingPairs.count <= 1)
//
//            return matchingPairs.first?.0
//
//        }
//
//        return nil
//
//
//    }
    
//    public func viewForAuxiliaryItem(item: ORKFormItem, withCellId id: Int) -> UIView? {
//
//        if let answerFormat = item.answerFormat as? RSEnhancedTextScaleAnswerFormat {
//
//            guard let sliderView = RSSliderView.newView(minimumValue: 0, maximumValue: answerFormat.textChoices.count - 1) else {
//                return nil
//            }
//
//            sliderView.minValueLabel.text = answerFormat.minValueLabel
//            sliderView.maxValueLabel.text = answerFormat.maxValueLabel
//            sliderView.minValueDescriptionLabel.text = answerFormat.minimumValueDescription
//            sliderView.neutralValueDescriptionLabel.text = answerFormat.neutralValueDescription
//            sliderView.maxValueDescriptionLabel.text = answerFormat.maximumValueDescription
//            sliderView.textLabel.text = item.text
//
//            //what to do when the values are updated?
//            //when the value changes, validate, then
//
//            sliderView.onValueChanged = { value in
//
//                if value >= 0 && value < answerFormat.textChoices.count {
//                    sliderView.currentValueLabel.text = answerFormat.textChoices[value].text
//                    let choiceResult = ORKChoiceQuestionResult(identifier: item.identifier)
//                    choiceResult.choiceAnswers = [answerFormat.textChoices[value]]
//                    self.validatedAuxiliaryResultForIndex[id] = choiceResult
//                }
//                else {
//                    self.validatedAuxiliaryResultForIndex[id] = nil
//                }
//
////                sliderView.setNeedsLayout()
//                self.updateUI()
//
//            }
//
//            if let result = self.validatedAuxiliaryResultForIndex[id] as? ORKChoiceQuestionResult,
//                let choice = result.choiceAnswers?.first as? ORKTextChoice,
//                let index = answerFormat.textChoices.index(of: choice) {
//                sliderView.setValue(value: index, animated: false)
//            }
//            else {
//                sliderView.setValue(value: answerFormat.defaultIndex, animated: false)
//            }
//
//            sliderView.setNeedsLayout()
//
//            return sliderView
//
//        }
//        else {
//            return nil
//        }
//
//    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "enhanced_multi_choice"
        guard let cellController = self.cellControllerMap[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCell else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
            cell.textLabel?.text = "Default Cell"
            return cell
        }
        
        
        cellController.configureCell(cell: cell, selected: self.tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false)
        cell.setNeedsLayout()
        return cell
        
//        //        let auxResult = self.validatedAuxiliaryResultForIndex[indexPath.row]
//        cell.configure(forTextChoice: textChoice, withId: indexPath.row, initialText: self.currentText[indexPath.row])
//        cell.delegate = self
//        
//        cell.updateUI(selected: self.tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false, animated: false, updateResponder: false)
//        //cell.setSelected(self.selected.contains(indexPath.row), animated: false)
//        cell.setNeedsLayout()
//        
//        return cell
//        
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCell else {
//            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
//            cell.textLabel?.text = "Default Cell"
//            return cell
//        }
//        
//        
//        
//        
//        
//        guard let textChoice = self.textChoice(id: indexPath.row) else {
//            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
//            cell.textLabel?.text = "Default Cell"
//            return cell
//        }
//        
//        if let auxItem = textChoice.auxiliaryItem,
//            let answerFormat = auxItem.answerFormat {
//            
//            if let textScaleAnswerFormat = answerFormat as? RSEnhancedTextScaleAnswerFormat {
//                
//                let identifier = "enhanced_multi_choice_with_accessory"
//                
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCell else {
//                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
//                    cell.textLabel?.text = "Default Cell"
//                    return cell
//                }
//
//                cell.configure(forTextChoice: textChoice, withId: indexPath.row, delegate: self, result: nil)
//                
//                //delegate forces update on setSelected
//                cell.delegate = self
//                
//                debugPrint(self.tableView.indexPathsForSelectedRows?.contains(indexPath))
//
//                cell.updateUI(selected: self.tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false, animated: false, updateResponder: false)
////                cell.setSelected(self.selected.contains(indexPath.row), animated: false)
//                cell.setNeedsLayout()
//                
//                return cell
//                
//            }
//            
//            else {
//                let identifier = "enhanced_multi_choice"
//                
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCell else {
//                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
//                    cell.textLabel?.text = "Default Cell"
//                    return cell
//                }
//                
//                
//                //        let auxResult = self.validatedAuxiliaryResultForIndex[indexPath.row]
//                cell.configure(forTextChoice: textChoice, withId: indexPath.row, initialText: self.currentText[indexPath.row])
//                cell.delegate = self
//                
//                cell.updateUI(selected: self.tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false, animated: false, updateResponder: false)
//                //cell.setSelected(self.selected.contains(indexPath.row), animated: false)
//                cell.setNeedsLayout()
//                
//                return cell
//            }
//            
//        }
//        else {
//            let identifier = "enhanced_multi_choice"
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCell else {
//                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
//                cell.textLabel?.text = "Default Cell"
//                return cell
//            }
//            
//            
//            //        let auxResult = self.validatedAuxiliaryResultForIndex[indexPath.row]
//            cell.configure(forTextChoice: textChoice, withId: indexPath.row, initialText: self.currentText[indexPath.row])
//            cell.delegate = self
//            
//            cell.updateUI(selected: self.tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false, animated: false, updateResponder: false)
//            //cell.setSelected(self.selected.contains(indexPath.row), animated: false)
//            cell.setNeedsLayout()
//            
//            return cell
//            
//        }
        
    }
    
//    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let identifier = "enhanced_multi_choice"
//
//        guard let textChoice = self.textChoice(id: indexPath.row),
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCell else {
//            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
//            cell.textLabel?.text = "Default Cell"
//            return cell
//        }
//
////        let auxResult = self.validatedAuxiliaryResultForIndex[indexPath.row]
//        cell.configure(forTextChoice: textChoice, withId: indexPath.row, initialText: self.currentText[indexPath.row])
//        cell.delegate = self
//
//        cell.updateUI(selected: self.tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false, animated: false, updateResponder: false)
//        //cell.setSelected(self.selected.contains(indexPath.row), animated: false)
//        cell.setNeedsLayout()
//
//        return cell
//    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        self.selected = self.selected.union(Set([indexPath.row]))
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.view.setNeedsLayout()
        self.updateUI()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        self.selected = self.selected.subtracting(Set([indexPath.row]))
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.view.setNeedsLayout()
        self.updateUI()
    }

    override open func clearAnswer() {
//        self.selected = []
        self.cellControllerMap.values.forEach({ $0.clearAnswer() })
    }
    
    override func continueTapped(_ sender: Any) {
//        self.resignFirstResponder()
        self.view.endEditing(true)
        
        
        
        //rules for moving forward
        //For all selected items
        //if the item is optional, it must have no text or there must be a valid result
        //if the item is not optional, there must be a valid result
        
        //get a list of all controllers that are selected AND invalid
        let invalidCellControllers = self.cellControllerMap.filter { (pair) -> Bool in
            return pair.value.isSelected && !pair.value.isValid
        }
        
        if invalidCellControllers.count == 0 {
            super.continueTapped(sender)
        }
        else {
//            let textForInvalidIds: [String] = invalidCellControllers.compactMap { id in
//
//                guard let textChoice = self.textChoice(id: id) else {
//                    return nil
//                }
//                return textChoice.text
//            }
//
//            self.showValidityAlertMessage(message:"One or more fields is invalid: \(textForInvalidIds.joined(separator: ", "))")
            
            //possibly highlight invalid cells...
            self.showValidityAlertMessage(message:"One or more fields is invalid")
        }
        
    }
    
    override open var result: ORKStepResult? {
        guard let result = super.result else {
            return nil
        }
        
        let multipleChoiceResult = RSEnhancedMultipleChoiceResult(identifier: self.enhancedMultiChoiceStep.identifier)
//        let selections:[RSEnahncedMultipleChoiceSelection] = self.selected.compactMap { (index) -> RSEnahncedMultipleChoiceSelection? in
//            guard let textChoice = self.textChoice(id: index) else {
//                return nil
//            }
//
//            return RSEnahncedMultipleChoiceSelection(value: textChoice.value, auxiliaryResult: self.validatedAuxiliaryResultForIndex[index])
//        }
        
        let selections = self.cellControllerMap.values.compactMap { (cellController) -> RSEnahncedMultipleChoiceSelection? in
            return cellController.choiceSelection
        }

        multipleChoiceResult.choiceAnswers = selections
        
        result.results = [multipleChoiceResult]
        
        return result
    }
    
//    public func setSelected(selected: Bool, forCellId id: Int) {
//        if selected {
//            self.selected = self.selected.union([id])
//        }
//        else {
//            self.selected = self.selected.subtracting([id])
//        }
//    }
    
//    //MARK: RSEnhancedMultipleChoiceCellWithTextFieldAccessoryCellDelegate
//    func auxiliaryTextField(_ textField: UITextField, forCellId id: Int, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        //if changes, clear result associated with this id
//
//        if let startingText = textField.text {
//
//            let start = startingText.index(startingText.startIndex, offsetBy: range.location)
//            let end = startingText.index(startingText.startIndex, offsetBy: range.location + range.length)
//            let stringRange = start..<end
//            let text = startingText.replacingCharacters(in: stringRange, with: string)
//            let textWithoutNewlines = text.components(separatedBy: CharacterSet.newlines).joined(separator: "")
//
//            if self.validateTextForLength(text: textWithoutNewlines, id: id) == false {
//                self.updateUI()
//                return false
//            }
//
//            //set the state of text
//            self.currentText[id] = textWithoutNewlines
//        }
//        self.updateUI()
//        return true
//
//    }
//
//    func auxiliaryTextFieldShouldClear(_ textField: UITextField, forCellId id: Int) -> Bool {
//        self.currentText[id] = nil
//        self.updateUI()
//        return true
//    }
//
//    func auxiliaryTextFieldDidEndEditing(_ textField: UITextField, forCellId id: Int) {
//        //we need to make sure that we cannot dismiss this if its selected and invalid
//        if !self.selected.contains(id) {
//            self.updateUI()
//            return
//        }
//
//        guard let textChoice = self.textChoice(id: id),
//            let auxItem = textChoice.auxiliaryItem else  {
//            self.updateUI()
//            return
//        }
//
//        //emtpy should be considered valid in all cases
//        if let text = textField.text,
//            text.characters.count > 0 {
//
//            self.currentText[id] = textField.text
//
//            //validate
//            //if passes, convert into result and add to map
//            //otherwise, throw message
//
//            if self.validate(text: text, id: id) {
//                self.validatedAuxiliaryResultForIndex[id] = self.convertToResult(text: text, id: id)
//            }
//            else {
//                self.validatedAuxiliaryResultForIndex[id] = nil
//            }
//
//        }
//        else {
//
//            //clear the
//            //is this empty?
//            self.currentText[id] = textField.text
//            if !auxItem.isOptional {
//                self.showValidityAlertMessage(message: "The field associated with choice \"\(textChoice.text)\" is required.")
//            }
//        }
//
//        self.updateUI()
//    }
    
    func showValidityAlertMessage(message: String) {
        
        let title = "Invalid value"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
//    func convertToResult(text: String, id: Int) -> ORKResult? {
//
//        guard let auxItem = self.auxFormItem(id: id),
//            let answerFormat = auxItem.answerFormat else {
//                return nil
//        }
//
//        switch(answerFormat) {
//        case _ as ORKTextAnswerFormat:
//
//            let result = ORKTextQuestionResult(identifier: auxItem.identifier)
//            result.textAnswer = text
//            return result
//
//            return nil
//        case _ as ORKEmailAnswerFormat:
//
//            let result = ORKTextQuestionResult(identifier: auxItem.identifier)
//            result.textAnswer = text
//            return result
//
//            return nil
//        case let answerFormat as ORKNumericAnswerFormat:
//
//            if answerFormat.style == .decimal {
//                if let answer = Double(text) {
//                    let result = ORKNumericQuestionResult(identifier: auxItem.identifier)
//                    result.numericAnswer = NSNumber(floatLiteral: answer)
//                    result.unit = answerFormat.unit
//                    return result
//                }
//            }
//            else {
//                if let answer = Int(text) {
//                    let result = ORKNumericQuestionResult(identifier: auxItem.identifier)
//                    result.numericAnswer = NSNumber(integerLiteral: answer)
//                    result.unit = answerFormat.unit
//                    return result
//                }
//            }
//            return nil
//        default:
//            return nil
//        }
//    }
//
//    func validate(text: String, id: Int) -> Bool {
//
//        guard let auxItem = self.auxFormItem(id: id) else {
//            self.showValidityAlertMessage(message: "An eror occurred")
//            return false
//        }
//
//        switch auxItem.answerFormat {
//
//        case _ as ORKTextAnswerFormat:
//            return self.validateTextForLength(text: text, id: id) && self.validateTextForRegEx(text: text, id: id)
//
//        case _ as ORKEmailAnswerFormat:
//            return self.validateTextForLength(text: text, id: id) && self.validateTextForRegEx(text: text, id: id)
//
//        case _ as ORKNumericAnswerFormat:
//            return self.validateNumericTextForRange(text: text, id: id)
//
//        default:
//            self.showValidityAlertMessage(message: "An eror occurred")
//            return false
//
//        }
//    }
//
//    //MARK: Validation Functions
//    //returns true for empty text
//    open func validateTextForRegEx(text: String, id: Int) -> Bool {
//
//        guard let auxItem = self.auxFormItem(id: id),
//            let answerFormat = auxItem.answerFormat as? ORKTextAnswerFormat,
//            let regex = answerFormat.validationRegex,
//            let invalidMessage = answerFormat.invalidMessage else {
//                return true
//        }
//
//        do {
//            let regex = try NSRegularExpression(pattern: regex)
//            let matchCount = regex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.characters.count))
//
//            if matchCount != 1 {
//                self.showValidityAlertMessage(message: invalidMessage)
//                return false
//            }
//            return true
//        } catch {
//            self.showValidityAlertMessage(message: "Invalid Regular Expression")
//            return false
//        }
//    }
//
//    open func validateTextForLength(text: String, id: Int) -> Bool {
//
//        guard let auxItem = self.auxFormItem(id: id),
//            let answerFormat = auxItem.answerFormat as? ORKTextAnswerFormat,
//            answerFormat.maximumLength > 0 else {
//                return true
//        }
//
//        if text.characters.count > answerFormat.maximumLength {
//            self.showValidityAlertMessage(message: "Text content exceeding maximum length: \(answerFormat.maximumLength)")
//            return false
//        }
//        else {
//            return true
//        }
//
//    }
//
//    open func validateNumericTextForRange(text: String, id: Int) -> Bool {
//        guard let auxItem = self.auxFormItem(id: id),
//            let answerFormat = auxItem.answerFormat as? ORKNumericAnswerFormat else {
//                return true
//        }
//
//        if answerFormat.style == ORKNumericAnswerStyle.decimal,
//            let decimalAnswer = Double(text) {
//
//            if let minValue = answerFormat.minimum?.doubleValue,
//                decimalAnswer < minValue {
//                self.showValidityAlertMessage(message: "\(decimalAnswer) is less than the minimum allowed value \(minValue).")
//                return false
//            }
//
//            if let maxValue = answerFormat.maximum?.doubleValue,
//                decimalAnswer > maxValue {
//                self.showValidityAlertMessage(message: "\(decimalAnswer) is more than the maximum allowed value \(maxValue).")
//                return false
//            }
//
//            return true
//        }
//        else if answerFormat.style == ORKNumericAnswerStyle.integer,
//            let integerAnswer = Int(text)  {
//
//            if let minValue = answerFormat.minimum?.intValue,
//                integerAnswer < minValue {
//                self.showValidityAlertMessage(message: "\(integerAnswer) is less than the minimum allowed value \(minValue).")
//                return false
//            }
//
//            if let maxValue = answerFormat.maximum?.intValue,
//                integerAnswer > maxValue {
//                self.showValidityAlertMessage(message: "\(integerAnswer) is more than the maximum allowed value \(maxValue).")
//                return false
//            }
//
//            return true
//        }
//        else {
//            return true
//        }
//    }
    

}
