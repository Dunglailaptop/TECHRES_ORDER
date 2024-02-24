//
//  BrandViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import ObjectMapper
import RxRelay
import RxSwift

class BrandViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    var viewModel = BrandViewModel()
    var router = BrandRouter()
    var key_word = ""
    var delegate:BrandDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()
        fetBrands()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSideBrand(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc func handleTapOutSideBrand(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Handle the touch outside event here
            self.navigationController?.dismiss(animated: true)
            
        }
    }
}
extension BrandViewController{
        func registerCell() {
            let brandTableViewCell = UINib(nibName: "BrandTableViewCell", bundle: .main)
            tableView.register(brandTableViewCell, forCellReuseIdentifier: "BrandTableViewCell")
            
            self.tableView.estimatedRowHeight = 100
//            self.tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            tableView
                .rx.setDelegate(self)
                .disposed(by: rxbag)
            
            tableView.rx.modelSelected(Brand.self) .subscribe(onNext: { [self] element in
                print("Selected \(element)")
                ManageCacheObject.saveCurrentBrand(element)
                self.delegate?.callBackChooseBrand(brand: element)
                self.navigationController?.dismiss(animated: true)
            })
            .disposed(by: rxbag)
            
        }
}
extension BrandViewController{
    
    private func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "BrandTableViewCell", cellType: BrandTableViewCell.self))
           {  (row, brand, cell) in
               cell.data = brand
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}
extension BrandViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension BrandViewController{
    private func fetBrands(){
        viewModel.status.accept(-1)
        viewModel.key_word.accept(key_word)
        
        viewModel.getBrands().subscribe(onNext: { (response) in
            dLog(response.toJSON())
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let brands = Mapper<Brand>().mapArray(JSONObject: response.data) {
                    if(brands.count > 0){
                        dLog(brands.toJSONString(prettyPrint: true) as Any)
                        let brands_filter = brands.filter({$0.is_office == DEACTIVE})// Loại trừ chi nhánh văn  mảng phòng ra khỏi
                        self.viewModel.dataArray.accept(brands_filter)
                        
//                        self.viewModel.dataArray.accept(brands)
                    }else{
                        self.viewModel.dataArray.accept([])
                    }
                        
                }
               
                 
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}

