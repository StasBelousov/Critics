//
//  NetworkManager.swift
//  Critics
//
//  Created by Станислав Белоусов on 11/09/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import Foundation
import CoreLocation

protocol NetworkManagerDelegate: class {
    func updateInteface (_:NetworkManager, with currentCritics: MovieCriticsData)
    func updateReviews (_:NetworkManager, with currentReviews: ReviewsData)
}

class NetworkManager {
    
    var delegate: NetworkManagerDelegate?
    var currentCriticsData:[MovieCriticsData] = []
    
    enum RequestType {
        case critics
        case reviews
    }
    
    func fetchCurrentData(forRequestType requestType:RequestType) {
        var urlString = ""
        switch requestType {
        case .critics: urlString = "https://api.nytimes.com/svc/movies/v2/critics/all.json?api-key=\(apiKey)"
        print(urlString)
        case .reviews:
            urlString = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=\(apiKey)"
            print(urlString)
        }
        performRequest(withURLString: urlString.encodeUrl)
    }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                if let data = data {
                    if let currentData = self.JSONdecoder(withData: data) {
                        self.delegate?.updateInteface(self, with: currentData)
                    };
                    if let currentReviewsData = self.JSONdecoderReviews(withData: data) {
                        self.delegate?.updateReviews(self, with: currentReviewsData)
                    };
                }
            }
        }
        task.resume()
    }
    
    func JSONdecoder(withData data: Data) -> MovieCriticsData? {
        let decoder = JSONDecoder()
        do {
            let currentMovieCritics = try decoder.decode(MovieCritics.self, from: data)
            guard let currentCritics = MovieCriticsData(MovieCriticsData: currentMovieCritics) else { return nil }
            return currentCritics
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    func JSONdecoderReviews(withData data: Data) -> ReviewsData? {
        let decoder = JSONDecoder()
        do {
            let currentReviews = try decoder.decode(MovieCritics.self, from: data)
            guard let currentReview = ReviewsData(ReviewData: currentReviews) else { return nil }
            return currentReview
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
extension String{ //URL cyrillic fix
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}

