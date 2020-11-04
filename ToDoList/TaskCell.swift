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
    @IBOutlet var completionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
        
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let margins = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 5
        contentView.layer.masksToBounds = false
        contentView.tintColor = .white
        self.backgroundColor = .clear
    }
    
    

}
