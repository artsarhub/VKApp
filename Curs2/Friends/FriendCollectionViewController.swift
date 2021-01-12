//
//  FriendCollectionViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 08.12.2020.
//

import UIKit

class FriendCollectionViewController: UICollectionViewController {
    
    @IBAction func closeFullPhotoView(_ unwindSegue: UIStoryboardSegue) {}
    
    var userImages = [UIImage]()
    var userAvatar: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

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
        
        cell.image.image = img
        
        return cell
    }

}
