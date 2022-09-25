//
//  OrderOntheWayVC.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit


class OrderOntheWayVC: UIViewController {
    
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationName: UIButton!
    @IBOutlet weak var orderTB: UITableView!
    var orderOntheWayVM: OrderOntheWayVM?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setupNavigationBar()
        self.orderOntheWayVM?.setupOrderInfo()
        orderTB.register(UINib(nibName: "OrderTrackFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "OrderTrackFooterView")
        self.orderID.text = "Order Id: \(self.orderOntheWayVM?.orderTrackModel?.id ?? 0)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.orderOntheWayVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.orderOntheWayVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.orderOntheWayVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.orderOntheWayVM?.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.orderTB.reloadData()
            }
        }
    }
    
    func setupNavigationBar() {
        self.locationName.setTitle(UserDefaults.standard.string(forKey: "City_Name"), for: .normal)
        self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
    }
    
    @IBAction func orderBackBtn(_ sender: Any) {
        if self.orderOntheWayVM?.isFromSuccessScreen == true {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "tabVC")
            vc.modalPresentationStyle = .fullScreen
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        } else {
        self.dismiss(animated: true,completion: nil)
        }
    }
    
    @IBAction func trackOrderBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MapkitViewVC") as! MapkitViewVC
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
}

extension OrderOntheWayVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil {
            return 2
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.orderOntheWayVM?.orderInfoArray.count ?? 0
        } else if section == 1 {
            if self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil {
                return self.orderOntheWayVM?.orderTrackModel?.details?.count ?? 0
            }
            return 1
        } else {
            return self.orderOntheWayVM?.orderTrackModel?.details?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 2 ||  self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil) && section != 0 {
            return "Order Details"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderOnTableViewCell
            cell.orderStatus.setTitle(self.orderOntheWayVM?.orderInfoArray[indexPath.row].title, for: .normal)
            cell.orderStatus.setImage(UIImage(named: self.orderOntheWayVM?.orderInfoArray[indexPath.row].image ?? ""), for: .normal)
            if self.orderOntheWayVM?.orderInfoArray[indexPath.row].isSelected == true {
                cell.orderStatus.backgroundColor = .red
            } else {
                cell.orderStatus.backgroundColor = .gray
            }
            cell.orderStatus.layer.cornerRadius = 10
            
            return cell
        } else if  indexPath.section == 1 {
            if self.orderOntheWayVM?.orderTrackModel?.deliveryMan != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryDetailsCell", for: indexPath) as! DeliveryDetailsCell
                cell.deliveryDetailsCellVM = self.orderOntheWayVM?.getDeliveryManViewModel()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemsListCell", for: indexPath) as! OrderItemsListCell
                cell.OrderItemsListCellVM = self.orderOntheWayVM?.getOrderItemsListCellVM(index: indexPath.row)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemsListCell", for: indexPath) as! OrderItemsListCell
            cell.OrderItemsListCellVM = self.orderOntheWayVM?.getOrderItemsListCellVM(index: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == 2 ||  self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil) && section != 0  {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OrderTrackFooterView") as! OrderTrackFooterView
            headerView.totalChargeValue.text = "QR \(self.orderOntheWayVM?.orderTrackModel?.orderAmount ?? 0)"
            headerView.couponCost.text = "QR \(self.orderOntheWayVM?.orderTrackModel?.restaurantDiscountAmount ?? 0)"
            headerView.deliveryCost.text = "QR \(self.orderOntheWayVM?.orderTrackModel?.deliveryCharge ?? 0)"
            headerView.overView.layer.cornerRadius = 5
            headerView.totalChargeOverView.layer.cornerRadius = 5
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 2 || self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil) && section != 0 {
            return 30
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 2 || self.orderOntheWayVM?.orderTrackModel?.deliveryMan == nil) && section != 0 {
            return 157
        } else {
            return 0
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((orderTB.contentOffset.y + orderTB.frame.size.height) >= orderTB.contentSize.height)
        {
            DispatchQueue.main.async {
                self.orderOntheWayVM?.getOrderTrack()
            }
        }
    }
}
