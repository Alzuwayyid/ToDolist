//
//  FilterViewController.swift
//  ToDoList
//
//  Created by Mohammed on 03/11/2020.
//

import UIKit

protocol passTags {
    func passTags(tags: [String])
}
class FilterViewController: UIViewController {
    
    @IBOutlet var personalSwitch: UISwitch!
    @IBOutlet var workSwitch: UISwitch!
    @IBOutlet var familiSwitch: UISwitch!
    @IBOutlet var grocerySwitch: UISwitch!
    
    var tagsToPass = [String]()
    var delegate: passTags!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personalSwitch.isOn = false
        workSwitch.isOn = false
        familiSwitch.isOn = false
        grocerySwitch.isOn = false
        
//        personalSwitch.isOn.toggle()
//        workSwitch.isOn.toggle()
//        familiSwitch.isOn.toggle()
//        grocerySwitch.isOn.toggle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if personalSwitch.isOn{
            tagsToPass.append("Personal")
        }
        else if workSwitch.isOn{
            tagsToPass.append("Work")
        }
        else if familiSwitch.isOn{
            tagsToPass.append("Family")
        }
        else if grocerySwitch.isOn{
            tagsToPass.append("Grocery")
        }
        
        print("Filter view Will disappear:  \(tagsToPass) ")
        delegate.passTags(tags: tagsToPass)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = .systemGray2
    }
    
    
    
    
    
}
