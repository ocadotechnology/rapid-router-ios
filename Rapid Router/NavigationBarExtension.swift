//
//  NavigationBarExtension.swift
//  Rapid Router
//
//  Created by Niket Shah on 14/06/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

@IBDesignable
class NavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavigationBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigationBar()
    }


    func setupNavigationBar() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "RapidRouter-logo"))
        topItem?.rightBarButtonItem = UIBarButtonItem(customView: imageView)
    }
}
