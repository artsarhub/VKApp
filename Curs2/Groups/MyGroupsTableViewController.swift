//
//  MyGroupsTableViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit
import RealmSwift

class MyGroupsTableViewController: UITableViewController {
    
    @IBOutlet weak var mySerachBar: UISearchBar!
    
    var myGroups: Results<Group>? {
        didSet {
            self.filteredGroups = self.myGroups
            self.tableView.reloadData()
        }
    }
    
    var notificationToken: NotificationToken?
    
//    var myGroups = [Group]() {
//        didSet {
//            self.filteredGroups = self.myGroups
//        }
//    }
    var filteredGroups: Results<Group>? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            segue.identifier == "addGroup",
            let controller = segue.source as? AllGroupsTableViewController,
            let indexPath = controller.tableView.indexPathForSelectedRow,
            let myGroups = self.myGroups,
            !myGroups.contains(where: {$0.name == controller.allGroups[indexPath.row].name})
        else { return }
        
        let group = controller.allGroups[indexPath.row]
//        self.myGroups.append(group)
        var newGroupList = Array(myGroups)
        newGroupList.append(group)
        RealmService.save(items: newGroupList)
//        self.filteredGroups.append(group)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySerachBar.delegate = self
        tableView.rowHeight = 60
        
        let networkService = NetworkService()
//        networkService.loadGroups() { [weak self] groups in
////            self?.myGroups = groups
//        }
        networkService.loadGroups()
        
        self.myGroups = try? RealmService.getBy(type: Group.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.notificationToken = self.myGroups?.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                self.tableView.reloadData()
            case let .update(_,
                             deletions,
                             insertions,
                             modifications):
                self.tableView.update(deletions: deletions,
                                      insertions: insertions,
                                      modifications: modifications)
            case .error(let error):
                self.show(error: error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.notificationToken?.invalidate()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredGroups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }
        
        if let group = self.filteredGroups?[indexPath.row] {
            cell.configure(with: group)
        }
//        cell.nameLabel.text = group.name
//        cell.avatar.imageURL = group.photo100

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let g = self.filteredGroups?[indexPath.row],
                  let objectToDelete = self.myGroups?.filter("NOT id != %@", g.id)
            else { return }
            RealmService.delete(objectToDelete)
//            try? Realm().write {
//                try? Realm().delete(objectToDelete)
//            }
//            let removed = self.filteredGroups.remove(at: indexPath.row)
//            if let index = self.convertToArray(results: self.myGroups).firstIndex(of: removed) {
//                var newGroupList = self.convertToArray(results: self.myGroups)
//                newGroupList.remove(at: index)
//                try? RealmServce.save(items: newGroupList)
//            }
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension MyGroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterGroups(with: searchText)
    }
    
    fileprivate func filterGroups(with text: String) {
        if text.isEmpty {
            self.filteredGroups = self.myGroups
            self.tableView.reloadData()
            return
        }
//        self.filteredGroups = self.myGroups.filter {$0.name.lowercased().contains(text.lowercased())}
        self.filteredGroups = self.myGroups?.filter("name CONTAINS[cd] %@", text)
        self.tableView.reloadData()
    }
}

//extension MyGroupsTableViewController {
//    private func convertToArray <T>(results: Results<T>?) -> [T] {
//        guard let results = results else { return [] }
//        return Array(results)
//    }
//}
