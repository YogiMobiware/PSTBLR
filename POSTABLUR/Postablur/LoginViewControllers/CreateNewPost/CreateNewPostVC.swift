//
//  CreateNewPostVC.swift
//  Postablur
//
//  Created by Srinivas Peddinti on 1/22/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//

import UIKit

class CreateNewPostVC: UIViewController
{
   
    @IBOutlet weak var createPostTableView: UITableView!
    @IBOutlet weak var postTitleLabel : UILabel!
    var descriptionTextView : UITextView!
    var titleLabelText : String!
    var locationText : String!
    var postTosocialNetwork : String!
    var donateToCharity : String!
    var whoGetsToReveal : String!
    var blurImage : UIImage!
    override func viewDidLoad()
    {
        
        super.viewDidLoad()

        let titleNib = UINib(nibName: NibNamed.TitleCell.rawValue, bundle: nil)
        self.createPostTableView.register(titleNib, forCellReuseIdentifier: CellIdentifiers.TitleCellIdentifier.rawValue)
        
        let locationNib = UINib(nibName: NibNamed.LocationCell.rawValue, bundle: nil)
        self.createPostTableView.register(locationNib, forCellReuseIdentifier: CellIdentifiers.LocationCellIdentifier.rawValue)
        
        let descriptionNib = UINib(nibName: NibNamed.DescriptionCell.rawValue, bundle: nil)
        self.createPostTableView.register(descriptionNib, forCellReuseIdentifier: CellIdentifiers.DescriptionCellIdentifier.rawValue)
       
        let shareYourPostNib = UINib(nibName: NibNamed.ShareYourPost.rawValue, bundle: nil)
        self.createPostTableView.register(shareYourPostNib, forCellReuseIdentifier: CellIdentifiers.ShareYourPostCellIdentifier.rawValue)

        let shareLabelfontSize = ((UIScreen.main.bounds.size.width) / CGFloat(414.0)) * 24
        let roundedBoldfontSize = floor(shareLabelfontSize)
        self.postTitleLabel.font = self.postTitleLabel.font.withSize(roundedBoldfontSize)

        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
   
    }
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func doneBtnAction(_ sender: UIButton)
    {
        
  
        /*let postReviewVC = PostReviewVC(nibName: "PostReviewVC", bundle: nil)
        _ = postReviewVC.view
        postReviewVC.bluredImage = blurImage
        postReviewVC.titleTxtLabel.text = self.titleLabelText as String
        postReviewVC.descTxtLabel.text = self.descriptionTextView.text! as String
        postReviewVC.locationTxtLabel.text = self.locationText
        postReviewVC.revealedTxtLabel.text = self.whoGetsToReveal
        postReviewVC.sharedOnTxtLabel.text = self.postTosocialNetwork
        postReviewVC.donateToTxtLabel.text = self.donateToCharity
        self.navigationController?.pushViewController(postReviewVC, animated: true);*/
        
    }
    
}
// MARK: Tableview Datasource and Delegate
extension CreateNewPostVC : UITableViewDataSource, UITableViewDelegate
{
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 || indexPath.section == 1
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 86.0)
        }
        else if indexPath.section == 2
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 106.0)
        }
        else
        {
            return  Constants.calculateDynamicTableviewCellHeight(cellHeight: 262.0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        switch indexPath.section
        {
            
        case 0:
            let cell : TitleCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.TitleCellIdentifier.rawValue, for: indexPath) as! TitleCell
            cell.titleTF.delegate = self
            return cell
            
        case 1:
            let cell : LocationCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.LocationCellIdentifier.rawValue, for: indexPath) as! LocationCell
            cell.locationTF.delegate = self
            return cell
            
        case 2:
            let cell : DescriptionCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.DescriptionCellIdentifier.rawValue, for: indexPath) as! DescriptionCell
            cell.descriptionTV.delegate = self
            cell.descriptionDelegate = self
            return cell
        case 3:
            let cell : ShareYourPost = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ShareYourPostCellIdentifier.rawValue, for: indexPath) as! ShareYourPost
            cell.shareYourPostDelegate = self
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
}
extension CreateNewPostVC : UITextFieldDelegate
{
    // MARK: Textfield Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.placeholder == "Title"
        {
            self.titleLabelText = textField.text
        }
        else
        {
            self.locationText = textField.text
        }
    }
    
}
extension CreateNewPostVC : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        self.descriptionTextView = textView
        
    }
   
}
extension CreateNewPostVC : ShareYourPostDelegate
{
    func pbPublicOrPrivateDidTap(privateOrPublicButton:UIButton)
    {
        // SET BUTTON TAG 201 MEANS PUBLIC IN XIB
        if privateOrPublicButton.tag == 201
        {
          self.whoGetsToReveal = "Public"
        }
        else
        {
            self.whoGetsToReveal = "Private"
        }
    }
    func pbTwitterBtnDidTap()
    {
      self.postTosocialNetwork = "Twitter"
    }
    func pbFaceBookBtnDidTap()
    {
        self.postTosocialNetwork = "Facebook"

    }
    func pbDonateBtnDidTap(selectedDonatedButton : UIButton)
    {
        switch selectedDonatedButton.tag {
            case 101:
            self.donateToCharity = "United Way"
                break
            case 102:
                self.donateToCharity = "American cancer society"
                break
            case 103:
                self.donateToCharity = "American red cross"
                break
            case 104:
                self.donateToCharity = "American heart association"
                break
        default:
            self.donateToCharity = "Boys and girls club of america"
            break

        }
    }
}

extension CreateNewPostVC : PBDescriptionCellDelegate
{
    func doneButtonDidTapOnDescriptionView(_ textView: UITextView)
    {
        self.descriptionTextView.resignFirstResponder()
        if textView.text != nil
        {
        self.descriptionTextView.text = textView.text
        }

    }
}
