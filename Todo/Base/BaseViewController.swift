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
        view.backgroundColor = .white
        let back = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = back
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

