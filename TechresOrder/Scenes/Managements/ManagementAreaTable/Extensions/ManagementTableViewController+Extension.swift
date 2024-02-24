//
//  ManagementTableViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import SNCollectionViewLayout
import MSPeekCollectionViewDelegateImplementation

//MARK: -- CALL API
extension ManagementTableViewController{
    func getAreas(){
        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Areas Success...")
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
                    dLog(areas.toJSON())
                    self.areas = areas
                    if((self.areas.count) != 0){
                        var allArea = Area.init()
                        allArea?.id = -1
                        allArea?.status = ACTIVE
                        allArea?.name = "Tất cả"
                        self.areas.insert(allArea!, at: 0)
                        self.areas[0].is_select = 1
                        self.viewModel.area_array.accept(self.areas)
                        self.viewModel.area_id.accept(-1)
                        self.viewModel.exclude_table_id.accept(-1)
                        self.getTables()
                    }
                    
                }
               
            }
            
           
        }).disposed(by: rxbag)
    }
        
    func getTables(){
        viewModel.getTables().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Tables Success...")
                if let tables  = Mapper<TableModel>().mapArray(JSONObject: response.data){
                    dLog(tables.toJSON())
                    self.viewModel.table_array.accept(tables)
                }

            }
        }).disposed(by: rxbag)
        
    }
    
}
extension ManagementTableViewController{
    
    //MARK: Register Cells as you want
    func registerAreaCell(){
        let areaCollectionViewCell = UINib(nibName: "AreaCollectionViewCell", bundle: .main)
        areacollectionView.register(areaCollectionViewCell, forCellWithReuseIdentifier: "AreaCollectionViewCell")
        
        
        behavior = MSCollectionViewPeekingBehavior(cellSpacing: CGFloat(0), cellPeekWidth: CGFloat(0), maximumItemsToScroll: Int(1), numberOfItemsToShow: Int(3), scrollDirection: .horizontal)
        areacollectionView.configureForPeekingBehavior(behavior: behavior)

        
        areacollectionView.rx.modelSelected(Area.self) .subscribe(onNext: { element in
            print("Selected \(element)")
            self.viewModel.area_id.accept(element.id)
            
            var areas = self.viewModel.area_array.value
            areas.enumerated().forEach { (index, value) in
                if(element.id == value.id){
                    areas[index].is_select = 1
                }else{
                    areas[index].is_select = 0
                }
            }
            self.viewModel.area_array.accept(areas)
            
            self.getTables()
        })
        .disposed(by: rxbag)
        
    }
    
    //MARK: Register Cells as you want
    func registerCell(){
        let tableCollectionViewCell = UINib(nibName: "TableManageCollectionViewCell", bundle: .main)
        tableCollectionView.register(tableCollectionViewCell, forCellWithReuseIdentifier: "TableManageCollectionViewCell")
        
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        tableCollectionView.collectionViewLayout = snCollectionViewLayout

        
        tableCollectionView.rx.modelSelected(TableModel.self) .subscribe(onNext: { element in
            print("Selected \(element)")
           
            self.presentModalCreateTableViewController(table: element)
           
        })
        .disposed(by: rxbag)
        
    }
    func binđDataAreaCollectionView(){
     
        viewModel.area_array.bind(to: areacollectionView.rx.items(cellIdentifier: "AreaCollectionViewCell", cellType: AreaCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
    func binđDataCollectionView(){
     
        viewModel.table_array.bind(to: tableCollectionView.rx.items(cellIdentifier: "TableManageCollectionViewCell", cellType: TableManageCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
}
extension ManagementTableViewController: TechresDelegate{
    func presentModalCreateTableViewController(table:TableModel = TableModel()!) {
            let createTableViewController = CreateTableViewController()
        createTableViewController.table = table
        createTableViewController.delegate = self
        createTableViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: createTableViewController)
            // 1
        nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
//            createAreaViewController.delegate = self
            present(nav, animated: true, completion: nil)

        }
    func callBackReload() {
        self.getTables()
    }
      
}
