//
//  ViewController.swift
//  CustomControl
//
//  Created by uvionics on 2/26/18.
//  Copyright © 2018 uvionics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
let slider = Slider(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        //slider.backgroundColor = UIColor.green
        self.view.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    override func viewDidLayoutSubviews() {
        let xValue: CGFloat = 20.0
        let width = self.view.bounds.width - 2.0 * xValue
        slider.frame = CGRect(x: xValue, y: xValue + self.view.safeAreaInsets.top, width: width, height: 30.0)
        
        
    }
    
    @objc func sliderValueChanged(slider: Slider) {
        print(slider.upperValue)
        print(slider.lowerValue)
    }
}

