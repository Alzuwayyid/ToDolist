//
//  EditViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit

protocol updateTaskDelegate {
    func updateTask(passedTask oldTask: Task, new updateTask: Task)
}

class EditViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    
    
    var taskStore: TaskStore!
    var task: Task!
    var delegate: passTaskDelegate!
    var updateDelegate: updateTaskDelegate!
    var pastDue = Date()
    
    @IBOutlet var dueDateSwitch: UISwitch!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var addNotes: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var completedButton: UIBarButtonItem!
    
    var isCompleted: Bool = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBAction func completedButton(_ sender: UIBarButtonItem) {
        self.isCompleted.toggle()
        
        if isCompleted{
            self.completedButton.image = UIImage(systemName: "checkmark.seal.fill")
        }
        else{
            self.completedButton.image = UIImage(systemName: "checkmark.seal")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.completedButton.image = UIImage(systemName: "checkmark.seal")
        addNotes.delegate = self
        titleTextField.delegate = self
        
        self.addNotes.text = task.additionalNote
//        self.datePicker.date = task.dueDate ?? task.creationDate
        self.titleTextField.text = task.title
        self.datePicker.date = task.creationDate
        self.isCompleted = task.isCompleted
        self.pastDue = task.dueDate!
        self.datePicker.isEnabled = false
        
        addNotes.layer.borderWidth = 0.5
        addNotes.layer.cornerRadius = 10
        addNotes.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        addNotes.layer.shadowOpacity = 0.3
        addNotes.layer.shadowColor = UIColor.black.cgColor
        addNotes.layer.shadowRadius = 5
        addNotes.layer.masksToBounds = false
        
//        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        titleTextField.layer.shadowOpacity = 0.3
        titleTextField.layer.shadowColor = UIColor.black.cgColor
        titleTextField.layer.shadowRadius = 5
        titleTextField.layer.masksToBounds = false
        
        
        

        if isCompleted{
            self.completedButton.image = UIImage(systemName: "checkmark.seal.fill")
        }
        else{
            self.completedButton.image = UIImage(systemName: "checkmark.seal")
        }
        
    }
        
    
    
    // This function will move to the nextField when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.titleTextField{
            self.titleTextField.resignFirstResponder()
        }
        else if textField == self.addNotes{
            self.addNotes.resignFirstResponder()
        }
        
        if let nextField = textField.superview?.viewWithTag(textField.tag+1) as? UITextField{
            nextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let currentText = textField.text{
            self.titleTextField.text = currentText
        }
    }
    
    
    
     func textViewDidEndEditing(_ textView: UITextView) {
        if let current = textView.text{
            addNotes.text = current
        }
    }
}


extension EditViewController{

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let oldTaskToPass = task

        guard let textTitle = titleTextField.text else{
            return
        }
        guard let addNotes = addNotes.text else {
            return
        }
        
        var dueDate = datePicker?.date
        
        if !dueDateSwitch.isOn{
            dueDate = nil
            dueDate = Date()
        }
                
        let updatedTask = Task(title: textTitle, dueDate: pastDue, date: dueDate!, additionalNote: addNotes, isCompleted: isCompleted, isLate: false, tag: "")
        updateDelegate.updateTask(passedTask: oldTaskToPass!, new: updatedTask)
//        delegate.passTask(for: task)
        
        self.navigationController?.popViewController(animated: true)
    }
}
