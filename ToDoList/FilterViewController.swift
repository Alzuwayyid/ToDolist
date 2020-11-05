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
    var taskStore: TaskStore!


    @IBAction func personalSwitch(_ sender: UISwitch) {
        var counter = 0
        for task in taskStore.allTasks{
            if task.filteringTag.contains("Personal"){
                counter += 1
            }
        }
        if counter <= 0{
            showSwitchAlert("Personal")
            personalSwitch.isOn = false
        }
    }
    
    
    @IBAction func workSwitch(_ sender: UISwitch) {
        var counter = 0
        
        for task in taskStore.allTasks{
            if task.filteringTag.contains("Work"){
                counter += 1
            }
        }
        if counter <= 0{
            showSwitchAlert("Work")
            workSwitch.isOn = false
        }

    }
    
    @IBAction func familiySwitchTapped(_ sender: UISwitch) {
        var counter = 0
        
        for task in taskStore.allTasks{
            if task.filteringTag.contains("Family"){
                counter += 1
            }
        }
        if counter <= 0{
            showSwitchAlert("Family")
            familiSwitch.isOn = false
        }
    }
    
    
    @IBAction func grocerySwitchTapped(_ sender: UISwitch) {
        var counter = 0
        
        for task in taskStore.allTasks{
            if task.filteringTag.contains("Grocery"){
                counter += 1
            }
        }
        if counter <= 0{
            showSwitchAlert("Grocery")
            grocerySwitch.isOn = false
        }
    }
    
    
    func showSwitchAlert(_ nameOfTag: String){
        let alert = UIAlertController(title: "No matching results for \((nameOfTag))", message: "try different tag!", preferredStyle: UIAlertController.Style.alert)
        
//        alert.view.layer.cornerRadius
        
        alert.view.layer.cornerRadius = 10
        alert.view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        alert.view.layer.shadowOpacity = 0.3
        alert.view.layer.shadowColor = UIColor.black.cgColor
        alert.view.layer.shadowRadius = 5
        alert.view.layer.masksToBounds = false
        alert.view.tintColor = .white
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func clearTasks(_ sender: UIButton) {
        self.isItCleared = true
        
        let alert = UIAlertController(title: "Tasks were removed", message: "All clear sir!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setTaskStore(notification:)), name: NSNotification.Name(rawValue: "PassTaskToFilter"), object: nil)
        
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
    
    
    
    
   @objc func setTaskStore(notification: NSNotification){
    
    if let dict = notification.userInfo as NSDictionary?{
        if let passedTasks = dict["TaskStore"] as? TaskStore{
            self.taskStore = passedTasks
            print("fetched Suceecfully < ----------")
        }
        
        #warning("Remove this")
        for task in taskStore.allTasks{
            print("--------> task: \(task.title)")
        }
    }
    
    }
    
    
    
    
    
}


extension UIAlertController{
    
    
//    let margins = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.layer.cornerRadius = 10
        self.view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.view.layer.shadowOpacity = 0.3
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowRadius = 5
        self.view.layer.masksToBounds = false
        self.view.tintColor = .white
        
    }


    
}
