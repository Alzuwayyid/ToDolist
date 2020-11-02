//
//  TaskCell.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var additionalNote: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
