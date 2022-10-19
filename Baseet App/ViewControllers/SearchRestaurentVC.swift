//
//  SearchRestaurentVC.swift
//  Baseet App
//
//  Created by Subendran on 21/09/22.
//

import UIKit

class SearchRestaurentVC: UIViewController {
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBarField: UISearchBar!
    var searchRestaurentVM = SearchRestaurentVM()
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//            let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//           view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchRestaurentVM.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.searchTableView.reloadData()
            }
        }
        
        self.searchRestaurentVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.searchRestaurentVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.searchRestaurentVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.searchRestaurentVM.searchModel = nil
                self.searchTableView.reloadData()
            }
        }
        
        self.searchRestaurentVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestarentDishViewController") as! RestarentDishViewController
                // vc.modalTransitionStyle = .coverVertical
                vc.restarentDishViewControllerVM = self.searchRestaurentVM.getRestarentDishViewControllerVM()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if query != "" {
            self.searchBarField.text = query
            self.searchRestaurentVM.getSearchItem(query: query)
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension SearchRestaurentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.searchRestaurentVM.searchModel?.restaurants?.count != nil && self.searchRestaurentVM.searchModel?.restaurants?.count != 0) && (self.searchRestaurentVM.searchModel?.products?.count != nil && self.searchRestaurentVM.searchModel?.products?.count != 0) {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfSections(in: tableView) == 2 {
            if section == 1 {
                return 1
            } else {
                return self.searchRestaurentVM.searchModel?.restaurants?.count ?? 0
            }
        } else {
            if self.searchRestaurentVM.searchModel?.products?.count ?? 0 > 0 {
                return  1
            } else {
                return self.searchRestaurentVM.searchModel?.restaurants?.count == 0 ? 1: self.searchRestaurentVM.searchModel?.restaurants?.count ?? 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if numberOfSections(in: tableView) == 1 {
            if (self.searchRestaurentVM.searchModel?.restaurants?.count != 0 &&  self.searchRestaurentVM.searchModel?.restaurants?.count != nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurentCell", for: indexPath) as! RestaurentCell
                cell.homeCollectionViewDownCellVM = self.searchRestaurentVM.getMyFevTableViewCellVM(index: indexPath.row)
                return cell
            } else if  (self.searchRestaurentVM.searchModel?.products?.count != 0 &&  self.searchRestaurentVM.searchModel?.products?.count != nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemTableViewCell", for: indexPath) as! FoodItemTableViewCell
                cell.itemId = { (id) in
                    DispatchQueue.main.async {
                        self.searchRestaurentVM.makeShopDetailsCall(id: id)
                    }
                }
                cell.foodItemTableViewCellVM = self.searchRestaurentVM.getFoodItemTableViewCellVM()
                return cell
            } else {
                if (self.searchRestaurentVM.searchModel?.restaurants?.count == 0 ||  self.searchRestaurentVM.searchModel?.restaurants?.count == nil) ||  (self.searchRestaurentVM.searchModel?.products?.count == 0 ||  self.searchRestaurentVM.searchModel?.products?.count == nil) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NoResultFoundCell", for: indexPath) as! NoResultFoundCell
                    if self.query == "" {
                        cell.noResultLabel.text = "Please search with Restaurent/Food name"
                    } else {
                        cell.noResultLabel.text = "No Result Found"
                    }
                    return cell
                }
            }
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemTableViewCell", for: indexPath) as! FoodItemTableViewCell
                cell.foodItemTableViewCellVM = self.searchRestaurentVM.getFoodItemTableViewCellVM()
                cell.itemId = { (id) in
                    DispatchQueue.main.async {
                        self.searchRestaurentVM.makeShopDetailsCall(id: id)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurentCell", for: indexPath) as! RestaurentCell
                cell.homeCollectionViewDownCellVM = self.searchRestaurentVM.getMyFevTableViewCellVM(index: indexPath.row)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.searchRestaurentVM.searchModel?.restaurants?[indexPath.row].id else { return }
        self.searchRestaurentVM.makeShopDetailsCall(id: id)
    }
}

//Textfield delegates
extension SearchRestaurentVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query = searchBar.text ?? ""
        self.searchRestaurentVM.getSearchItem(query: searchBar.text ?? "")
        self.searchBarField.endEditing(true)
    }
}
