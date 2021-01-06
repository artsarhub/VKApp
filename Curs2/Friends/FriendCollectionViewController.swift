//
//  FriendCollectionViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 08.12.2020.
//

import UIKit

class FriendCollectionViewController: UICollectionViewController {
    
    var userImages = [UIImage]()
    var userAvatar: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ShowPhoto",
            let controller = segue.destination as? FullPhotoViewController,
            let cell = sender as? FriendCollectionViewCell,
            let imageIdexPath = self.collectionView.indexPath(for: cell)
        else { return }
        
        controller.album = self.userImages
        controller.index = imageIdexPath.row
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.userImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? FriendCollectionViewCell
        else { return UICollectionViewCell() }
        
        let img = self.userImages[indexPath.row]
        
        cell.avatar.image = img
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
