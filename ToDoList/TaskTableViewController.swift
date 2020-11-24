//
//  TaskTableViewController.swift
//  ToDoList
//
//  Created by Никита Гвоздиков on 24.11.2020.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController {

    private let storageManager = StorageManager.shared

    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        storageManager.fetchData(tasks: &tasks)
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]
        
        //настраиваем контент
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.deleteItem(at: indexPath.row)

        }
    }

    private func reloadRowInTable(){
        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
    }
   
    
    
    
    @IBAction func addNewTaskButton(_ sender: UIBarButtonItem) {
        showAlert(with: "Add New Task", message: "What do you want to do?")
    }
    
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else {return}
            self.save(taskName: task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true)
        
    }

    
    
    private func save(taskName: String) {
        guard let task = storageManager.getTask() else {return}
        task.name = taskName
        tasks.append(task)
        reloadRowInTable()
        storageManager.saveContext()
    }
    
    
   
    
   

    
    
    
}




    
