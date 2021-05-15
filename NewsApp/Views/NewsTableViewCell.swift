//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Prashant Gaikwad on 15/05/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight:.semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,weight:.light)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsImgView: UIImageView = {
       let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 6
        imgView.layer.masksToBounds = true
        imgView.backgroundColor = .systemGray
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.size.width-170,
                                      height: 70
        )
        
        subTitleLabel.frame = CGRect(x: 10,
                                      y: 70,
                                      width: contentView.frame.size.width-170,
                                      height: contentView.frame.size.height/2
        )
        
        newsImgView.frame = CGRect(x: contentView.frame.size.width - 150,
                                      y: 5,
                                      width: 140,
                                      height: contentView.frame.size.height - 10
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImgView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle

        if let data = viewModel.imgData {
            newsImgView.image = UIImage(data:data)
        } else if let url = URL(string:viewModel.imageUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                //viewModel.imgData = data
                DispatchQueue.main.async {
                    self?.newsImgView.image = UIImage(data:data)
                }
            }.resume()
        }
    }
    
}
