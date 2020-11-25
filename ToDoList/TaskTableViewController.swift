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
    private var tasks: [Task] = []
    private var selectedIndexPath: Int?
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        storageManager.fetchData(tasks: &tasks)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        content.image = UIImage(systemName: "circlebadge")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath.row
        let task = tasks[indexPath.row]
        showAlert(with: "Edit", message: "Do you want to edit your task?", taskName: task.name)
    }
    
    //MARK: IB Actions
    @IBAction func addNewTaskButton(_ sender: UIBarButtonItem) {
        showAlert(with: "Add New Task", message: "What do you want to do?", taskName: nil)
    }
    
    //MARK: Private Methods
    private func reloadRowInTable() {
        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
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
    
    private func showAlert(with title: String, message: String, taskName: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .destructive) { _ in
            
            if taskName != nil {
                guard let editedTask = alert.textFields?.first?.text else {return}
                self.editTask(taskName: editedTask)
            } else {
                guard let task = alert.textFields?.first?.text, !task.isEmpty else {return}
                self.saveNewTask(taskName: task)
            }
        }
        
        alert.addTextField { textField in textField.text = taskName }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    private func saveNewTask(taskName: String) {
        guard let task = storageManager.getTask() else {return}
        task.name = taskName
        tasks.append(task)
        reloadRowInTable()
        storageManager.saveContext()
    }
    
    private func editTask(taskName: String) {
        guard let selectedIndexPath = selectedIndexPath else {return}
        self.tasks[selectedIndexPath].name = taskName
        let cellIndex = IndexPath(row: selectedIndexPath, section: 0)
        tableView.reloadRows(at: [cellIndex], with: .left)
        storageManager.saveContext()
    }
}




