//
//  EditViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit


/**
 - parameters:
 -oldTask: Tasks with old values
 -newTask: Tasks contain new details that was entered by the user
 */

protocol updateTaskDelegate {
    func updateTask(passedTask oldTask: Task, new updateTask: Task)
}

class EditViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    
    // MARK: - Properties
    var taskStore: TaskStore!
    var task: Task!
    var delegate: passTaskDelegate!
    var updateDelegate: updateTaskDelegate!
    var pastDue = Date()
    var isCompleted: Bool = false
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - IBOutlets
    @IBOutlet var dueDateSwitch: UISwitch!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var addNotes: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var completedButton: UIBarButtonItem!
    
    
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
        
        // MARK: - layer modifications
        
        self.addNotes.text = task.additionalNote
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
        
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        titleTextField.layer.shadowOpacity = 0.3
        titleTextField.layer.shadowColor = UIColor.black.cgColor
        titleTextField.layer.shadowRadius = 5
        titleTextField.layer.masksToBounds = false
        
        
        
        // if the task is completed, change the check status and vice versa
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

// MARK: - Passing data for the delegate

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
                
        /*
         - if the user did type any data:
         Create a new Task instance, and set all it's properties to the data that was provided by the user.
         pass the data by the class delegate with the oldTask in order to replace it by the new one.
         */
        
        let updatedTask = Task(title: textTitle, dueDate: pastDue, date: dueDate!, additionalNote: addNotes, isCompleted: isCompleted, isLate: false, tag: "")
        updateDelegate.updateTask(passedTask: oldTaskToPass!, new: updatedTask)
//        delegate.passTask(for: task)
        
        self.navigationController?.popViewController(animated: true)
    }
}
