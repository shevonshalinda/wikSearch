//
//  File.swift
//  testapp
//
//  Created by Digital-02 on 9/21/19.
//  Copyright © 2019 Digital-02. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum NetworkError: Error
{
    case failure
    case success
}

class apiRequestFetcher{
    func search(searchText: String, complentionHandler: @escaping([JSON]?,
        NetworkError)-> ()){
        let urlToSearch = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=\(searchText)&gpslimit=10"
        
        Alamofire.request(urlToSearch).responseJSON{ response in
            guard let data = response.data else{
                complentionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            let results = json?["query"]["pages"].arrayValue
            guard let empty = results?.isEmpty, !empty else{
                complentionHandler(nil, .failure)
                return
                
            }
            complentionHandler(results, .success)
        }
        
    }
    
    
    func fetchImage(url: String, completionHandler: @escaping (UIImage?, NetworkError) -> ()) {
        Alamofire.request(url).responseData { responseData in
            
            guard let imageData = responseData.data else {
                completionHandler(nil, .failure)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                completionHandler(nil, .failure)
                return
            }
            
            completionHandler(image, .success)
        }
    }
    
    
}
