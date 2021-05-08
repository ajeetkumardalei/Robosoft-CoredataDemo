//
//  StudentDetailViewController.swift
//  StudentDBDemo
//
//  Created by admin on 08/05/21.
//

import UIKit
import CoreData



class StudentDetailViewController: UIViewController {
    @IBOutlet weak var tfFirstname: UITextField!
    @IBOutlet weak var tfLastname: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfID: UITextField!
    
    var arrNames:[String] = []
    var students:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Student Details"
    }
    
    @IBAction func saveTap(_ sender: Any) {
        self.view.endEditing(true)
        guard let fname  = tfFirstname.text, fname.count > 0 else {return}
        guard let lname  = tfLastname.text, lname.count > 0 else {return}
        guard let idStr  = tfID.text, idStr.count > 0 else {return}
        guard let ageStr = tfAge.text, ageStr.count > 0 else {return}

        let mytupple = (fname, lname, idStr, ageStr)
        saveToCoredata(mytupple)
        clearField()
    }
    
    private func saveToCoredata(_ mytupple: (String, String, String, String)) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedobjectcontext = appdelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Student", in: managedobjectcontext) else {return}
        let newUser = NSManagedObject(entity: entity, insertInto: managedobjectcontext)
        newUser.setValue(mytupple.0, forKeyPath: "firstName")
        newUser.setValue(mytupple.1, forKeyPath: "lastName")
        newUser.setValue(Int(mytupple.2), forKeyPath: "id")
        newUser.setValue(Int(mytupple.3), forKeyPath: "age")
        
        //now save to DB
        do {
            try managedobjectcontext.save()
            students.append(newUser)
        } catch let err as NSError {
            debugPrint("Couldn't save \(err.userInfo), \(err.localizedDescription)")
        }
        
//        appdelegate.saveContext()
//        students.append(newUser)
    }
    
    private func clearField() {
        tfFirstname.text = nil
        tfLastname.text = nil
        tfID.text = nil
        tfAge.text = nil
    }

}
