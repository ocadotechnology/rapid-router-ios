
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

        gameView.addSubview(unityView)
        unityView.snp.makeConstraints { make in
            make.edges.equalTo(gameView)
        }

        appDelegate.startUnity()

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

        loadToolbox(level: store.state.level)

        if let workspace = workBenchViewController.workspace {
            do {
            let startBlock = try blockFactory.makeBlock(name: "start")
            try workspace.addBlockTree(startBlock)
            } catch {
                print("start block not created")
            }
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
        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }


    @IBAction func sendBlocksToUnity(_ sender: Any) {
        guard let rootBlock = self.workBenchViewController.workspace?.topLevelBlocks().first else {
            return
        }
        do {
            let translator = BlocklyTranslator(rootBlock: rootBlock)
            let code = try translator.translateToCode()
            store.dispatch(RunCode(code: code))
        } catch {
            print("Could not translate blocks to `Code`")
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

