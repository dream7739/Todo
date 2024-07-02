//
//  BaseViewController.swift
//  Todo
//
//  Created by 홍정민 on 7/2/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureHierarchy()
        configureLayout()
        configureUI()
    }

    func configureHierarchy(){
        print(#function)
    }
    
    func configureLayout(){
        print(#function)

    }
    
    func configureUI(){
        print(#function)

    }
}

