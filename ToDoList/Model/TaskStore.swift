//
//  TaskStore.swift
//  ToDoList
//
//  Created by Mohammed on 02/11/2020.
//

import Foundation
import UIKit


class TaskStore{
    
    
    var allTasks = [Task](){
        didSet{
            saveChanges()
        }
    }

    
    let taskArchiveURL: URL = {
        let documentsDirecorty = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirecorty.first!
        return documentDirectory.appendingPathComponent("tasks.plist")
    }()
    
    init() {
        
        do{
            let data = try Data(contentsOf: taskArchiveURL)
            let unArchive = PropertyListDecoder()
            let tasks = try unArchive.decode([Task].self, from: data)
            allTasks = tasks
        }
        catch{
            print("Encountered some error while loading: \(error)")
        }
        
        print("all items were loaded sucressfully")
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    
    
    func addTask(_ task: Task){
        allTasks.append(task)
    }
    
    func removeTask(_ task: Task){
        if let index = allTasks.firstIndex(of: task){
            allTasks.remove(at: index)
        }
    }
    
    func updateTask(_ task: Task){
        
    }
    
    
    @objc func saveChanges() -> Bool{
        print("Items will be saved to; \(taskArchiveURL)")
        
        do{
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allTasks)
            try data.write(to: taskArchiveURL, options: [.atomic])
            print("All items were saved successfully")
            return true
        }
        catch{
            print("There was an error while saving: \(error)")
            return false
        }
        
    }
    
    
    
}
