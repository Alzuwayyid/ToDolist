//
//  ViewController.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import UIKit

class TableViewController: UITableViewController {
    
    var taskStore: TaskStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        let detailViewController = DetailViewController(nibName: nil, bundle: nil)
//        detailViewController.delegate = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.allTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = taskStore.allTasks[indexPath.row]
        
//        cell.textLabel?.text = task.title
//        cell.detailTextLabel?.text = task.additionalNote
        cell.title.text = task.title
        cell.additionalNote.text = task.additionalNote
        
        if task.isCompleted{
            cell.completionImage.image = UIImage(systemName: "checkmark.seal.fill")
        }

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
            case "showDetails":
//                if let row = tableView.indexPathForSelectedRow?.row{
//                    let task = taskStore.allTasks[row]
                    let detailViewController = segue.destination as! DetailViewController
                    detailViewController.delegate = self
//                }
            default:
                print("Could not perfrom segue")
        }
    }
    



}

extension TableViewController: passTaskDelegate{
    func passTask(for PassedTask: Task) {
        taskStore.addTask(PassedTask)

    }
    
    

    
    
}


