//
//  ViewController.swift
//  Rapid Router
//
//  Created by Jacquiline Train on 19/04/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import UIKit
import SnapKit
import Blockly

class ViewController: UIViewController {
    var unityView: UIView?

    @IBOutlet weak var gameView: UIView!

    @IBOutlet weak var workbenchView: UIView!

    let workBenchViewController = WorkbenchViewController(style: .defaultStyle)
    
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

        let blockFactory = workBenchViewController.blockFactory
        do {
            try blockFactory.load(fromJSONPaths: ["CustomBlocks.json"])
        } catch {
            print("something went wrong")
        }

        // Load toolbox
        do {
            let toolboxPath = "1Toolbox.xml"
            if let bundlePath = Bundle.main.path(forResource: toolboxPath, ofType: nil) {
                let xmlString = try String(
                    contentsOfFile: bundlePath, encoding: String.Encoding.utf8)
                let toolbox = try Toolbox.makeToolbox(
                    xmlString: xmlString, factory: blockFactory)
                try workBenchViewController.loadToolbox(toolbox)
            } else {
                print("Could not load toolbox XML from '\(toolboxPath)'")
            }
        } catch let error {
            print("An error occurred loading the toolbox: \(error)")
        }

        addChildViewController(workBenchViewController)
        workbenchView.addSubview(workBenchViewController.view)
        workBenchViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        workBenchViewController.didMove(toParentViewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func sendBlocksToUnity(_ sender: Any) {
        let blocks = workBenchViewController.workspace?.topLevelBlocks().map { $0.name }

        if blocks!.count > 0 {
            UnitySendMessage("VanController", "BlocklyListener", blocks![0])
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    } 

    func setStatusBarBackgroundColor(color: UIColor) {

        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }

        statusBar.backgroundColor = color
    }
}

