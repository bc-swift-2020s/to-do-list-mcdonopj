//
//  toDoDetailViewController.swift
//  newToDoList
//
//  Created by Ann McDonough on 2/06/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    print("I just created a date formatter")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()


class ToDoDetailTableViewController: UITableViewController {

    @IBOutlet weak var dateLabel: UILabel!
 
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var noteView: UITextView!
    //  @IBOutlet weak var dateLabel: UILabel!
   // @IBOutlet weak var saveButton: UIBarButtonItem!
   // @IBOutlet weak var datePicker: UIDatePicker!
 //   @IBOutlet weak var reminderSwitch: UISwitch!
  //  @IBOutlet weak var nameField: UITextField!
  //  @IBOutlet weak var noteView: UITextView!
    //To Do: reminder switch and dateLabel
    
    var toDoItem: ToDoItem!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    
    
    // think I may need to add reminder set to toDoItem in view did load ??????
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if toDoItem == nil{
            toDoItem = ToDoItem(name: "", date: Date(), notes: "", reminderSet: false, completed: false)
            //TO DO: should reminder set be false????
            //To Do: I believe I do not need to include completed because it is optional
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        reminderSwitch.isOn = toDoItem.reminderSet
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text! , date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: toDoItem.completed)
        //TO DO: should reminder set be false????
                  //To Do: I believe I do not need to include completed because it is optional
    }


    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil )
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension ToDoDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return reminderSwitch.isOn ? datePicker.frame.height : 0
        case notesTextViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
        }
        
    }
}




