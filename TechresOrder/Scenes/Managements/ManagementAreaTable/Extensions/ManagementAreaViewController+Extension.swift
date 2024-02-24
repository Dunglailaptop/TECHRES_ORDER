//
//  ManagementAreaViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation

extension ManagementAreaViewController {
    func getAreas(){
        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Areas Success...")
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
                    dLog(areas.toJSON())
                    self.viewModel.area_array.accept(areas)
                }
            }
        }).disposed(by: rxbag)
        
    }
}
    
extension ManagementAreaViewController{

    
    //MARK: Register Cells as you want
    func registerAreaCell(){
        let managementAreaCollectionViewCell = UINib(nibName: "ManagementAreaCollectionViewCell", bundle: .main)
        areaCollectionView.register(managementAreaCollectionViewCell, forCellWithReuseIdentifier: "ManagementAreaCollectionViewCell")
        
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 3 // Columns for .vertical, rows for .horizontal
        snCollectionViewLayout.itemSpacing = 20
        areaCollectionView.collectionViewLayout = snCollectionViewLayout

        behavior = MSCollectionViewPeekingBehavior(cellSpacing: CGFloat(-20), cellPeekWidth: CGFloat(17), maximumItemsToScroll: Int(1), numberOfItemsToShow: Int(3), scrollDirection: .horizontal)
        
        
//        behavior = MSCollectionViewPeekingBehavior(cellSpacing: CGFloat(10), cellPeekWidth: CGFloat(20), maximumItemsToScroll: Int(1), numberOfItemsToShow: Int(3), scrollDirection: .horizontal)
//
//        areaCollectionView.configureForPeekingBehavior(behavior: behavior)

        
        areaCollectionView.rx.modelSelected(Area.self) .subscribe(onNext: { element in
            print("Selected \(element)")
            self.presentModalCreateAreaViewController(area: element)
            
           
        })
        .disposed(by: rxbag)
        
    }
    
    

    func binđDataCollectionView(){
        viewModel.area_array.bind(to: areaCollectionView.rx.items(cellIdentifier: "ManagementAreaCollectionViewCell", cellType: ManagementAreaCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
}

extension ManagementAreaViewController: TechresDelegate{
    func presentModalCreateAreaViewController(area:Area = Area()!) {
            let createAreaViewController = CreateAreaViewController()
        createAreaViewController.area = area
        createAreaViewController.delegate = self
            createAreaViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: createAreaViewController)
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
        self.getAreas()
    }
      
}
