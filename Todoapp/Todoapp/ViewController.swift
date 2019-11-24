//
//  ViewController.swift
//  Todoapp
//
//  Created by 齐典 on 11/24/19.
//  Copyright © 2019 齐典. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let todoItem = TodoItem(title: "test 2", completed: false, createdAt: Date(), itemIdentifier: UUID())
        
        let todos = DataManager.loadAll(TodoItem.self)
        
        print(todos)
    }


}

