//
//  ViewController.swift
//  ToDoAppRealm
//
//  Created by Yogesh Patel on 15/02/22.
//

import RealmSwift
import UIKit

class Contact: Object{
    @Persisted var firstname: String = ""
    @Persisted var lastname: String = ""
    
    convenience init(firstname: String, lastname: String){
        self.init()
        self.firstname = firstname
        self.lastname = lastname
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var contactTableView: UITableView!
    
    var contactArray = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    @IBAction func addContactTapped(_ sender: UIBarButtonItem) {
        self.contactConfiguration(isAdd: true)
    }
}

extension ViewController{
    
    func configuration(){
        contactTableView.dataSource = self
        contactTableView.delegate = self
        contactArray = DatabaseHelper.shared.getAllContacts()
        contactTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{
            return UITableViewCell()
        }
        
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = contactArray[indexPath.row].firstname
        cell.detailTextLabel?.text = contactArray[indexPath.row].lastname
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate{
    
    //CRUD
    func contactConfiguration(isAdd: Bool, index: Int = 0){
        
        let alertController = UIAlertController(title: isAdd ?  "Add Contact" : "Update Contact", message: isAdd ? "Please add your contact details" : "Please update your contact details", preferredStyle: .alert)
        
        let save = UIAlertAction(title: isAdd ? "Save" : "Update", style: .default) { _ in
            if let firstname = alertController.textFields?.first?.text, let lastname = alertController.textFields?[1].text{
                let contact = Contact(firstname: firstname, lastname: lastname)
                
                if isAdd{
                    //Append
                    self.contactArray.append(contact) //Append
                    DatabaseHelper.shared.saveContact(contact: contact)
                }else{
                    //Update
                    //self.arrData[index] = contact //Update
                    DatabaseHelper.shared.updateContact(oldContact: self.contactArray[index], newContact: contact)
                }
                
                self.contactTableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("cancel tapped")
        }
        
        alertController.addTextField { firstnameField in
            firstnameField.placeholder = isAdd ? "Enter your firstname" : self.contactArray[index].firstname
        }
        
        alertController.addTextField { lastnameField in
            lastnameField.placeholder = isAdd ? "Enter your lastname": self.contactArray[index].lastname
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.contactConfiguration(isAdd: false, index: indexPath.row)
        }
        edit.backgroundColor = .systemMint
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            DatabaseHelper.shared.deleteContact(contact: self.contactArray[indexPath.row])
            self.contactArray.remove(at: indexPath.row)
            self.contactTableView.reloadData()
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipeConfiguration
        
    }
}
