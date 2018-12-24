//
//  CustomCallOut.swift
//  Hello-maps
//
//  Created by Pranalee Jadhav on 12/24/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit

class CustomCalloutView :UIView {
    
    private var annotation :CustomAnnotation!
    
    init(annotation :CustomAnnotation, frame :CGRect = CGRect.zero) {
        super.init(frame: frame)
        self.annotation = annotation
        self.frame = frame
        configure()
    }
    
    func add(to view :UIView) {
        
        view.addSubview(self)
        
        self.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -5).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func configure() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(displayP3Red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        
        // text label
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = UIColor.white
        titleLabel.text = annotation.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
