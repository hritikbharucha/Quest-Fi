//
//  HelpViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 6/7/21.
//

import UIKit
import MessageUI

class HelpViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var nameTextView: UITextView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var submitView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var viewWidth : CGFloat = 414
    var viewHeight : CGFloat = 896
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        makeButtonGood(submitButton, submitView)
        
        setGradientColor(submitButton)
        
        nameTextView.layer.borderColor = UIColor.black.cgColor
        nameTextView.layer.borderWidth = (2/414)*viewWidth
        
        messageTextView.layer.borderColor = UIColor.black.cgColor
        messageTextView.layer.borderWidth = (2/414)*viewWidth
    }
    
    func makeButtonGood(_ button: UIButton, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = (5/896)*viewHeight
        containerView.layer.cornerRadius = (20/896)*viewHeight
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: (20/896)*viewHeight).cgPath
        button.clipsToBounds = true
        button.layer.cornerRadius = (20/896)*viewHeight
    }
    
    func setGradientColor(_ view: UIView) {
        
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 91/255, green: 156/255, blue: 134/255, alpha: 1).cgColor, UIColor(red: 102/255, green: 168/255, blue: 174/255, alpha: 1).cgColor]

        view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail() {
            sendEmail()
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func sendEmail() {
        let emailTitle = "Help Request For Productivity App"
        let messageBody = messageTextView.text ?? ""
        let toRecipents = ["productivityrewards@gmail.com"]

        let mc = MFMailComposeViewController()

        mc.mailComposeDelegate = self

        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)

        present(mc, animated: true, completion: nil)
    }

    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", [error?.localizedDescription])
            showSendMailErrorAlert()
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
        showSendMailSuccessAlert()
    }
    
    func showSendMailSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Email successfully sent.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                print("NEW STUFF ADDED")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Email Failed To Send", message: "Please download the 'Mail' app to send emails or manually send to productivityrewards@gmail.com", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                print("NEW STUFF ADDED")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
