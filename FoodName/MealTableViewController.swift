//
//  MealTableViewController.swift
//  FoodName
//
//  Created by james king on 18/06/2018.
//  Copyright © 2018 james king. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMeals = LoadMeals(){
            meals += savedMeals
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MealTableViewCell else {
            fatalError("Failed to initialise cell views")
        }
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.mName
        cell.mealImageView.image = meal.mImage
        cell.mealRating.rating = meal.mRating
        
        // Configure the cell...

        return cell
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal{
            if let selectedIndex = tableView.indexPathForSelectedRow{
                meals[selectedIndex.row] = meal
                tableView.reloadRows(at: [selectedIndex], with: .automatic)
            } else {
                let newItem = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newItem], with: .automatic)
            }
            saveMeals()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding new meals")
            break
        case "ShowDetail":
            guard let destinationController = segue.destination as? MealViewController else{
                fatalError("Destination unknown: \(segue.destination)")
            }
            guard let viewSender = sender as? MealTableViewCell else{
                fatalError("Unknown sender: \(String(describing: sender))")
            }
            guard let indexCell = tableView.indexPath(for: viewSender) else{
                fatalError("Selected cell not in view")
            }
            let selectedMeal = meals[indexCell.row]
            destinationController.meal = selectedMeal
            break
        default:
            fatalError("Ass")
            break
        }
    }
    
    private func saveMeals(){
        let successfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ARCHIVE.path)
        if(successfulSave){
            os_log("Save successful")
        } else {
            os_log("Failed to save meals")
        }
    }
    
    private func LoadMeals() -> [Meal]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ARCHIVE.path) as? [Meal]
    }
}
