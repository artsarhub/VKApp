//
//  FriendsTableViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 08.12.2020.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    @IBOutlet weak var serachBar: UISearchBar!
    
    var friends: [User] = [
        User(name: "Анна",
             avatar: UIImage(named: "anna")!,
             album: [UIImage(named: "anna")!, UIImage(named: "alex")!, UIImage(named: "nikita")!]),
        User(name: "Александр",
             avatar: UIImage(named: "alex")!,
             album: [UIImage(named: "anna")!, UIImage(named: "alex")!, UIImage(named: "nikita")!]),
        User(name: "Никита",
             avatar: UIImage(named: "nikita")!,
             album: [UIImage(named: "anna")!, UIImage(named: "alex")!, UIImage(named: "nikita")!]),
    ]
    var filteredFriends = [User]() {
        didSet {
            self.friendsDict.removeAll()
            self.firstLetters.removeAll()
            self.fillFriendsDict()
            tableView.reloadData()
        }
    }
    
    var friendsDict: [Character: [User]] = [:]
    var firstLetters = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.register(FriendsSectionHeader.self, forHeaderFooterViewReuseIdentifier: "FriendsSectionHeader")
        
        self.filteredFriends = self.friends
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        self.firstLetters.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nameFirstLetter = self.firstLetters[section]
        return self.friendsDict[nameFirstLetter]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell
        else { return UITableViewCell() }
        let firstLetter = self.firstLetters[indexPath.section]
        if let users = self.friendsDict[firstLetter] {
            cell.nameLabel.text = users[indexPath.row].name
            cell.avatarView.image = users[indexPath.row].avatar
//            cell.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: cell.avatarView, action: #selector(cell.avatarView.handleTap)))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsSectionHeader") as? FriendsSectionHeader else { return nil }
        sectionHeader.textLabel?.text = String(self.firstLetters[section])
        sectionHeader.contentView.backgroundColor = .systemGray
        return sectionHeader
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        self.firstLetters.map{String($0)}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "showUser",
            let controller = segue.destination as? FriendCollectionViewController,
            let indexPath = tableView.indexPathForSelectedRow
        else { return }
        
        let user = self.filteredFriends[indexPath.row]
        controller.userImages = user.album //.append(user.avatar)
        controller.userAvatar = user.avatar
    }
    
    private func fillFriendsDict() {
        for user in self.filteredFriends {
            let dictKey = user.name.first!
            if var users = self.friendsDict[dictKey] {
                users.append(user)
                self.friendsDict[dictKey] = users
            } else {
                self.firstLetters.append(dictKey)
                self.friendsDict[dictKey] = [user]
            }
        }
        self.firstLetters.sort()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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

}

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterFriends(with: searchText)
    }
    
    fileprivate func filterFriends(with text: String) {
        if text.isEmpty {
            self.filteredFriends = friends
            return
        }
        
        self.filteredFriends = self.friends.filter {$0.name.lowercased().contains(text.lowercased())}
    }
}
