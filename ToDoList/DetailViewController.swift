//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit


protocol passTaskDelegate{
    func passTask(/*controller: DetailViewController*/for PassedTask: Task)
//    func update(for PassedTask: Task)
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
        dueDateSwitch.isOn = false
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
        
        var dueDate = datePicker?.date
        
        if !dueDateSwitch.isOn{
            dueDate = nil
            dueDate = Date()
        }
                
        let task = Task(title: textTitle, dueDate: dueDate, date: dueDate!, additionalNote: addNotes, isCompleted: isCompleted, isLate: false)

        delegate.passTask(for: task)
        
        self.navigationController?.popViewController(animated: true)
    }
}
