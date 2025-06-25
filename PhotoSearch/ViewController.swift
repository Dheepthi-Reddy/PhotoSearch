//
//  ViewController.swift
//  PhotoSearch
//
//  Created by Dheepthi Reddy Vangeti on 6/20/25.
//

import UIKit

// Codable protocol to convert the data which comes as bytes to JSON key value pairs
struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    // array of results
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let regular: String
}

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    
    // created a basic collection view
    private var collectionView: UICollectionView?
    
    // save them like global property to access in UI code
    var results: [Result] = []
    
    // declaring UI search bar
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assigning the delegate to self
        searchBar.delegate = self
        // adding to sub view
        view.addSubview(searchBar)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width/2, height: view.frame.width/2)
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        
        // registering the custom cell with the identifier
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width-20,
                                 height: 50)
        collectionView?.frame = CGRect(x: 0,
                                       y: view.safeAreaInsets.top+55,
                                       width: view.frame.size.width,
                                       height: view.frame.size.height-55)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // to dissmiss the keyboard when clicked
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            // emptying the results
            results = []
            // reloading the data
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }
    
    func fetchPhotos(query: String){
        
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id=Fda4mOweHALYvG0HAnKVxM6jZ1eSoh-NrOJk501ET5Y"

        
        // converting url string to a object
        guard let url = URL(string: urlString) else{
            return
        }
        
        // create a URL Session
        // pass the url
        // completion handler has the "data" coming from other side,
                                    // "_" the response which are going to ignore,
                                    // next one is "error" which is optional
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            // unwrapping the data
            guard let data = data, error == nil else{
                return
            }
            
            // to check if the API network call is working
            print("Got data")
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageURLString = results[indexPath.row].urls.regular

        guard let cell = collectionView.dequeueReusableCell(
            
            // added the custom cell identifier
            withReuseIdentifier: ImageCollectionViewCell.identifier,
            for: indexPath
            // casting this cell as custom cell
        ) as? ImageCollectionViewCell else {
            // if we are unable to cast it we fallback to normal UICollectionViewCell
            return UICollectionViewCell()
        }
        
        // cell.backgroundColor = .systemBlue
        cell.configure(with: imageURLString)
        return cell
    }
}

