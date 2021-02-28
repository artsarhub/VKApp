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
        
        self.tableView.register(PostHeaderView.nib,
                                forCellReuseIdentifier: PostHeaderView.reuseIdentifier)
        self.tableView.register(FooterTableViewCell.nib,
                                forCellReuseIdentifier: FooterTableViewCell.reuseIdentifier)

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
        
        switch indexPath.row {
        case 0:
            guard
                let post = self.posts?[indexPath.section],
                let cell = self.tableView.dequeueReusableCell(withIdentifier: PostHeaderView.reuseIdentifier) as? PostHeaderView
            else { return PostHeaderView() }
            cell.configure(with: post)
            return cell
        case 1:
            return PostHeaderView()
        case 2:
//            guard
//                let post = self.posts?[indexPath.section],
//                let cell = self.tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.reuseIdentifier) as? FooterTableViewCell
//            else { return FooterTableViewCell() }
//            cell.configure(with: post)
//            return cell
        return FooterTableViewCell()
        default:
            return PostHeaderView()
        }

//        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 60
        case 2:
            return 40
        default:
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
