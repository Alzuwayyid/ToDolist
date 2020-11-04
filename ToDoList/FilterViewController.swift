//
//  FilterViewController.swift
//  ToDoList
//
//  Created by Mohammed on 03/11/2020.
//

import UIKit

protocol passTags {
    func passTags(tags: [String], clearStore: Bool)
}
class FilterViewController: UIViewController {
    
    @IBOutlet var personalSwitch: UISwitch!
    @IBOutlet var workSwitch: UISwitch!
    @IBOutlet var familiSwitch: UISwitch!
    @IBOutlet var grocerySwitch: UISwitch!
    @IBOutlet var clearTasksButton: UIButton!
    
    var tagsToPass = [String]()
    var isItCleared: Bool = false
    var delegate: passTags!
    
    @IBAction func clearTasks(_ sender: UIButton) {
        self.isItCleared = true
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        personalSwitch.isOn = false
        workSwitch.isOn = false
        familiSwitch.isOn = false
        grocerySwitch.isOn = false
        
        clearTasksButton.setBorder(.black, width: 0.9)
        clearTasksButton.setCornerRadius(20)
        
        clearTasksButton.backgroundColor = UIColor.init(hexaRGB: "#e74c3c")
        
        view.backgroundColor = UIColor.init(hexaRGB: "#2c3e50")

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
        delegate.passTags(tags: tagsToPass, clearStore: isItCleared)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    
    
}
