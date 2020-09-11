//
//  ViewController.swift
//  Critics
//
//  Created by Станислав Белоусов on 11/09/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        networkManager.delegate = self
    
    }
}
extension MainViewController: NetworkManagerDelegate {
    func updateReviews(_: NetworkManager, with currentReviews: ReviewsData) {
        print(currentReviews)
    }
    
    func updateInteface(_: NetworkManager, with currentCritics: MovieCriticsData) {
        print(currentCritics)
        
    }
}
