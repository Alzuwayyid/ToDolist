//
//  ViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit
import DrawerView

class TableViewController: UITableViewController {
    
    var taskStore: TaskStore!
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let drawerViewController = self.storyboard!.instantiateViewController(identifier: "DrawerViewController")
        self.addDrawerView(withViewController: drawerViewController)
        
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.title = "TahDoodle"
        
        
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
        return taskStore.allTasks.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        // Fetch the current index path row to embed data in it
        let task = taskStore.allTasks[indexPath.row]
        
        // Set title and date to the cell
        cell.title.text = task.title
        
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        cell.additionalNote.text = dateFormatter.string(from: task.dueDate!)
        
        if task.isCompleted{
            cell.completionImage.image = UIImage(systemName: "checkmark.seal.fill")
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
            default:
                print("Could not perfrom segue")
        }
    }
    
    
    
    
}

// Conforming the update and add tasks, then reloading table view.
extension TableViewController: passTaskDelegate, updateTaskDelegate{
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


