//
//  ViewController.swift
//  Rapid Router
//
//  Created by Jacquiline Train on 19/04/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var unityView: UIView?

    @IBOutlet weak var gameView: UIView!

    
    @IBAction func startUnity(sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startUnity()

        unityView = UnityGetGLView()!

        gameView.addSubview(unityView!)
        unityView!.snp.makeConstraints { make in
            make.edges.equalTo(gameView)
        }

    }

    @IBAction func stopUnity(sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopUnity()
        unityView!.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startUnity(sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

