//
//  MainViewController.swift
//  Critics
//
//  Created by Станислав Белоусов on 11/09/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var ReviewAndCriticSegmentedControl: UISegmentedControl!
    @IBAction func reviewAndCriticSCAction(_ sender: Any) {
    }
    var networkManager = NetworkManager()
    var currentReviewsArray:[Result] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.delegate = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        networkManager.fetchCurrentData(forRequestType: .reviews)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleTopRefresh(_:)), for: .valueChanged )
        mainTableView.addSubview(refreshControl)
        
        setupUIElements()
        
    }
    @objc func handleTopRefresh(_ sender:UIRefreshControl){
        networkManager.fetchCurrentData(forRequestType: .reviews)
        sender.endRefreshing()
        print("refresh")
    }
    func setupUIElements() {
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        ReviewAndCriticSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        ReviewAndCriticSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
}
extension mainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentReviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        
        let review: Result
        
        review = currentReviewsArray[indexPath.row]
        
        let urlString = review.multimedia?.src
        cell.reviewDisplayTitle.text = review.displayTitle
        cell.reviewHeadline.text = review.summaryShort
        cell.reviewByLine.text = review.byline
        cell.reviewDateUpdated.text = review.dateUpdated
        cell.reviewImage.downloaded(from: urlString!)
        
        cell.layer.borderWidth = 2
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let reviewURL = currentReviewsArray[indexPath.row].link?.url else { return }
        
        if let url = NSURL(string: reviewURL){
            UIApplication.shared.openURL(url as URL)
        }
    }
}
extension mainViewController: NetworkManagerDelegate {
    func updateReviews(_: NetworkManager, with currentReviews: ReviewsData) {
        currentReviewsArray = currentReviews.reviews!
        
        print(currentReviewsArray.count)
        
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    func updateCritics(_: NetworkManager, with currentCritics: MovieCriticsData) {
        
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
