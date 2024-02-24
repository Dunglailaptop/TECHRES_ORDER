//
//  CategoryManagementViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift

extension CategoryManagementViewController{
    func registerCell() {
        let categoryTableViewCell = UINib(nibName: "CategoryTableViewCell", bundle: .main)
        tableView.register(categoryTableViewCell, forCellReuseIdentifier: "CategoryTableViewCell")
        
        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
        
        tableView.rx.modelSelected(Category.self) .subscribe(onNext: { [self] element in
            print("Selected \(element)")
            self.presentModalCreateCategory(cate: element)
//            ManageCacheObject.saveCurrentBrand(element)
//            self.delegate?.callBackChooseBrand(brand: element)
//            self.navigationController?.dismiss(animated: true)
        })
        .disposed(by: rxbag)
        
    }
    
    func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "CategoryTableViewCell", cellType: CategoryTableViewCell.self))
           {  (row, cate, cell) in
               cell.data = cate
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}
extension CategoryManagementViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


//MARK: -- CALL API
extension CategoryManagementViewController {
    func getCategoriesManagement(){
        viewModel.getCategories().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let categories = Mapper<Category>().mapArray(JSONObject: response.data) {
//                    if(categories.count > 0){
//                        dLog(categories.toJSONString(prettyPrint: true) as Any)
//                        self.viewModel.dataArray.accept(categories)
//                    }else{
//                        self.viewModel.dataArray.accept([])
//                    }

                    self.viewModel.dataArray.accept( categories.count > 0 ? categories : [])
                    self.no_data_view.isHidden = categories.count > 0 ? true : false
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
extension CategoryManagementViewController: TechresDelegate{

    func presentModalCreateCategory(cate:Category = Category()!) {
            let createCategoryViewController = CreateCategoryViewController()
            createCategoryViewController.cate = cate
        createCategoryViewController.delegate = self
            createCategoryViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: createCategoryViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.medium()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
//            brandViewController.delegate = self
            present(nav, animated: true, completion: nil)

        }
    func callBackReload() {
        self.getCategoriesManagement()
    }
}
