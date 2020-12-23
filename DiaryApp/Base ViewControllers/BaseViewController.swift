//
//  BaseViewController.swift
//  ShortTrip
//
//  Created by prompt on 26/05/17.
//  Copyright © 2017 Prompt Softech. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var neededOrientation = 2
    var activityIndicator = UIActivityIndicatorView()
    var societyParam: Dictionary<String, Any> = [:]
    var loadingView = LoadingView()
    
    // MARK: - UIViewController delegate methods
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(UIDevice.current.orientation)
    }
    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createLoadingIndicatorView()
        self.hideKeyboardWhenTappedAround()
        //self.setbackButton()
    }
    
    func setbackButton() {
        let backBTN = UIBarButtonItem(image: UIImage(named: "lefticon"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
    }
    
    func setRightNavigationItem(image: UIImage?) {
        let rightBarItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    // MARK: - Show Pickerview with action
    func showPickerView(picker: UIPickerView, title: String, viewController: BaseViewController, doneAction: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
            doneAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        picker.frame = CGRect(x: 0, y: 50, width: 260, height: 150)
        picker.dataSource = viewController.self as? UIPickerViewDataSource
        picker.delegate = viewController.self as? UIPickerViewDelegate
        alert.view.addSubview(picker)
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        viewController.present(alert, animated: true) {
            picker.frame.size.width = alert.view.frame.size.width
        }
    }

    // MARK: - UItextfield Peaddings
    func setPaddingViewRight(strImgname: String,txtField: UITextField){
        let imageView = UIImageView(image: UIImage(named: strImgname))
        imageView.frame = CGRect(x: 0, y: 10, width: imageView.image!.size.width , height: imageView.image!.size.height)
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        paddingView.addSubview(imageView)
        txtField.rightViewMode = .always
        txtField.rightView = paddingView
    }
    
    
        
    // MARK: - Loading methods
    func createLoadingIndicatorView () {
         loadingView = LoadingView()
         // loadingView.backgroundColor = .clear
         loadingView.translatesAutoresizingMaskIntoConstraints = false
       //  loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
         self.view.addSubview(loadingView)
         loadingView.isHidden = true
         
         let views = ["loadingView" : loadingView]
         self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[loadingView]|", options: [], metrics: nil, views: views))
         self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[loadingView]|", options: [], metrics: nil, views: views))
    }
    
    func showLoading() {
        // KRProgressHUD.show()
        loadingView.isHidden = false
        self.view.window?.isUserInteractionEnabled = false

    }
    
    func showLoadingAlignToTop() {
        // KRProgressHUD.show()
//        loadingView.updateCenterYMargin(margin: -80)
//        loadingView.isHidden = false
    }
    
    func showBlockerLoading() {
//        loadingView.updateCenterYMargin(margin: -80)
        loadingView.isHidden = false
        // KRProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        loadingView.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
    
    func hideLoading() {
        // KRProgressHUD.dismiss()
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.view.window?.isUserInteractionEnabled = true

        }
    }
    
    func hideBlockerLoading() {
        // KRProgressHUD.dismiss()
        loadingView.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: - Show Warning
    func showWarning(message: String) {
        // KRProgressHUD.showWarning(withMessage: message)
    }
    
    //MARK:- Set orientation
//    func setOrientation(_ type:Int) -> Void {
//        if (neededOrientation == OrientationMenu.ORIENTAION_LANDSCAP.rawValue) {
//            UIDevice.current.setValue(getLanscape(), forKey: "orientation")
//        } else {
//            UIDevice.current.setValue(getPortrait(), forKey: "orientation")
//        }
//    }
    
    func getLanscape() -> Int {
        let value = UIDevice.current.orientation == .landscapeLeft ? UIInterfaceOrientation.landscapeLeft.rawValue : UIInterfaceOrientation.landscapeRight.rawValue
        return Int(value)
    }
    
    func getPortrait() -> Int {
        let value =  UIInterfaceOrientation.portraitUpsideDown.rawValue
        return Int(value)
    }
    
    //MARK: - Custom Methods
    func isValidEmail(textStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: textStr)
    }
        
    func startAnimating() {
        self.view.isUserInteractionEnabled = false
        LoadingOverlay.shared.showOverlay(view: self.view, withTitle: "Loading")
    }
    
    func startAnimatingWithIgnoringInteraction() {
        let currentView = UIApplication.shared.windows.first?.rootViewController?.view
        currentView?.isUserInteractionEnabled = false
        LoadingOverlay.shared.showOverlay(view: currentView!, withTitle: "Loading")
    }
    
    func stopAnimating() {
        self.view.isUserInteractionEnabled = true
        LoadingOverlay.shared.hideOverlayView()
    }
    
    func stopAnimatingWithIgnoringInteraction() {
        DispatchQueue.main.async {
            let currentView = UIApplication.shared.windows.first?.rootViewController?.view
            currentView?.isUserInteractionEnabled = true
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    
    func navigationBarColor() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func popViewControllerWithBackArrow() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"backArrow") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(movePopViewController))
    }
    
    @objc func movePopViewController(_ sender: UIBarButtonItem) {
        self.dismissKeyboard()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLeftNavigationItem(image: UIImage?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:image , style: UIBarButtonItem.Style.plain, target: self, action: #selector(didPopVC))
        
    }
    
    @objc func didPopVC(_ sender: UIBarButtonItem) {
        self.dismissKeyboard()
        self.navigationController?.popViewController(animated: true)
    }
        
    func openDrawer() {
//        var mainStoryBoard:UIStoryboard?
//        mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController: KYDrawerController = mainStoryBoard?.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
//        mainViewController.screenEdgePanGestureEnabled = false
//        mainViewController.setDrawerState(.closed, animated: true)
//        UIApplication.shared.windows.first?.rootViewController = mainViewController
    }
    
    func showAlert(title:String, message:String) {
        if let view = self.navigationController?.view {
            AppHelper.showAlert(view: view, message:message)
        }
    }
    
    func showAlertWithAction(title: String?, message: String, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) in
            okAction()
        })
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteAlert(title: String?, message: String, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "DELETE", style: .destructive, handler: {(UIAlertAction) in
            okAction()
        })
        
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(UIAlertAction) in

        })
        alert.addAction(okayAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //Get TimneStemp
    func getCurrentTimeStamp() -> Double {
        let timestamp = NSDate().timeIntervalSince1970
        return Double(timestamp)
    }
    
    func getDateOnTimeStemp(timestamp:Double) -> Date {
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        return time as Date
    }

    //Get GUID or random string
    func randomString() -> String {
        let length = 36
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func getDirectoryPath(strFolder:String) -> NSURL {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(strFolder)
        let url = NSURL(string: path)
        return url!
    }
  
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func DropShadow()
    {
        let layer = self.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
    }
    
}
