
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
    lazy var unityView: UIView = UnityGetGLView()!

    @IBOutlet weak var gameView: UIView!

    @IBOutlet weak var workbenchView: UIView!

    let workBenchViewController = WorkbenchViewController(style: .defaultStyle)

    var store: Store<AppState> = mainStore

    lazy var toolboxLoader: ToolboxLoadable = {
        return ToolboxLoader(workbench: self.workBenchViewController)
    }()
    
    @IBAction func startUnity(sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startUnity()

        gameView.addSubview(unityView)
        unityView.snp.makeConstraints { make in
            make.edges.equalTo(gameView)
        }

    }

    @IBAction func stopUnity(sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopUnity()
        unityView.removeFromSuperview()
    }

    func newState(state: AppState) {
        loadToolbox(level: state.level)
    }

    private func loadToolbox(level: Int) {
        do {
            try toolboxLoader.loadToolbox(level: level)
        } catch let error {
            print("An error occurred loading the toolbox: \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let blockFactory = workBenchViewController.blockFactory
        do {
            try blockFactory.load(fromJSONPaths: ["CustomBlocks.json"])
        } catch {
            print("something went wrong")
        }

        loadToolbox(level: mainStore.state.level)

        addChildViewController(workBenchViewController)
        workbenchView.addSubview(workBenchViewController.view)
        workBenchViewController.didMove(toParentViewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
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

