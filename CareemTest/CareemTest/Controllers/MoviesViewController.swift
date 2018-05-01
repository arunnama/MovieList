//
//  MoviesViewControllerTableViewController.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 29/4/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController {
    
    var movies: [Movie] = []
    var history: [String] = []
    var isSearchInProgress = false
    var tempMovieResults = MovieResults()
    var currentPage: Int = 0;
    var isNewSearch = true;
    var currentSearch = ""
    var pagePreloadMargin = 10;
    let imageDownloader = ImageDownload();
    let historyDS = HistoryDataStore()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        definesPresentationContext = true
        self.setupSearch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let imageCache = NSCache<NSString, UIImage>();
        imageCache.removeAllObjects();
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isSearchInProgress ? history.count : movies.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isSearchInProgress)
        {
            isNewSearch = true;
            isSearchInProgress = false;
            movies = []
            searchController.searchBar.resignFirstResponder()
            searchController.isActive = false
            self.search(name:history[indexPath.row]);
        }
    }
    
    // MARK: - Table view dalegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isSearchInProgress) {
            let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
            historyCell.textLabel?.text = history[indexPath.row]
            return historyCell;
        }
        else {
            return configureCell(tableView, indexPath)
        }
    }
   
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ( indexPath.row == (movies.count - pagePreloadMargin) ){
            if (tempMovieResults.page < tempMovieResults.total_pages)  {
                search(name:currentSearch,page: tempMovieResults.page + 1)
            }
        }
    }
    
    fileprivate func configureCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let movieCell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell;
        movieCell.lblMovie_title.text = movies[indexPath.row].title
        movieCell.lblRelease_date.text = movies[indexPath.row].release_date
        movieCell.lblOverview.text = movies[indexPath.row].overview
        movieCell.imgMovie_poster.image = nil;
        DispatchQueue.global(qos: .background).async {
            guard let poster_path = self.movies[indexPath.row].poster_path else { return }
            self.imageDownloader.downloadImage(url: poster_path, completion: { (image, error) in
                DispatchQueue.main.async {
                    guard let movieCellUpdate = tableView.cellForRow(at: indexPath) as? MovieCell else { return }
                    movieCellUpdate.imgMovie_poster.image = image
                }
            })
        }
        return movieCell
    }
}







