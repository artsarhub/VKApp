//
//  FriendsTableViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 08.12.2020.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    var friends: [User] = [
        User("Анна", UIImage(named: "anna")!),
        User("Александр", UIImage(named: "alex")!),
        User("Никита", UIImage(named: "nikita")!),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell
        else { return UITableViewCell() }
        cell.nameLabel.text = self.friends[indexPath.row].name
        cell.avatarImageView.image = self.friends[indexPath.row].avatar
        cell.avatarImageView.makeRounded()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let controller = segue.destination as? FriendCollectionViewController,
            let indexPath = tableView.indexPathForSelectedRow
        else { return }
        
        let user = self.friends[indexPath.row]
        controller.userImages.append(user.avatar)
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

extension UIImageView {

    func makeRounded() {

        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true;
    }
}