//
//  MainVC.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 05.03.2021.
//

import UIKit

class MainVC: UITableViewController {
    
    var header = CustomHeader()
    static var cellNames = ["Characters","Comics", "Creators"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header = CustomHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.tableHeaderView = header
        header.imageView.image = UIImage(named: "blur")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2727513313, green: 0.07591696829, blue: 0.4023047984, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let vc = segue.destination as! InfoVC
            let cell = sender as! CustomCell
            vc.title = cell.cellTitle.text
        }
    }
    
    // MARK: - Table view data source
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainVC.cellNames.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCell) as! CustomCell
        
        cell.cellImage.image = UIImage(named: String(indexPath.row))
        cell.cellTitle.text = MainVC.cellNames[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? CustomHeader else { return }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}
