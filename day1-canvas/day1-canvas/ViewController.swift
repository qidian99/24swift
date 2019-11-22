//
//  ViewController.swift
//  day1-canvas
//
//  Created by 齐典 on 11/22/19.
//  Copyright © 2019 齐典. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clearCanvas(_ sender: Any) {
        canvasView.clearCanvas()
    }
    
}

