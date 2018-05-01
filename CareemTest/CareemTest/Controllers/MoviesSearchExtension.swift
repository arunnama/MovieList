//
//  MoviesSearchExtension.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 1/5/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

extension MoviesViewController: UISearchBarDelegate {
    
   
    
    func setupSearch(){
        tableView.tableHeaderView = searchController.searchBar;
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
    }
   
    // MARK: - SearchBar Delegates
    
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
        searchController.isActive = false
        isNewSearch = true;
        self.search(name:searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchInProgress = true;
        history = historyDS.retriveHistory();
        tableView.reloadData();
        searchController.searchBar.showsCancelButton = true
    }
    
    // MARK: - Search 
    
    fileprivate func handleSearchResults(_ name: String, _ movieError: MovieError?, _ movieResults: MovieResults) {
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
    
    func search(name:String, page:Int=1) {
        DispatchQueue.global(qos: .background).async {
            // let searchItem = self.searchController.searchBar.text
            let searchClient = SearchMovie()
            searchClient.search(name: name, page:page) { movieResults, movieError in
                self.handleSearchResults(name, movieError, movieResults)
            }
        }
    }
    
    fileprivate func updateSearchResults(_ name:String, _ movieResult: (MovieResults)){
        do {
            tempMovieResults = movieResult
            guard let moviesBatch = movieResult.results else { return }
            if (moviesBatch.count > 0)
            {
                if (self.movies.count == 0) {try historyDS.saveSearch(name)}
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
