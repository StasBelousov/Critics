//
//  MovieCriticsData.swift
//  Critics
//
//  Created by Станислав Белоусов on 11/09/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import Foundation

struct MovieCriticsData {
    
    let critics:[Result]?
    
    init? (MovieCriticsData: MovieCritics) {
        critics = MovieCriticsData.results
    }
}



