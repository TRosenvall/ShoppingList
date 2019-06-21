//
//  ShoppingListTableViewCell.swift
//  Shopping List
//
//  Created by Timothy Rosenvall on 6/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

protocol ShoppingListTableViewCellDelegate: class {
    func isCompleteButtonTapped(_ sender: ShoppingListTableViewCell)
}

class ShoppingListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    weak var delegate: ShoppingListTableViewCellDelegate?
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        if let assignedDelegate = delegate {
            assignedDelegate.isCompleteButtonTapped(self)
        }
    }
    
    func updateButton( isComplete: Bool) {
        if isComplete {
            completeButton.setImage(UIImage(named: "complete.png"), for: .normal)
        } else {
            completeButton.setImage(UIImage(named: "incomplete.png"), for: .normal)
        }
    }
}

extension ShoppingListTableViewCell {
    func update( item: Item ) {
        nameLabel.text = item.name
        updateButton(isComplete: item.isComplete)
    }
}
