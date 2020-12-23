//
//  DairyListVC.swift
//  DiaryApp
//
//  Created by prompt on 11/30/20.
//

import UIKit
import CoreData

class DairyListVC: BaseViewController,DairyUpdate {

    @IBOutlet weak var btnNointernet:  UIButton!
    @IBOutlet weak var tblDairy:  UITableView!
    var arrNote: [Note] = []
    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDairy.dataSource = self
        tblDairy.delegate = self
        tblDairy.tableFooterView = UIView()
        tblDairy.isHidden = true
        btnNointernet.isHidden = true
        self.getData()
    }
    
    // MARK: Custom Delegate
    func updateDairyList(note: Note, index: Int) {
        //self.arrNote.remove(at: index)
        //self.arrNote.insert(note, at: index)
        //self.tblDairy.reloadData()
        self.getData()
    }
    // MARK: IBAction
    @IBAction func actionReload(_ sender: UIButton) {
        tblDairy.isHidden = true
        btnNointernet.isHidden = true
        self.getNotes()
    }
    @IBAction func actionClose(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblDairy)
        let indexPath = self.tblDairy.indexPathForRow(at:buttonPosition)
        
        self.showDeleteAlert(title: APP_NAME, message: AppHelper.localizedtext(key: "delete.title.text")) {
           // self.arrNote.remove(at: indexPath?.row ?? 0)
           // self.tblDairy.reloadData()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteData")
                request.predicate = NSPredicate(format:"id = %@", self.arrNote[indexPath?.row ?? 0].id!)
                let results = try context.fetch(request)
                for object in results {
                    context.delete(object as! NSManagedObject)
                }
                try context.save()
                self.getData()
            }catch {
                print ("error")
            }
        }
    }

    @IBAction func actionEdit(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblDairy)
        let indexPath = self.tblDairy.indexPathForRow(at:buttonPosition)

        let editDairy = self.storyboard?.instantiateViewController(withIdentifier:  "EditDairyVC") as! EditDairyVC
        editDairy.dictNote = self.arrNote[indexPath?.row ?? 0]
        editDairy.currentIndex = indexPath?.row ?? 0
        editDairy.delegate = self
        self.navigationController?.pushViewController(editDairy, animated: true)
    }

    // MARK: - API Calling..
    func getNotes() {
        //Check internet connection...
        self.btnNointernet.isHidden = true
        if !AppHelper.isInternetConnected() {
            self.showAlertWithAction(title:  AppHelper.localizedtext(key: "internet.alert.Title"), message: AppHelper.localizedtext(key: "internet.alert.text")) {
            }
            self.btnNointernet.isHidden = false
            return
        }
        self.showLoading()
        DiaryViewModel.getDiaryList(params: [:]) { (success, message, statuscode, response) in
            self.hideLoading()
            DispatchQueue.main.async {
                self.arrNote = response as! [Note]
                if self.arrNote.count > 0 {
                    //Save in core data...
                    for i in 0...self.arrNote.count - 1 {
                        self.saveData(objNote: self.arrNote[i])
                    }
                    self.getData()
                }else{
                    self.showAlertWithAction(title:  AppHelper.localizedtext(key: "internet.alert.Title"), message: AppHelper.localizedtext(key: "internet.alert.text")) {
                    }
                    self.btnNointernet.isHidden = false
                }
            }
        }
    }
}

extension DairyListVC {
    
    // MARK: - Core Data.
    func getData() {

        //Remove all data..
        self.arrNote.removeAll()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // let newSitting = NSEntityDescription.insertNewObject(forEntityName: "Sittings", into: context)

        //get data from CoreData
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteData")
        request.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    let objNote = Note()
                    if let tempDate = result.value(forKey: "date") as? String {
                        //add data to array
                        objNote.date = tempDate
                    }
                    if let tempId = result.value(forKey: "id") as? String {
                        //add data to array
                        objNote.id = tempId
                    }
                    if let temptitle = result.value(forKey: "title") as? String {
                        //add data to array
                        objNote.title = temptitle
                    }
                    if let tempcontent = result.value(forKey: "content") as? String {
                        //add data to array
                        objNote.content = tempcontent
                    }
                    self.arrNote.append(objNote)
                }
                self.tblDairy.isHidden = true
                if self.arrNote.count > 0 {
                    self.tblDairy.reloadData()
                    self.tblDairy.isHidden = false
                }
            }
            else {
                print ("database is empty")
                self.getNotes()
            }
        }
        catch {
            print ("error")
        }
    }
    func saveData(objNote: Note) {

        // setup CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newObj = NSEntityDescription.insertNewObject(forEntityName: "NoteData", into: context)
        newObj.setValue(objNote.id, forKey: "id")
        newObj.setValue(objNote.title, forKey: "title")
        newObj.setValue(objNote.content, forKey: "content")
        newObj.setValue(objNote.date, forKey: "date")
        do {
            try context.save()
            print ("-----SAVED-----")
        }
        catch {
            print ("XXXXX THERE WAS AN ERROR XXXXXXX")
        }
    }
}

extension DairyListVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /*func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrNote.count
    }*/
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = UIColor.white
        
            let imgTimer = UIImageView()
            imgTimer.image = UIImage(named: "timer")
            imgTimer.frame = CGRect.init(x: 38, y: headerView.frame.size.height/2 - 10, width: 20, height: 20)
            imgTimer.tintColor = UIColor.lightGray
            headerView.addSubview(imgTimer)
        
            let label = UILabel()
            label.frame = CGRect.init(x: imgTimer.frame.origin.x + imgTimer.frame.size.width + 10, y: 0, width: headerView.frame.width-50, height: headerView.frame.height)
            label.text = "Today"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = UIColor.lightGray
            headerView.addSubview(label)
            return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNote.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DairyListCell") as! DairyListCell
        cell.DropShadow()
        cell.lblTitle.text = self.arrNote[indexPath.row].title
        cell.lblDetails.text = self.arrNote[indexPath.row].content
        cell.lblHours.text = AppHelper.timeAgoSinceDate(datefrom: self.arrNote[indexPath.row].date ?? "2020-12-01 00:00:00")
        
        return cell
    }
}
