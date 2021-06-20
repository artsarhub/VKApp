//
//  NewsTableViewController.swift
//  Curs2
//
//  Created by Артём Сарана on 23.12.2020.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private var posts: [Post] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var isNewsLoading = false
    private var feedNextFromAnchor: String?
    private var openedTextCells: [IndexPath: Bool] = [:]
    private let networkService = NetworkService()
    private let textFont = UIFont.systemFont(ofSize: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerNib = UINib(nibName: "PostHeaderView",
                              bundle: nil)
        self.tableView.register(headerNib,
                                forCellReuseIdentifier: "HeaderCell")
        let footerNib = UINib(nibName: "FooterTableViewCell",
                              bundle: nil)
        self.tableView.register(footerNib,
                                forCellReuseIdentifier: "FooterCell")
        self.tableView.register(PostTableViewCell.self,
                                forCellReuseIdentifier: "PostTableViewCell")
        let photoNib = UINib(nibName: "PhotoTableViewCell",
                              bundle: nil)
        self.tableView.register(photoNib,
                                forCellReuseIdentifier: "PhotoCell")
        
        //        self.tableView.estimatedRowHeight = 44
        //        self.tableView.rowHeight = UITableView.automaticDimension
        
        networkService.loadNewsFeed() { [weak self] posts, nextFromAnchor in
            guard let self = self else { return }
            self.posts = posts
            self.feedNextFromAnchor = nextFromAnchor
        }
        
        self.refreshControl = UIRefreshControl()
//        refreshControl?.attributedTitle = NSAttributedString(string: "...")
        refreshControl?.tintColor = .systemTeal
        refreshControl?.addTarget(self, action: #selector(refreshControllPulled), for: .valueChanged)
        
        tableView.prefetchDataSource = self
    }
    
    @objc private func refreshControllPulled() {
        guard let firstPost = posts.first else { self.refreshControl?.endRefreshing(); return }
        
        networkService.loadNewsFeed(startTime: firstPost.date) { [weak self] posts, nextFromAnchor in
            guard let self = self else { return }
            self.posts.insert(contentsOf: posts, at: 0)
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? PostHeaderView
            else { return PostHeaderView() }
            let postHeaderDisplayItem = PostHeaderDisplayItemsFactory.make(for: post)
            cell.configure(with: postHeaderDisplayItem)
            return cell
        case 1:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as? PostTableViewCell
            else { return PostTableViewCell() }
            cell.selectionStyle = .none
            cell.configure(with: post, font: textFont)
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
        case 1:
            let maximumCellHeight: CGFloat = 100
            let text = posts[indexPath.section].text
            guard !text.isEmpty else { return 0 }
            
            let availableWidth = tableView.frame.width - 2 * PostTableViewCell.horizontalInset
            let desiredLabelHeight = getLabelSize(text: text, font: textFont, availableWidth: availableWidth).height + 2 * PostTableViewCell.verticalInset
            
            let isOpened = openedTextCells[indexPath] ?? false
            return isOpened ? desiredLabelHeight : min(maximumCellHeight, desiredLabelHeight)
        case 2:
            let aspectRatio = posts[indexPath.section].aspectRatio
            return tableView.frame.width * aspectRatio
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 3:
            return 60
        case 2:
            let aspectRatio = posts[indexPath.section].aspectRatio
            return tableView.frame.width * aspectRatio
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let currentValue = openedTextCells[indexPath] ?? false
            openedTextCells[indexPath] = !currentValue
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let feedNextFromAnchor = feedNextFromAnchor,
              let maxIndexPath = indexPaths.max(),
              maxIndexPath.section >= (posts.count - 3),
              !isNewsLoading
        else { return }
        
        isNewsLoading = true
        networkService.loadNewsFeed(nextFrom: feedNextFromAnchor) { [weak self] posts, nextFromAbchor in
            guard let self = self else { return }
            self.posts.append(contentsOf: posts)
            self.isNewsLoading = false
            self.feedNextFromAnchor = nextFromAbchor
        }
    }
}

func getLabelSize(text: String, font: UIFont, availableWidth: CGFloat) -> CGSize {
    //получаем размеры блока, в который надо вписать надпись
    //используем максимальную ширину и максимально возможную высоту
    let textBlock = CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude)
    //получим прямоугольник, который займёт наш текст в этом блоке, уточняем, каким шрифтом он будет написан
    let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    //получаем ширину блока, переводим ее в Double
    let width = Double(rect.size.width)
    //получаем высоту блока, переводим ее в Double
    let height = Double(rect.size.height)
    //получаем размер, при этом округляем значения до большего целого числа
    let size = CGSize(width: ceil(width), height: ceil(height))
    return size
}
