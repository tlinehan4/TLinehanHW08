//
//  ListVC.swift
//  WeatherGift
//
//  Created by Timothy Linehan on 3/16/17.
//  Copyright © 2017 Timothy Linehan. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var locationsArray = [String]()
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

   // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPageVC" {
            let controller = segue.destination as! PageVC
            // Identify the table cell (row) that the user tapped
            // This is passed back to PageVc as currentPage, so that
            // PageVC knows which page to create and display.
            currentPage = (tableView.indexPathForSelectedRow?.row)!
            controller.currentPage = currentPage
            controller.locationsArray = locationsArray
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locationsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // we don't need to put any code here becasue the cell triggers a segue.
    }
    
    //MARK: - TableView Editing Functions
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locationsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // First Make a copy of the item that you are going to move
        // delete item from orginal location (pre-move)
        // insert item into the "to", post-move, location
        let itemToMove = locationsArray[sourceIndexPath.row]
        locationsArray.remove(at: sourceIndexPath.row)
        locationsArray.insert(itemToMove, at: destinationIndexPath.row)
        
    }
    
    // MARK: - TableView Code to Freeze the First Cell - No Deleting or Moving
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row == 0 ? false : true )
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
}
