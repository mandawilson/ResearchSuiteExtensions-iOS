//
//  RSEnhancedMultipleChoiceCell.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/24/18.
//

import UIKit
import ResearchKit

public protocol RSEnhancedMultipleChoiceCellDelegate: class {
    func setSelected(selected: Bool, cell: RSEnhancedMultipleChoiceCell)
    func viewForAuxiliaryItem(item: ORKFormItem, cell: RSEnhancedMultipleChoiceCell) -> UIView?
}

open class RSEnhancedMultipleChoiceCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var checkImage: UIImage?
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var auxStackView: UIStackView!
    
//    var identifier: Int!

    var auxFormItem: ORKFormItem?
    
    weak var delegate: RSEnhancedMultipleChoiceCellDelegate?
    
    var auxContainerBackgroundView: UIView?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clearForReuse()
    }
    
    override open func prepareForReuse() {
        self.clearForReuse()
        super.prepareForReuse()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //delegate can be nil here if we've cleared when preparing for reuse
        self.delegate?.setSelected(selected: selected, cell: self)
        
        // Configure the view for the selected state
        self.updateUI(selected: selected, animated: animated, updateResponder: true)
    }
    
    open func setAuxView(view: UIView) {
        
    }
    
    open func clearForReuse() {
        
        self.delegate = nil

//        self.identifier = nil
        self.auxFormItem = nil
        self.auxStackView.arrangedSubviews.forEach { subView in
            self.auxStackView.removeArrangedSubview(subView)
        }
        
        self.auxStackView.subviews.forEach { $0.removeFromSuperview() }
        
        self.auxContainerBackgroundView?.removeFromSuperview()
        
    }
    
    open func configure(forTextChoice textChoice: RSTextChoiceWithAuxiliaryAnswer, delegate: RSEnhancedMultipleChoiceCellDelegate?) {
        
        self.clearForReuse()
        
        assert(self.delegate == nil)
        self.delegate = delegate
//        self.identifier = withId
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.titleLabel?.text = textChoice.text
        self.selectionStyle = .none
        
        self.checkImage = UIImage(named: "checkmark", in: Bundle(for: ORKStep.self), compatibleWith: nil)
        self.updateCheckImage(show: false)
        
        self.auxFormItem = textChoice.auxiliaryItem
        
    }
    
    private func updateCheckImage(show: Bool) {
        self.checkImageView.image = show ? self.checkImage : nil
    }
    
    open func updateUI(selected: Bool, animated: Bool, updateResponder: Bool) {
        
        self.auxContainerBackgroundView?.removeFromSuperview()
        
        if selected {
            self.titleLabel.textColor = self.tintColor
            self.updateCheckImage(show: true)
            
            if let auxItem = self.auxFormItem {
                if let auxView: UIView = self.delegate!.viewForAuxiliaryItem(item: auxItem, cell: self) {
                    
                    self.auxStackView.arrangedSubviews.forEach { subView in
                        self.auxStackView.removeArrangedSubview(subView)
                    }
                    
                    self.auxStackView.subviews.forEach { $0.removeFromSuperview() }
                    
                    
                    assert(self.auxStackView.arrangedSubviews.count == 0)
                    self.auxStackView.addArrangedSubview(auxView)
                }
                else {
                    assertionFailure("We must be able to generate a view for non-null aux item")
                }
            }
                
        }
        else {
            self.titleLabel.textColor = UIColor.black
            self.updateCheckImage(show: false)
            
            self.endEditing(true)
            self.setNeedsUpdateConstraints()
            
            assert(self.auxStackView.arrangedSubviews.count <= 1)
            if let subview = self.auxStackView.arrangedSubviews.first {
                
                //take snapshot of the subview
                let layer = subview.layer
                UIGraphicsBeginImageContext(subview.bounds.size);
                guard let context = UIGraphicsGetCurrentContext() else {
                    self.auxStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                    return
                }
                
                layer.render(in:context)
                guard let viewImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                    self.auxStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                    return
                }
                UIGraphicsEndImageContext()

                //set auxcontainer background view to the image
                //background view will be removed on next ui update
                //remove image
                let backgroundColor = UIColor(patternImage: viewImage)
                let backgroundView = UIView()
                backgroundView.backgroundColor = backgroundColor
                backgroundView.translatesAutoresizingMaskIntoConstraints = false
                self.auxStackView.insertSubview(backgroundView, at: 0)
                NSLayoutConstraint.activate([
                    backgroundView.leadingAnchor.constraint(equalTo: self.auxStackView.leadingAnchor),
                    backgroundView.trailingAnchor.constraint(equalTo: self.auxStackView.trailingAnchor),
                    backgroundView.topAnchor.constraint(equalTo: self.auxStackView.topAnchor),
                    backgroundView.bottomAnchor.constraint(equalTo: self.auxStackView.bottomAnchor)
                    ])
                
                self.auxContainerBackgroundView = backgroundView
                
                self.auxStackView.backgroundColor = backgroundColor
                self.auxStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
                
            }
            
        }
        
        self.setNeedsUpdateConstraints()
        
    }
}
