//
//  ViewController.swift
//  StudentDBDemo
//
//  Created by admin on 08/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tblvw: UITableView!
    private let cellIDentifier = "Cell"
    
    var students: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Student Lists"
        configureTableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchValueFromCoreData()
    }
    
    private func configureTableview() {
        tblvw.register(UITableViewCell.self, forCellReuseIdentifier: cellIDentifier)
        tblvw.dataSource = self
        tblvw.rowHeight = 80.0
        tblvw.estimatedRowHeight = 80.0
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        
    }

    private func fetchValueFromCoreData() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        let fetchRequst = NSFetchRequest<NSManagedObject>(entityName: "Student")

        do {
            let arr = try managedObjectContext.fetch(fetchRequst)
            students = arr
            
            DispatchQueue.main.async {[weak self] in
                self?.tblvw.reloadData()
            }
        } catch let errr as NSError {
            debugPrint("Fetch is unsuccessfull: \(errr.localizedDescription)")
        }
        
        debugPrint(students)
        
    }

}

extension ViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if var cell = tableView.dequeueReusableCell(withIdentifier: cellIDentifier) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIDentifier)
            if students.count > 0 {
                let student = students[indexPath.row]
                cell.textLabel?.text = student.value(forKeyPath: "firstName") as? String
                cell.detailTextLabel?.text = student.value(forKeyPath: "lastName") as? String
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

