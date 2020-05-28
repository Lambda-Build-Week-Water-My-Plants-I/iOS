//
//  TableViewController.swift
//  Water My Plants
//
//  Created by Ezra Black on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nickname", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "h2o_frequency", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error performing initial fetch inside fetchedResultsController: \(error)")
        }
        return frc
    }()
    
    let plantController = PlantController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        plantController.fetchPlantsFromServer()
//            { result in
//            if let _ = try? result.get() {
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
    }
    
    // MARK: - DAHNA'S CODE
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserController.shared.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            plantController.fetchPlantsFromServer()
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as? PlantCell else { fatalError("Unable to connect") }
        cell.plant = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//          guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
//          return sectionInfo.name.capitalized
//      }


    // MARK: - DELETE PLANT FROM TB FUNC
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let plant = fetchedResultsController.object(at: indexPath)
            plantController.deletePlantsFromServer(plant) { result in
                guard let _ = try? result.get() else {
                    return
                }
                DispatchQueue.main.async {
                    let context = CoreDataStack.shared.mainContext
                    context.delete(plant)
                    do {
                        try context.save()
                    } catch {
                        context.reset()
                        NSLog("Error saving managed object context (delete plant): \(error)")
                    }
                }
            }
        }
    }
    


    // TODO
    // MARK: - NAVIGATION

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPlantSegue" {
            if let addPlantVC = segue.destination as? AddPlantViewController {
                addPlantVC.controller = self.plantController
            }
        }
//
//        }
//        // DetailViewController
//        if segue.identifier == "PlantDetailSegue" {
//            if let detailVC = segue.destination as? DetailViewViewController {
//                detailVC.controller = self.plantController
//            }
//        }'
//        //EditProfile
//        if segue.identifier == "EditProfileSegue" {
//
//        }
//    }
    }
    
} // EOC


extension TableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
