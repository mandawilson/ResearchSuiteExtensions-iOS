//
//  RSEnhancedTableView.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/26/18.
//

import UIKit

public protocol RSEnhancedTableViewDelegate: class {
    func touchesBegan(for tableView: RSEnhancedTableView, touches: Set<UITouch>, with event: UIEvent?)
}

open class RSEnhancedTableView: UITableView {
    
    weak var enhancedTableViewDelegate: RSEnhancedTableViewDelegate?
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.enhancedTableViewDelegate?.touchesBegan(for: self, touches: touches, with: event)
    }
    
}
