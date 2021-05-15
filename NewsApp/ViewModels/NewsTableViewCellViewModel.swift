//
//  NewsTableViewCellViewModel.swift
//  NewsApp
//
//  Created by Prashant Gaikwad on 15/05/21.
//

import Foundation

class NewsTableViewCellViewModel {
    let title: String
    let subTitle: String
    let imageUrl: String
    let imgData: Data? = nil
    
    init(title: String,
         subTitle: String,
         imageUrl: String
    ) {
        self.title = title
        self.subTitle = subTitle
        self.imageUrl = imageUrl
    }
}
