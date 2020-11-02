//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit


protocol passTaskDelegate{
    func passTask(/*controller: DetailViewController*/for PassedTask: Task)
}

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var taskStore: TaskStore!
    var task: Task!
    var delegate: passTaskDelegate!

    
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
        self.isCompleted = true
        
        if isCompleted == false{
            self.completedButton.image = UIImage(systemName: "checkmark.seal.fil")
        }
        else{
            self.completedButton.image = UIImage(systemName: "checkmark.seal")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotes.delegate = self
        titleTextField.delegate = self
        
    }
    
    
    @IBAction func setNewTitle(_ sender: UITextField) {
        task?.title = sender.text!
        print("Sender Text: \(sender.text!)")
//        let taskTemp = Task(title: sender.text!, dueDate: false, date: Date(), additionalNote: "", isCompleted: true, isLate: true)
//        self.task = taskTemp
//        print("The current title: \(task.title)")
    }
    
    @IBAction func pickNewDate(_ pickedDate: UIDatePicker) {
        pickedDate.preferredDatePickerStyle = .automatic
        task.creationDate = pickedDate.date
        print("Picked date: \(pickedDate)")
    }
    
    
    @IBAction func dueDateTapped(_ switchChoice: UISwitch) {
//        if switchChoice.isOn{
//            task.dueDate = true
//        }
//        else{
//            task.dueDate = false
//        }
//        print("Due date value: \(task.dueDate)")
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
            print("The current title from didEnd: \(titleTextField.text)")
    }
    
    
    
     func textViewDidEndEditing(_ textView: UITextView) {
        if let current = textView.text{
            addNotes.text = current
        }
        print("The current notes: \(addNotes.text)")
    }
}


extension DetailViewController{
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let textTitle = titleTextField.text else{
            return
        }
        guard let addNotes = addNotes.text else {
            return
        }
        
        var theDatePicker = datePicker?.date
            
        if dueDateSwitch.isOn{
             theDatePicker = nil
        }
        
        
        let task = Task(title: textTitle, dueDate: theDatePicker, date: Date(), additionalNote: addNotes, isCompleted: false, isLate: false)
        delegate.passTask(for: task)
        self.navigationController?.popViewController(animated: true)
    }
}
