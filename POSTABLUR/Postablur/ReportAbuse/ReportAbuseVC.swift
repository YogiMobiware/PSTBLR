//
//  ReportAbuseVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/25/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit
protocol ReportAbuseVCDelegate
{
    
    func pbDidTapOnCancel()
    func reportAbuseSubmitDidTap()

}
class ReportAbuseVC: UIViewController {

    var delegate : ReportAbuseVCDelegate? = nil
    var reportAbuses = [PBReportAbuseItem]()
    var appdelegate : AppDelegate!
    var myPickerView : UIPickerView!
    @IBOutlet weak var abuseTF: UITextField!
    @IBOutlet weak var descriptionTv: UITextView!
    var selectedMediaTypeId : Int = 0
    var selectedMediaName : String?
    var abusePostID : String?
    var doneToolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appdelegate = UIApplication.shared.delegate as! AppDelegate

        ///THIS SERVICE IS USED TO FETCH LIST OF ABUSING CONTENTS
        self.getReportAbuseMediaTypes()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.tapGestureRecognized))
        doneToolbar = Constants.getDoneToolbar(dismissBtn: doneButton)
        
        self.descriptionTv.inputAccessoryView = doneToolbar
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.abuseTF.text = ""
        self.descriptionTv.text = ""

    }
    @objc internal func tapGestureRecognized()
    {
        self.descriptionTv.resignFirstResponder()
        
    }
    func pickUp(_ textField : UITextField){

        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        abuseTF.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Constants.navBarTintColor
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ReportAbuseVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ReportAbuseVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        abuseTF.inputAccessoryView = toolBar

    }
     @objc func doneClick()
    {
        self.abuseTF.resignFirstResponder()
        self.descriptionTv.resignFirstResponder()
    }
    @objc func cancelClick()
    {
    
        self.abuseTF.resignFirstResponder()
        self.descriptionTv.resignFirstResponder()

    }
    @IBAction func backBtnAction()
    {
        if let delegate = self.delegate
        {
            delegate.pbDidTapOnCancel()
            
        }
    }
    @IBAction func submitBtnAction()
    {
        guard let _ = self.selectedMediaName?.isEmpty else {
            PBUtility.showSimpleAlertForVC(vc: self, withTitle: "Report Abuse", andMessage: "Please select the complaint of abuse")
            return
        }
        guard let _ = self.descriptionTv, !(self.descriptionTv.text?.isEmpty)! else {
            PBUtility.showSimpleAlertForVC(vc: self, withTitle: "Report Abuse", andMessage: "Please add the reason of abuse")
            return
        }
       
        let urlString = String(format: "%@/AddReportAbuseMedia", arguments: [Urls.mainUrl]);
        let requestDict = ["UserId": UserDefaults.standard.string(forKey: "UserId")!,"PostId":abusePostID!,"ReportMediaTypeId":selectedMediaTypeId,"OtherDescription":self.descriptionTv.text,"ReportStatus":"1"] as [String : Any]
        
        self.appdelegate.showActivityIndictor(titleString: "Reporting Abuse", subTitleString: "")
        
        PBServiceHelper().post(url: urlString, parameters: requestDict as NSDictionary) { (responseObject : AnyObject?, error : Error?) in
            
            if error == nil
            {
                self.appdelegate.hideActivityIndicator()

                if responseObject != nil
                {
                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        if let resultArray = responseDict["Results"] as! [NSDictionary]!
                        {
                            let result = resultArray.first!
                            print("signup result \(result)")
                            
                            let statusMessage = result["StatusMsg"] as! String
                            
                            if statusMessage == "Success"
                            {

                                self.showUploadSuccessAlert()
                                self.appdelegate.hideActivityIndicator()
                               
                            }
                            else
                            {
                                self.appdelegate.hideActivityIndicator()
                                self.appdelegate.alert(vc: self, message: statusMessage, title: "Success")
                                
                                return
                            }
                            
                        }
                    }
                    if let responseStr = responseObject as? String
                    {
                        self.appdelegate.hideActivityIndicator()
                        self.appdelegate.alert(vc: self, message: responseStr, title: "Report Abuse")
                        
                        return
                    }
                    
                }
                else
                {
                    self.appdelegate.hideActivityIndicator()
                    self.appdelegate.alert(vc: self, message: "Something went wrong", title: "Report Abuse")
                    
                    return
                }
            }
            else
                {
                self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Report Abuse")
                return
                }
            
            }
      
        
    }
    func showUploadSuccessAlert(){
        
        let alertView = UIAlertController(title: "Postablur", message: "Thanks for helping report abuse", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
            if let delegate = self.delegate
            {
                delegate.pbDidTapOnCancel()
                
            }

        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    func getReportAbuseMediaTypes()
    {
        let urlString = String(format: "%@/GetReportAbuseMediaTypes", arguments: [Urls.mainUrl]);
        
        PBServiceHelper().get(url: urlString) { (responseObject : AnyObject?, error : Error?) in
            
            if error == nil
            {
                if responseObject != nil
                {
                    self.reportAbuses.removeAll()
                    
                    if let responseDict = responseObject as? [String : AnyObject]
                    {
                        if let resultArray = responseDict["GetReportAbuseMediaTypesResult"]!["Results"] as! [NSDictionary]!
                        {
                            print("GetReportAbuseMediaTypes \(resultArray)")
                            for result in resultArray
                            {
                                let repostAbuse = PBReportAbuseItem()
                                
                                repostAbuse.ReportMediaTypeId = result["ReportMediaTypeId"] as! Int
                                repostAbuse.ReportMediaName = result["ReportMediaName"] as? String
                                
                                self.reportAbuses.append(repostAbuse)
                            }
                            return
                            
                        }
                        else
                        {
                            
                            self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Report Abuse")
                            return
                        }
                    }
                }
            }
            else
            {
                self.appdelegate.alert(vc: self, message: (error?.localizedDescription)!, title: "Report Abuse")
                return
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ReportAbuseVC : UIPickerViewDelegate, UIPickerViewDataSource
{
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.reportAbuses.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let reportMediaName : PBReportAbuseItem = self.reportAbuses[row]

        return reportMediaName.ReportMediaName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selecetedMediaName : PBReportAbuseItem = self.reportAbuses[row]

        self.abuseTF.text = selecetedMediaName.ReportMediaName
   
        self.selectedMediaTypeId = selecetedMediaName.ReportMediaTypeId
        self.selectedMediaName = selecetedMediaName.ReportMediaName

    }
    
    
}
extension ReportAbuseVC : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(abuseTF)
    }

}

