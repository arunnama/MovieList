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
    var imageDownloader = ImageDownload();
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupSearch()
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
            search(name:history[indexPath.row]);
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
                print("searching is happening on ",indexPath.row,movies.count);
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
                    movieCell.imgMovie_poster.image = image
                }
            })
        }
        return movieCell
    }

    // MARK: - Search
    
    func search(name:String, page:Int=1) {
        print("searching for \(name) and page is::: , \(page)")
        DispatchQueue.global(qos: .background).async {
            // let searchItem = self.searchController.searchBar.text
            let searchClient = SearchMovie()
            searchClient.search(name: name, page:page) { movieResults, movieError in
                if (movieError != nil) {
                    self.showErrorAlert(error:movieError!)
                }
                else if (movieResults.total_results == 0){
                     self.showErrorAlert(error:MovieError.NoMoviesFound)
                }
                else{
                    self.updateSearchResults(name, movieResults);
                }
            }
        }
    }
    
    fileprivate func updateSearchResults(_ name:String, _ movieResult: (MovieResults)){
        do {
            tempMovieResults = movieResult
            guard let moviesBatch = movieResult.results else { return }
            print(moviesBatch);
            if (moviesBatch.count > 0)
            {
                if (self.movies.count == 0) {try HistoryDataStore.saveSearch(name)}
                self.movies.append(contentsOf: moviesBatch)
                self.currentSearch = name
                self.tableView.reloadData();
            } else {
                if self.searchController.isActive {
                    self.searchController.dismiss(animated: false) {
                    }
                }
                if (self.movies.count == 0) {
                    self.showErrorAlert(error: MovieError.NoMoviesFound)
                }
            }
            
        }catch{
            self.showErrorAlert(error: MovieError.Unknown)
        }
    }
    
    
    
}
extension MoviesViewController: UISearchBarDelegate {
    
    func setupSearch(){
        tableView.tableHeaderView = searchController.searchBar;
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.text = ""
        searchController.searchBar.resignFirstResponder()
        isSearchInProgress = false;
        searchController.isActive = false;
        tableView.reloadData();
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearchInProgress = false;
        guard let searchText = searchBar.text, !(searchBar.text?.isEmpty)! else {
            return
        }
        movies = []
        isNewSearch = true;
        self.search(name:searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchInProgress = true;
        history = HistoryDataStore.retriveHistory();
        tableView.reloadData();
        searchController.searchBar.showsCancelButton = true
    }
    
}




