//
//  ViewController.swift
//  newToDoList
//
//  Created by Ann McDonough on 2/06/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import UserNotifications

class toDoListViewController: UIViewController {
    
    //Rather than having an array predetermined.  Now you can add you own events from scratch

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    var toDoItems: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //ToDo: Fix this loadData()   !!!!!!!!!!!!!!!!!!!!!!!!!!
        loadData()
        //ToDo; Fix this saved data
      saveData()
        autherizeLocalNotifications()
    }
    
    
    func autherizeLocalNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error)
            in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            
            if granted {
                print("Notifications Authorization granted!")
            }
             else {
                print("The user has denied notifications")
                //TODO: put an alert here telling user what to do
            }
            
        }
        
    }
    
    func setNotifications() {
        guard toDoItems.count > 0 else {
            return

    }
    //remove all notifications
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
        // and let's recreate them with the updated data that we just saved
        for index in 0..<toDoItems.count {
            if toDoItems[index].reminderSet {
                let toDoItem = toDoItems[index]
                toDoItems[index].notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
        
    }
    
    func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        //create content:
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        // create Trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create a request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //register requet with the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription) Yikes adding notifications request went wrong")
            } else {
                print("notification scheduled \(notificationID), title: \(content.title)")
            }
        }
    return notificationID
    }
    
    
    
    
    //include everyting in load Data
   func loadData() {
          let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
           
    guard let data = try? Data(contentsOf: documentURL) else {return}
    
        let jsonDecoder = JSONDecoder()
        do {
           toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            tableView.reloadData()
        } catch {
            print("Error could not save data \(error.localizedDescription)")
        }
    }
    
    
    
    
    
 
    
     func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
    
        let data = try? jsonEncoder.encode(toDoItems)
        do {
            try data?.write(to: documentURL, options: . noFileProtection)
        } catch {
            print("ERror: Could not save data \(error.localizedDescription)")
        }
     setNotifications()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.toDoItem = toDoItems[selectedIndexPath.row]
        } else{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue){
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow{
            toDoItems[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else{
            let newIndexPath = IndexPath(row: toDoItems.count, section: 0)
            toDoItems.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            
        }
    }
    
    
    @IBAction func editBarButton(_ sender: UIBarButtonItem) {
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        }else{
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    


}

extension toDoListViewController: UITableViewDelegate ,UITableViewDataSource{
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return toDoItems.count
}
//looop that does itself to list names of events
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
   cell.nameLabel.text = toDoItems[indexPath.row].name
    //cell.nameLabel.text = toDoItems[indexPath.row].completed
    return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItems[sourceIndexPath.row]
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(itemToMove, at: destinationIndexPath.row)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, fillPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let id = notification.request.identifier
        print("Received in-app notification with ID = \(id)")
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        completionHandler([.alert, .sound])
        
    }
}



