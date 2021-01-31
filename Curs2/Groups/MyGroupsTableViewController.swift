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
    
    var myGroups = try? Realm().objects(Group.self) {
        didSet {
            self.filteredGroups = self.convertToArray(results: self.myGroups)
            self.tableView.reloadData()
        }
    }
    
//    var myGroups = [Group]() {
//        didSet {
//            self.filteredGroups = self.myGroups
//        }
//    }
    var filteredGroups = [Group]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            segue.identifier == "addGroup",
            let controller = segue.source as? AllGroupsTableViewController,
            let indexPath = controller.tableView.indexPathForSelectedRow,
            !self.convertToArray(results: self.myGroups).contains(where: {$0.name == controller.allGroups[indexPath.row].name})
        else { return }
        
        let group = controller.allGroups[indexPath.row]
//        self.myGroups.append(group)
        var newGroupList = self.convertToArray(results: self.myGroups)
        newGroupList.append(group)
        try? RealmServce.save(items: newGroupList)
        self.filteredGroups.append(group)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySerachBar.delegate = self
        self.filteredGroups = self.convertToArray(results: self.myGroups)
        tableView.rowHeight = 60
        
        let networkService = NetworkService()
        networkService.loadGroups() { [weak self] groups in
//            self?.myGroups = groups
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }
        
        let group = self.filteredGroups[indexPath.row]
        cell.configure(with: group)
//        cell.nameLabel.text = group.name
//        cell.avatar.imageURL = group.photo100

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removed = self.filteredGroups.remove(at: indexPath.row)
            if let index = self.convertToArray(results: self.myGroups).firstIndex(of: removed) {
                var newGroupList = self.convertToArray(results: self.myGroups)
                newGroupList.remove(at: index)
                try? RealmServce.save(items: newGroupList)
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
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
            self.filteredGroups = self.convertToArray(results: self.myGroups)
            self.tableView.reloadData()
            return
        }
        self.filteredGroups = self.convertToArray(results: self.myGroups).filter {$0.name.lowercased().contains(text.lowercased())}
        self.tableView.reloadData()
    }
}

extension MyGroupsTableViewController {
    private func convertToArray <T>(results: Results<T>?) -> [T] {
        guard let results = results else { return [] }
        return Array(results)
    }
}
