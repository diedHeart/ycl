//
//  ViewController.swift
//  GestureLock
//
//  Created by 刘佳  on 2022/6/13.
//

import UIKit

class ViewController: UIViewController,LockViewDelegate {
   
    func didPanEnded(password: String) {
        self.label.text = "密码是:\(password)"
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        return label;
    }()
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label;
    }()

    let lockView =  LockView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lockView)
        lockView.delegate = self
        view.addSubview(titlelabel)
        titlelabel.text = "手势解锁"
        titlelabel.sizeToFit()
        view.addSubview(label)
        label.sizeToFit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lockView.frame = view.bounds
        titlelabel.frame = CGRect(x: 0, y: 55, width: view.frame.width, height: 55)
        label.frame = CGRect(x: 0, y: 500, width: view.frame.width, height: 55)
        
       
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {.lightContent }


}

