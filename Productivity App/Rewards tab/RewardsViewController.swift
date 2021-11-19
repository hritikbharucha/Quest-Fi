//
//  RewardsViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/5/21.
//

import UIKit
import Firebase

class RewardsViewController: UIViewController {
    
    @IBOutlet weak var shopButton: UIButton!
    
    @IBOutlet weak var shopView: UIView!
    
    @IBOutlet weak var chestView: UIView!
    
    @IBOutlet weak var chestButton: UIButton!
    
    @IBOutlet weak var chestCount: UILabel!
    
    private var pageController: UIPageViewController?
    private var currentIndex = 0
    
    var names = ["Character 1", "Character 2", "Character 3"]
    var models = ["hair1bluecrfalsechfalse", "hair1bluecrfalsechfalse", "hair1bluecrfalsechfalse"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPageController()
        makeButtonGood(shopButton, shopView)
        makeButtonGood(chestButton, chestView)
        
        makeCircle(chestCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadChestCount()
        
        loadCharacters {
            self.setUpPageController()
        }
    }
    
    func loadChestCount() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("\(userID)").document("Chest Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDesc = document.data() ?? ["error" : "error"]
                    
                    let common = dataDesc["Common Chests"] as? Int ?? 0
                    let rare = dataDesc["Rare Chests"] as? Int ?? 0
                    let magical = dataDesc["Magical Chests"] as? Int ?? 0
                    
                    let chests = common+rare+magical
                    
                    if chests == 0 {
                        self.chestCount.isHidden = true
                    } else {
                        self.chestCount.text = "\(chests)"
                        self.chestCount.isHidden = false
                    }
                    
                }
            }
        }
    }
    
    func setUpPageController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: view.frame.width/2-200, y: view.frame.height/2 - 240, width: 400, height: 575)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        
        pageController?.view.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: pageController?.view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: pageController?.view, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 47.5)
        let widthConstraint = NSLayoutConstraint(item: pageController?.view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400)
        let heightConstraint = NSLayoutConstraint(item: pageController?.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 575)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        guard let initialVC = detailViewControllerAt(index: currentIndex) else {
            return
        }
        
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParent: self)
    }
    
    func detailViewControllerAt(index: Int) -> CharactersViewController? {
        
        guard let charactersVC = storyboard?.instantiateViewController(withIdentifier: String(describing: CharactersViewController.self)) as? CharactersViewController else {
            return nil
        }
        
        charactersVC.index = index
        charactersVC.nameText = names[index]
        charactersVC.imageName = models[index]
        charactersVC.editHidden = false
        charactersVC.editMode = false
        
        return charactersVC
        
    }
    
    @IBAction func chestPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "rewardsToChests", sender: self)
    }
    
    func setImageTap(image: UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))

        image.addGestureRecognizer(tap)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .white
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func loadCharacters(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "label")
        
        if let userID = Auth.auth().currentUser?.uid {
            dispatchGroup.enter()
            db.collection("\(userID)").document("Rewards Data").getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? ["error" : "error"]
                    
                    for i in 0...2 {
                        dispatchGroup.enter()
                        dispatchQueue.async(group: dispatchGroup) {
                            self.names[i] = dataDescription["character\(i+1)Name"] as? String ?? "Character \(i+1)"
                            self.models[i] = dataDescription["character\(i+1)Model"] as? String ?? "hair1bluecrfalsechfalse"
                            dispatchGroup.leave()
                        }
                    }
                } else {
                    print("Rewards doc does not exist")
                    dispatchGroup.leave()
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
        
    }
    
    func makeCircle(_ label: UILabel) {
        label.layer.cornerRadius = label.frame.size.height/2
        label.layer.masksToBounds = true
        label.isHidden = true
    }
    
    func makeButtonGood(_ button: UIButton, _ containerView: UIView) {
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 20).cgPath        
    }
    
    func makeViewGood(_ containerView: UIView) {
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 20).cgPath
    }
    
    func makeViewGlow(_ containerView: UIView) {
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.cyan.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 7.5
        containerView.layer.cornerRadius = 25
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 25).cgPath
    }
    
    func outlineView(_ v: UIView) {
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = v.bounds
        maskLayer.path = UIBezierPath(roundedRect: v.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 25, height: 25)).cgPath
        v.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineWidth = 5
        borderLayer.frame = v.bounds
        v.layer.addSublayer(borderLayer)
        
    }
    
    @IBAction func shopPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "rewardsToShop", sender: self)
        
    }
}

extension RewardsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let charactersVC = viewController as? CharactersViewController
        
        guard var index = charactersVC?.index else {
            return nil
        }
        
        currentIndex = index
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        return detailViewControllerAt(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let charactersVC = viewController as? CharactersViewController
        
        guard var index = charactersVC?.index else {
            return nil
        }
        
        if index == names.count-1 {
            return nil
        }
        
        index += 1
        
        currentIndex = index
        
        return detailViewControllerAt(index: index)
    }
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.names.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}
