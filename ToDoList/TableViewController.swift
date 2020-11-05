//
//  ViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: - Properties
    var taskStore: TaskStore!
    var newTasks = [Task]()
    var tags = [String]()
    var personlTasks: [Task]{
        taskStore.allTasks.filter({$0.filteringTag == "Personal"})
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.backgroundColor = UIColor.init(hexaRGB: "#2c3e50")
                
        
        let notificationCenter = NotificationCenter.default
        
        let passedTasks: [String: TaskStore] = ["TaskStore":self.taskStore]
        
        notificationCenter.post(name: NSNotification.Name(rawValue: "PassTaskToFilter"), object: nil, userInfo: passedTasks)
    }
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "TahDoodle"
        
        newTasks = returnTasksWithTags(tags)

        // Reloading the table
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        #warning("Remove this")
        let notificationCenter = NotificationCenter.default
        
        let passedTasks: [String: TaskStore] = ["TaskStore":self.taskStore]
        
        notificationCenter.post(name: NSNotification.Name(rawValue: "PassTaskToFilter"), object: nil, userInfo: passedTasks)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        
        let passedTasks: [String: TaskStore] = ["TaskStore":self.taskStore]
        
        notificationCenter.post(name: NSNotification.Name(rawValue: "PassTaskToFilter"), object: nil, userInfo: passedTasks)
    }
    
    
    // If the user swipe left, it will delete chosen task from tableView and taskStore
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let task = taskStore.allTasks[indexPath.row]
            
            taskStore.removeTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    // If user swipes left-to-right, task will be completed
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = UIContextualAction(style: .normal, title: "Completed", handler: {
            (contextAction,view,boolVlaue) in
            boolVlaue(true) // pasing true to alllow actions
            
        })
        
        context.backgroundColor = .systemGreen
        
        let swipeAction = UISwipeActionsConfiguration(actions: [context])
        
        
        DispatchQueue.main.async {
            self.taskStore.allTasks[indexPath.row].isCompleted = true
            self.tableView.reloadData()
        }
        
        return swipeAction
    }
    
    // Specified only one section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if there is no passed tasks, return all tasks
        if newTasks.isEmpty{
            return taskStore.allTasks.count
        }
        
        return newTasks.count
    }
    
    
    // Return all tasks with specified tags
    func returnTasksWithTags(_ tagsArray: [String]) -> [Task]{
        
        var newArr = [Task]()
        
        for task in taskStore.allTasks{
            for tag in tagsArray{
                if task.filteringTag == tag{
                    newArr.append(task)
                }
            }
        }
        return newArr
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        
        // If there is no passed tasks, set the title, dueDate and task status to all tasks.
        if newTasks.count == 0{
            cell.title.text = taskStore.allTasks[indexPath.row].title
            
            dateFormatter.dateFormat = "MMM d, h:mm a"
            
            if taskStore.allTasks[indexPath.row].isCompleted{
                cell.completionImage.image =  UIImage(systemName: "checkmark.seal.fill")
                cell.completionImage.tintColor = .systemGreen
            }
            else{
                if taskStore.allTasks[indexPath.row].dueDate! < Date(){
                    cell.completionImage.image = UIImage(systemName: "exclamationmark.circle.fill")
                    cell.completionImage.image!.withRenderingMode(.alwaysTemplate)
                    cell.completionImage.tintColor = UIColor.init(hexaRGB: "#e74c3c")
                    
                }
                else{
                    cell.completionImage.image = UIImage(systemName: "clock")
                    cell.completionImage.tintColor = .blue
                }

            }
            
        }
        // Set title, dueDate and task status to tasks that contain tags similer to the passed ones.
        else{
            cell.title.text = newTasks[indexPath.row].title
            
            dateFormatter.dateFormat = "MMM d, h:mm a"
            
            cell.additionalNote.text = dateFormatter.string(from: newTasks[indexPath.row].dueDate!)

            if newTasks[indexPath.row].isCompleted{
                cell.completionImage.image = UIImage(systemName: "checkmark.seal.fill")
                cell.completionImage.tintColor = .systemGreen
            }
            else{
                if taskStore.allTasks[indexPath.row].dueDate! < Date(){
                    cell.completionImage.image = UIImage(systemName: "exclamationmark.circle.fill")
                    cell.completionImage.image!.withRenderingMode(.alwaysTemplate)
                    cell.completionImage.tintColor = UIColor.init(hexaRGB: "#e74c3c")
                    
                }
                else{
                    cell.completionImage.image = UIImage(systemName: "clock")
                    cell.completionImage.tintColor = .blue
                }
                
            }
            
        }
        
        cell.additionalNote.text = dateFormatter.string(from: taskStore.allTasks[indexPath.row].dueDate!)
        
        return cell
    }
    
     
    
    // prepare segue for editController and detailController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier{
            case "showDetails":
                let detailViewController = segue.destination as! DetailViewController
                // Setting tableCotroller as detailController delegate to pass the Task data
                detailViewController.delegate = self
            case "editTask":
                if let row = tableView.indexPathForSelectedRow?.row{
                    let task = taskStore.allTasks[row]
                    let editViewController = segue.destination as! EditViewController
                    // setting tableController as editController delegate to update the task
                    editViewController.updateDelegate = self
                    editViewController.task = task
                }
                // setting tableViewController as FilterViewController delegate to pass tags in order to filter.
            case "filter":
                let filterViewController = segue.destination as! FilterViewController
                filterViewController.delegate = self
            default:
                print("Could not perfrom segue")
        }
    }
    
    
    
    

}

// Conforming the update and add tasks, then reloading table view.
extension TableViewController: passTaskDelegate, updateTaskDelegate, passTags{
    func passTags(tags: [String], clearStore: Bool) {
        
        if clearStore == true{
            taskStore.removeAllTasks(clearTasks: true)
        }
        else{
            self.tags = tags
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        print("Tags were passed successfully:  \(tags)")
    }
    
    
    
    
    func updateTask(passedTask oldTask: Task, new newTask: Task) {
        taskStore.removeTask(oldTask)
        taskStore.addTask(newTask)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    func passTask(for PassedTask: Task) {
        taskStore.addTask(PassedTask)
    }
    
    
    
    
    
}


