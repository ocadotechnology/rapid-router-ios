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
import ReSwift

class ViewController: UIViewController, StoreSubscriber {
    var unityView: UIView?

    @IBOutlet weak var gameView: UIView!

    @IBOutlet weak var workbenchView: UIView!

    let workBenchViewController = WorkbenchViewController(style: .defaultStyle)

    lazy var toolboxLoader: ToolboxLoader = {
        return ToolboxLoader(workbench: self.workBenchViewController)
    }()
    
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

    func newState(state: AppState) {
        toolboxLoader.loadToolbox(level: state.level)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let blockFactory = workBenchViewController.blockFactory
        do {
            try blockFactory.load(fromJSONPaths: ["CustomBlocks.json"])
        } catch {
            print("something went wrong")
        }

        toolboxLoader.loadToolbox(level: mainStore.state.level)

        addChildViewController(workBenchViewController)
        workbenchView.addSubview(workBenchViewController.view)
        workBenchViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        workBenchViewController.didMove(toParentViewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainStore.unsubscribe(self)
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

