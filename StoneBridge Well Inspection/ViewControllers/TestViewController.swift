//
//  TestViewController.swift
//  StoneBridge Well Inspection
//
//  Created by Joshua on 10/9/20.
//  Used to learn how to programatically add to a view


import UIKit

class TestViewController: UIViewController {

    var redSquare: UIView! 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //make a basic view that will be red
        redSquare = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 100))
        redSquare.backgroundColor = UIColor.red
        view.addSubview(redSquare)
    }


}
