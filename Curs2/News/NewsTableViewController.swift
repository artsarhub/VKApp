//
//  NewsTableViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 23.12.2020.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var posts: [Post]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.tableView.register(PostHeaderView.self,
        //                                forCellReuseIdentifier: "PostHeaderCell")
        
        let headerNib = UINib(nibName: "PostHeaderView",
                              bundle: nil)
        self.tableView.register(headerNib,
                                forCellReuseIdentifier: "HeaderCell")
        let footerNib = UINib(nibName: "FooterTableViewCell",
                              bundle: nil)
        self.tableView.register(footerNib,
                                forCellReuseIdentifier: "FooterCell")
        let postNib = UINib(nibName: "PostTableViewCell",
                              bundle: nil)
        self.tableView.register(postNib,
                                forCellReuseIdentifier: "PostTableViewCell")
        let photoNib = UINib(nibName: "PhotoTableViewCell",
                              bundle: nil)
        self.tableView.register(photoNib,
                                forCellReuseIdentifier: "PhotoCell")
        
        //        self.tableView.estimatedRowHeight = 44
        //        self.tableView.rowHeight = UITableView.automaticDimension
        
        let networkService = NetworkService()
        networkService.loadNewsFeed() { posts in
            self.posts = posts
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        guard
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell
        //        else { return NewsTableViewCell() }
        //
        //        let curPost = self.posts?[indexPath.row]
        //        cell.avatarImage.image = curNews.groupLogo
        //        cell.groupName.text = curNews.title
        //        cell.dateLabel.text = curNews.date
        //        cell.newsImage.image = curNews.images[0]
        //        cell.textView.text = curNews.text
        //        cell.likeControll.likesCount = curNews.likes
        //        cell.visitedCount.text = String(curNews.views)
        
        //        let ratio = CGFloat(cell.newsImage.image?.size.width ?? 0 / (cell.newsImage.image?.size.height ?? 1))
        //        let cropHeight = self.tableView.frame.width / ratio
        
        guard let post = self.posts?[indexPath.section]
        else { return PostTableViewCell() }
        
        switch indexPath.row {
        case 0:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? PostHeaderView
            else { return PostHeaderView() }
            cell.configure(with: post)
            return cell
        case 1:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as? PostTableViewCell
            else { return PostTableViewCell() }
            cell.configure(with: post)
            return cell
        case 2:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as? PhotoTableViewCell
            else { return PhotoTableViewCell() }
            cell.configure(with: post)
            return cell
        case 3:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "FooterCell") as? FooterTableViewCell
            else { return FooterTableViewCell() }
            cell.configure(with: post)
            return cell
        default:
            return PostHeaderView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 3:
            return 60
        //        case 2:
        //            return 60
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2:
            return 60
        //        case 2:
        //            return 60
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
