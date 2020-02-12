//
//  toDoDetailViewController.swift
//  newToDoList
//
//  Created by Ann McDonough on 2/06/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {


    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
   
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var noteView: UITextView!
    
    var toDoItem: ToDoItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if toDoItem == nil{
            toDoItem = ToDoItem(name: "", date: Date(), notes: "")
        }
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text! , date: datePicker.date, notes: noteView.text)
    }


    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil )
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}





