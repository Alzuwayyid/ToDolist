//
//  ViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit

class TableViewController: UITableViewController {
    
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
        
        view.backgroundColor = UIColor.init(hexaRGB: "#2c3e50")
        

        
    }
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "TahDoodle"
        
        newTasks = returnTasksWithTags(tags)

        // Reloading the table
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    // If the user swipe left, it will delete chosen task from tableView and taskStore
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let task = taskStore.allTasks[indexPath.row]
            
            taskStore.removeTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    
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
    
    // Table view depeands on the tasks count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newTasks.isEmpty{
            return taskStore.allTasks.count
        }
        
        return newTasks.count
    }
    
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
        // Fetch the current index path row to embed data in it


        

        
        
        
        if newTasks.count == 0{
            cell.title.text = taskStore.allTasks[indexPath.row].title
            
            dateFormatter.dateFormat = "MMM d, h:mm a"
            
            cell.additionalNote.text = dateFormatter.string(from: taskStore.allTasks[indexPath.row].dueDate!)

            
            if taskStore.allTasks[indexPath.row].isCompleted{
                cell.completionImage.image = UIImage(systemName: "checkmark.seal.fill")
            }
            
        }
        else{
            cell.title.text = newTasks[indexPath.row].title
            
            dateFormatter.dateFormat = "MMM d, h:mm a"
            
            cell.additionalNote.text = dateFormatter.string(from: newTasks[indexPath.row].dueDate!)

            if newTasks[indexPath.row].isCompleted{
                cell.completionImage.image = UIImage(systemName: "checkmark.seal.fill")
            }
            
        }
        

        
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
    func passTags(tags: [String]) {
        self.tags = tags
        
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


