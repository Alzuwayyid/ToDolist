//
//  SavingOperation.swift
//  ToDoList
//
//  Created by Mohammed on 16/11/2020.
//

import Foundation

class SavingOpeartion: Operation{
    var allTasks = [Task]()
    
    enum State: String {
        case isReady
        case isExecuting
        case isFinished
    }
    
    var state: State = .isReady {
        willSet(newValue) {
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isFinished: Bool {
        if isCancelled && state != .isExecuting { return true }
        return state == .isFinished
    }
    
    override var isExecuting: Bool { state == .isExecuting }
    
    override var isAsynchronous: Bool { true }

    let taskArchiveURL: URL = {
        let documentsDirecorty = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirecorty.first!
        return documentDirectory.appendingPathComponent("tasks.plist")
    }()
    
    override func main() {

    }
    

    override func performSelector(inBackground aSelector: Selector, with arg: Any?) {
        
    }
    
    func save(){
        let encoder = PropertyListEncoder()
        do{
        let data = try encoder.encode(allTasks)
        try data.write(to: taskArchiveURL, options: [.atomic])
            print("-----> Saved")
        }
        catch{
            print("Could not save to the disk")
        }
    }
    
    func load(){
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
    }
    
    override func start() {
        if isCancelled {
            finish()
            return
        }
        self.state = .isExecuting
        main()
    }
    
    public final func finish() {
        if isExecuting {
            state = .isFinished
        }
    }
    
}
