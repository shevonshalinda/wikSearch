//
//  SearchResultTableViewController.swift
//  testapp
//
//  Created by Digital-02 on 9/21/19.
//  Copyright © 2019 Digital-02. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class SearchResultTableViewController: UITableViewController {
    
    
    
    
    private var previousRun = Date()
    private let minInterval = 0.05
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchResults = [JSON](){
        didSet{
            tableView.reloadData()
        }
    }
    
    private let apiFetcher = apiRequestFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableViewBackgroundView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //fetchResults(for: "Google")
    }
 
    

    
    private func setupSearchBar()
    {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "wiki search"
        navigationItem.searchController = searchController
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    private func setupTableViewBackgroundView()
    {
        let lable = UILabel(frame: .zero)
        lable.textColor = UIColor.gray
        lable.numberOfLines = 0
        lable.textAlignment = .center
        lable.text = "oops,  No results to show! ..."
        tableView.separatorStyle = .none
        tableView.backgroundView = lable
    }
    
    // MARK: - Table view data sourcez

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(searchResults.count)
        return searchResults.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wikiCell", for: indexPath) as! wikiTableViewCell

        cell.Title.text = searchResults[indexPath.row]["title"].stringValue
        cell.Description.text = searchResults[indexPath.row]["terms"]["description"][0].string

        if let url = searchResults[indexPath.row]["thumbnail"]["source"].string {
                    print(url)
            apiFetcher.fetchImage(url: url, completionHandler: { image, _ in
                cell.imgView?.image = image
            })
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = searchResults[indexPath.row]["title"].stringValue
        guard let url = URL.init(string: "https://en.wikipedia.org/wiki/\(title)")
            else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

extension SearchResultTableViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print ("From searchBar ", searchText)

        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }

    }
    
    func fetchResults(for text:String){
        apiFetcher.search(searchText: text, complentionHandler:{
            [weak self] results,error in
            if case.failure = error{
                return
            }
            guard let results = results, !results.isEmpty else{
                return
            }
            
            //print("results of\(text) = ", results)
            
            self?.searchResults =  results
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }

}
