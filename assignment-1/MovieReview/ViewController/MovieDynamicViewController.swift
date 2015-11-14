//
//  MovieDynamicViewController.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit
import JTProgressHUD

// This is a combination of MovieTableViewController and MovieCollectionViewController
// It has a switch button to switch between these two view mode (see setViewMode)
// It also support displaying data from multiple API end points (see setApiEndpoint)
class MovieDynamicViewController: MovieListViewController, UITabBarDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tabCategory: UITabBar!
    
    @IBOutlet var tabItemMovie: UITabBarItem!
    @IBOutlet var tabItemDvds: UITabBarItem!
    
    // View mode switch button (show at navigation right)
    let btnName = UIButton()
    
    // This view use separate refresh controls, we don't reuse from MovieListViewController
    // because it has to UIScrollView working in parallel
    var refreshControl1 = UIRefreshControl()
    var refreshControl2 = UIRefreshControl()
    
    // Constants
    let VIEW_MODE = (LIST: "list", GRID: "grid")
    let CATEGORY = (MOVIE: "movie", DVD: "dvd")
    
    // Current view controller, it could be UITableView or UICollectionView
    var activeViewController = UIScrollView();
    
    // Controller for tableView
    var handler = MovieListHandler()
    
    // API
    var movieApi = MovieApi()
    
    // This screen displays theater movie
    override func getApi() -> MovieApi {
        return movieApi
    }
    
    // This view controller uses UITableView to display data
    override func getScrollView() -> UIScrollView {
        return activeViewController
    }
    
    // Fill data to UITableView
    override func fillData(movies: [NSDictionary]) {
        self.handler.movies = movies
        // (It makes me supprise that UITableView and UICollectionView has no accient relationship!)
        if (self.activeViewController is UITableView) {
            tableView.reloadData()
        } else if (self.activeViewController is UICollectionView) {
            collectionView.reloadData()
        }
    }
    
    // Set current category
    func setApiEndpoint(category: String) {
        switch (category) {
        case CATEGORY.MOVIE:
            movieApi = TheaterApi()
            break;
        case CATEGORY.DVD:
            movieApi = DvdsApi()
            break;
        default: break
        }
    }
    
    // Set current view mode
    func setViewMode(mode: String) {
        switch (mode) {
        case VIEW_MODE.LIST:
            activeViewController = tableView
            tableView.hidden = false
            collectionView.hidden = true
            break;
        case VIEW_MODE.GRID:
            activeViewController = collectionView
            tableView.hidden = true
            collectionView.hidden = false
            break;
        default: break
        }
    }
    
    override func viewDidLoad() {
        // Set default category is Movies
        // We need to set this before super.viewDidLoad because parent class have to use it
        tabCategory.selectedItem = tabItemMovie
        setApiEndpoint(CATEGORY.MOVIE)
        
        super.viewDidLoad()
        
        // Assign handler
        tableView.dataSource = handler
        tableView.delegate = handler
        collectionView.dataSource = handler
        collectionView.delegate = handler
        
        // By default show list view (UITableView)
        // TODO: bug when first view is hidden, second view as an empty space at the top of the list
        setViewMode(VIEW_MODE.LIST)
        
        // Add refresh control to the other `UIScrollView`s
        addRefreshControls()
        
        // Handler for tab select
        tabCategory.delegate = self
        
        
        // View mode switcher button
        btnName.setImage(UIImage(named: "Grid.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("switchMode"), forControlEvents: .TouchUpInside)
        
        // Set Right Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    // This view use separate refresh controls, we don't reuse from MovieListViewController
    // because it has to UIScrollView working in parallel
    func addRefreshControls() {
        refreshControl1.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl1.addTarget(self, action: "onRefreshTableView", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl1)
        
        refreshControl2.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl2.addTarget(self, action: "onRefreshCollectionView", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl2)
    }
    
    // Refresh from UITableView
    func onRefreshTableView() {
        self.loadMovies({() -> Void in
            self.refreshControl1.endRefreshing()
        })
    }
    
    // Refresh from UICollectionView
    func onRefreshCollectionView() {
        self.loadMovies({() -> Void in
            self.refreshControl2.endRefreshing()
        })
    }
    
    // Handle switch between list and grid view mode
    func switchMode() {
        if (self.activeViewController is UITableView) {
            self.setViewMode(VIEW_MODE.GRID)
            btnName.setImage(UIImage(named: "List.png"), forState: .Normal)
        } else if (self.activeViewController is UICollectionView) {
            self.setViewMode(VIEW_MODE.LIST)
            btnName.setImage(UIImage(named: "Grid.png"), forState: .Normal)
        }
        loadMoviesWithAnimation()
    }
    
    // Handle tabbar item select
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item == tabItemMovie) {
            setApiEndpoint(CATEGORY.MOVIE)
        } else if (item == tabItemDvds) {
            setApiEndpoint(CATEGORY.DVD)
        }
        // Reload movie
        loadMoviesWithAnimation()
    }
    
    // Send movie JSON object to MovieDetail view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var cell = UIView()
        var indexPath = NSIndexPath()
        if (self.activeViewController is UITableView) {
            cell = sender as! MovieTableCell
            indexPath = tableView.indexPathForCell(cell as! UITableViewCell)!
        } else  {
            cell = sender as! MovieCollectionCell
            indexPath = collectionView.indexPathForCell(cell as! UICollectionViewCell)!
        }
        
        let movie = self.handler.movies[indexPath.row]
        let movieDetailViewController = segue.destinationViewController as!MovieDetailViewController
        movieDetailViewController.movie = movie
    }
    

}
