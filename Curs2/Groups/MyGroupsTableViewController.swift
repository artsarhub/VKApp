//
//  MyGroupsTableViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit

class MyGroupsTableViewController: UITableViewController {
    
    @IBOutlet weak var mySerachBar: UISearchBar!
    
    var myGroups = [Group]()
    var filteredGroups = [Group]()
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            segue.identifier == "addGroup",
            let controller = segue.source as? AllGroupsTableViewController,
            let indexPath = controller.tableView.indexPathForSelectedRow,
            !self.myGroups.contains(where: {$0.name == controller.allGroups[indexPath.row].name})
        else { return }
        
        let group = controller.allGroups[indexPath.row]
        self.myGroups.append(group)
        self.filteredGroups.append(group)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySerachBar.delegate = self
        self.filteredGroups = myGroups
        tableView.rowHeight = 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell
        else { return UITableViewCell() }
        
        let group = self.filteredGroups[indexPath.row]
        cell.nameLabel.text = group.name
        cell.avatar.image = group.logoImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removed = self.filteredGroups.remove(at: indexPath.row)
            if let index = self.myGroups.firstIndex(of: removed) {
                self.myGroups.remove(at: index)
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        self.filteredGroups = self.myGroups.filter {$0.name.lowercased().contains(text.lowercased())}
        self.tableView.reloadData()
    }
}
