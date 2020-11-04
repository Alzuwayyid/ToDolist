//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit


protocol passTaskDelegate{
    func passTask(for PassedTask: Task)
}

//protocol passTags {
//    func passTags(for tag: String)
//}

class DetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UITextViewDelegate {
    
    var taskStore: TaskStore!
    var task: Task!
    var delegate: passTaskDelegate!
    let pickerData = ["Personal","Grocery","Work","Family"]
    var tagToPass = ""
    
    @IBOutlet var tagFilterPicker: UIPickerView!
    
    @IBOutlet var dueDateSwitch: UISwitch!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var addNotes: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var completedButton: UIButton!
    
//    var passingTagDelegate: passTags!
    
    var isCompleted: Bool = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    @IBAction func dissMiss(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
        
    }
    // The image will be changed if the user touches the button
    @IBAction func completedButton(_ sender: UIButton) {
        self.isCompleted.toggle()
        
        DispatchQueue.main.async {
            if self.isCompleted{
                self.completedButton.imageView!.image = UIImage(systemName: "checkmark.seal.fill")
            }
            else{
                self.completedButton.imageView?.image = UIImage(systemName: "checkmark.seal")
            }
            
        }
        

    }
    
    
    // Setting the completion image, confirming to textFieldDelgate and textViewDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #warning("Working here")
//        titleTextField.setBorder(UIColor(red: 41, green: 128, blue: 185, alpha: 0), width: CGFloat(20))
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
        
        
        tagFilterPicker.layer.cornerRadius = 10
        tagFilterPicker.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        tagFilterPicker.layer.shadowOpacity = 0.3
        tagFilterPicker.layer.shadowColor = UIColor.black.cgColor
        tagFilterPicker.layer.shadowRadius = 5
        tagFilterPicker.layer.masksToBounds = false
        tagFilterPicker.tintColor = .white
        
//        dueDateSwitch.isOn = true
        
        
        navigationController?.navigationBar.tintColor =  UIColor.init(hexaRGB: "#2980b9")
        navigationController?.navigationBar.barTintColor = UIColor.init(hexaRGB: "#2c3e50")
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

            
        
        self.completedButton.imageView?.image = UIImage(systemName: "checkmark.seal")
        
        addNotes.delegate = self
        titleTextField.delegate = self
        tagFilterPicker.delegate = self
        dueDateSwitch.isOn = false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
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
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        NotificationCenter.default.removeObserver(self)
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let currentText = textField.text{
            self.titleTextField.text = currentText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    

     func textViewDidEndEditing(_ textView: UITextView) {

        if let current = textView.text{
            addNotes.text = current
        }
    }
}


extension DetailViewController{
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // these two guards will check whether fields are empty .
        guard let textTitle = titleTextField.text else{
            return
        }
        guard let addNotes = addNotes.text else {
            return
        }
        
        var dueDate = datePicker?.date
        
        if !dueDateSwitch.isOn{
//            dueDate = nil
            dueDate = Date()
        }
        
        // Create a new task and pass it as paramter
        #warning("Checking if the task entered is empty")
        if !textTitle.isEmpty{
            let task = Task(title: textTitle, dueDate: dueDate, date: dueDate!, additionalNote: addNotes, isCompleted: isCompleted, isLate: false, tag: tagToPass)

            delegate.passTask(for: task)
        }

        
//        passingTagDelegate.passTags(for: tagToPass)
        
        self.navigationController?.popViewController(animated: true)
    }
}



extension DetailViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tagToPass = pickerData[row]
    }
    
}



extension UIColor {
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: alpha)
    }

    convenience init?(hexaRGBA: String) {
        var chars = Array(hexaRGBA.hasPrefix("#") ? hexaRGBA.dropFirst() : hexaRGBA[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[6...7]), nil, 16)) / 255)
    }

    convenience init?(hexaARGB: String) {
        var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
}
