//
//  EditDairyVC.swift
//  DiaryApp
//
//  Created by prompt on 11/30/20.
//

import UIKit
import CoreData

protocol DairyUpdate {
    func updateDairyList(note:Note,index:Int)
}

class EditDairyVC: BaseViewController {

    @IBOutlet weak var txtTitle:  UITextField!
    @IBOutlet weak var txtContent:  UITextView!
    @IBOutlet weak var btnSave:  UIButton!

    var delegate:DairyUpdate?
    
    var dictNote:Note?
    var currentIndex:Int = 0
   
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtTitle.text = dictNote?.title
        self.txtContent.text = dictNote?.content
        self.btnSave.layer.cornerRadius = 5
    }
   
    // MARK: @IBAction
    @IBAction func actionSave(_ sender: UIBarButtonItem) {
        if self.txtTitle.text == "" {
            self.showAlertWithAction(title: APP_NAME, message: AppHelper.localizedtext(key: "EditDiary.alert.title")) {
            }
        }else if self.txtContent.text == "" {
            self.showAlertWithAction(title: APP_NAME, message: AppHelper.localizedtext(key: "EditDiary.alert.content")) {
            }
        }else{
            dictNote?.title = self.txtTitle.text
            dictNote?.content = self.txtContent.text
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteData")
                request.predicate = NSPredicate(format:"id = %@", self.dictNote?.id as! CVarArg)
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    let objUpdate = results[0] as! NSManagedObject
                    objUpdate.setValue(dictNote?.id, forKey: "id")
                    objUpdate.setValue(dictNote?.title, forKey: "title")
                    objUpdate.setValue(dictNote?.content, forKey: "content")
                    objUpdate.setValue(dictNote?.date, forKey: "date")
                    try context.save()
                }
            }catch {
                print ("error")
            }
            self.delegate?.updateDairyList(note: dictNote!, index: currentIndex)
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    @IBAction func actionPop(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
