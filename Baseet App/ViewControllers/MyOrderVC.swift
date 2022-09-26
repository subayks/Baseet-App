//
//  MyOrderVC.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class MyOrderVC: UIViewController {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var myCurrentOrderTB: UITableView!
    var selectedIndex = 0
    var myOrderVM = MyOrderVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.myOrderVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.myOrderVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.myOrderVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.myOrderVM.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.myCurrentOrderTB.reloadData()
            }
        }
        self.myOrderVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "OrderOntheWayVC") as! OrderOntheWayVC
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                vc.orderOntheWayVM = self.myOrderVM.getOrderOntheWayVM()
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.myOrderVM.makeOrderListCall(type: 0, limitAdded: 0)
    }
    
    @IBAction func myOderSeqment(_ sender: Any) {
        
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            self.selectedIndex = 0
            self.myOrderVM.makeOrderListCall(type: 0, limitAdded: 0)
        }
        else if (sender as AnyObject).selectedSegmentIndex == 1 {
            self.selectedIndex = 1
            self.myOrderVM.makeOrderListCall(type: 1, limitAdded: 0)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionModify(_ sender: Any) {
    }
    
    @IBAction func orderDetails(_ sender: UIButton) {
        self.myOrderVM.getOrderTrack(index: sender.tag)
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.userName.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.userName.isHidden = false
            self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
            self.profileIcon.loadImageUsingURL(UserDefaults.standard.string(forKey: "ProfileImage"))
        }
    }
    
}
extension MyOrderVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myOrderVM.ordersListModel?.orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCurrentOrderTableViewCell
            cell.modifyOrderBtn.tag = indexPath.row
            cell.orderDetailsBtn.tag = indexPath.row
            cell.modifyOrderBtn.layer.cornerRadius = 10
            cell.orderDetailsBtn.layer.cornerRadius = 10
//            cell.modifyOrderBtn.addTarget(self, action: #selector(modifyAction), for: .touchUpInside)
//            cell.orderDetailsBtn.addTarget(self, action: #selector(orderDetailsAction), for: .touchUpInside)
            cell.myCurrentOrderTableViewCellVM = self.myOrderVM.getMyCurrentOrderTableViewCellVM(index: indexPath.row, type: selectedIndex)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPastOrderTableViewCell", for: indexPath) as! MyPastOrderTableViewCell
            cell.orderDetailsBtn.tag = indexPath.row
            cell.orderDetailsBtn.layer.cornerRadius = 10
         //   cell.orderDetailsBtn.addTarget(self, action: #selector(orderDetailsAction), for: .touchUpInside)
            cell.myCurrentOrderTableViewCellVM = self.myOrderVM.getMyCurrentOrderTableViewCellVM(index: indexPath.row, type: selectedIndex)
            return cell
        }
    }
    
    @objc func orderDetailsAction() {
        print("no")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myOrderVM.getOrderTrack(index: indexPath.row)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((myCurrentOrderTB.contentOffset.y + myCurrentOrderTB.frame.size.height) >= myCurrentOrderTB.contentSize.height)
        {
            DispatchQueue.main.async {
                self.myOrderVM.makeOrderListCall(type: self.selectedIndex, limitAdded: 10)
            }
        }
    }
}
