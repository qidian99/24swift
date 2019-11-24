//
//  ToDoTableViewCell.swift
//  Todoapp
//
//  Created by 齐典 on 11/24/19.
//  Copyright © 2019 齐典. All rights reserved.
//

import UIKit

protocol TodoCellDelegate {
    func didRequestDelete (_ cell:ToDoTableViewCell)
    func didRequestComplete (_ cell:ToDoTableViewCell)
    func didRequestShare (_ cell:ToDoTableViewCell)
}


class ToDoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var todoLabel: UILabel!
    
    var delegate:TodoCellDelegate?
    
    
    @IBAction func completeTodo(_ sender: Any) {
        if let delelgateObject = self.delegate {
            delelgateObject.didRequestComplete(self)
        }
    }
    
    @IBAction func deleteTodo(_ sender: Any) {
        if let delelgateObject = self.delegate {
            delelgateObject.didRequestDelete(self)
        }
    }
    
    @IBAction func shareTodo(_ sender: Any) {
        if let delelgateObject = self.delegate {
           delelgateObject.didRequestShare(self)
       }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
