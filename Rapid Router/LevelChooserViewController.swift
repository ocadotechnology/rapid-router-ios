//
//  LevelChooserViewController.swift
//  Rapid Router
//
//  Created by Niket Shah on 07/06/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

class LevelChooserViewController: UITableViewController {


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 109
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Level \(indexPath.row + 1)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let level = String(indexPath.row)
        UnitySendMessage("ChapterController", "LevelChangeListener", level)
    }

}
