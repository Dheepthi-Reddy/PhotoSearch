//
//  ImageCollectionViewCell.swift
//  PhotoSearch
//
//  Created by Dheepthi Reddy Vangeti on 6/24/25.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "ImageCollectionViewCell"
    
    // declaring a image view
    private let imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // adding the image view to subview
        contentView.addSubview(imageView)
    }
    
    // required initializer for this class
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // this function is called from the View controller when we pass url for the image
    func configure(with urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else{ return }
            
            DispatchQueue.main.async{
                let image = UIImage(data: data)
                self?.imageView.image = image
            }
        }.resume()
        
    }
}
