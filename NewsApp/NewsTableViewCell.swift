//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Anand on 25/05/22.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
        
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 22, weight: .semibold)
        return lable
    }()
    private let subtitleLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 17, weight: .light)
        return lable
    }()
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLable)
        contentView.addSubview(subtitleLable)
        contentView.addSubview(newsImageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLable.frame = CGRect(
            x: 10,
            y: 0,
            width: frame.size.width - 170,
            height: 70
        )
        subtitleLable.frame = CGRect(
            x: 10,
            y: 70,
            width: frame.size.width - 200,
            height: contentView.frame.size.height/2
        )
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        )
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLable.text = nil
        subtitleLable.text = nil
        newsImageView.image = nil
    }
    func configure(with viewModel: NewsTableViewCellViewModel ) {
        newsTitleLable.text = viewModel.title
        subtitleLable.text = viewModel.subtitle
        
        
        if let data = viewModel.imageData {
            
            newsImageView.image = UIImage(data: data)
            
        } else if let url = viewModel.imageURL {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
