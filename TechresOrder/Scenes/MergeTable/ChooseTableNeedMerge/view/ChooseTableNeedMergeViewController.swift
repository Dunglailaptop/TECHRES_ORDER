//
//  ChooseTableNeedMergeViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation
import RxSwift
class ChooseTableNeedMergeViewController:BaseViewController {
    
    var viewModel = ChooseTableNeedMergeViewModel()
    private var router = ChooseTableNeedMergeRouter()
    var areas = [Area]()
    var table_id = 0
    var table_name = ""
    var delegate:OrderMoveFoodDelegate?
    var delegateCallBackReload:TechresDelegate?

    
    @IBOutlet weak var lbl_header_table_name: UILabel!
    @IBOutlet weak var view_nodata: UIView!
    @IBOutlet weak var areacollectionView: UICollectionView!
    @IBOutlet weak var tableCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        lbl_header_table_name.text = String(format: "GỘP BÀN %@ ", table_name).uppercased()
   
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.status.accept(String(format: "%d,%d,%d", STATUS_TABLE_CLOSED, STATUS_TABLE_USING, STATUS_TABLE_BOOKING))
        viewModel.order_statuses.accept("")
        viewModel.status_area.accept(ACTIVE)
        
        
        registerAreaCell()
        registerTableCell()
        binđDataAreaCollectionView()
        binđDataTableCollectionView()

        self.viewModel.exclude_table_id.accept(self.table_id)
        getAreas()
    }
    
    

 

    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func actionMerger(_ sender: Any) {
        var tables = self.viewModel.table_array.value
        var target_table_ids = [Int]()
        tables.enumerated().forEach { (index, value) in
            if(value.is_selected == 1){
                target_table_ids.append(value.id)
            }
        }
        viewModel.destination_table_id.accept(self.table_id)
        viewModel.target_table_ids.accept(target_table_ids)
        self.mergeTable()
//        self.navigationController?.dismiss(animated: true)
    }
}


//MARK: This Part of extension is to register cell for tableCollectionView and bind data
extension ChooseTableNeedMergeViewController:SNCollectionViewLayoutDelegate{
    
    func registerTableCell(){
        let chooseTableNeedMergeCollectionViewCell = UINib(nibName: "ChooseTableNeedMergeCollectionViewCell", bundle: .main)
        tableCollectionView.register(chooseTableNeedMergeCollectionViewCell, forCellWithReuseIdentifier: "ChooseTableNeedMergeCollectionViewCell")
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        tableCollectionView.collectionViewLayout = snCollectionViewLayout
        tableCollectionView.rx.modelSelected(TableModel.self).subscribe(onNext: { element in
            var tables = self.viewModel.table_array.value
            tables.enumerated().forEach { (index, value) in
                if(element.id == value.id){
                    tables[index].is_selected = element.is_selected == 0 ? 1 : 0
                }
            }
            self.viewModel.table_array.accept(tables)
        }).disposed(by: rxbag)
    }
    
    func binđDataTableCollectionView(){
        viewModel.table_array.bind(to: tableCollectionView.rx.items(cellIdentifier: "ChooseTableNeedMergeCollectionViewCell", cellType: ChooseTableNeedMergeCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
       if indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 10 || indexPath.row == 70 {
           return 2
       }
       return 1
    }
    
}



//MARK: This Part of extension is to register cell for areacollectionView and bind data and implement some method of protocol
extension ChooseTableNeedMergeViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func registerAreaCell(){
        let areaCollectionViewCell = UINib(nibName: "AreaCollectionViewCell", bundle: .main)
        areacollectionView.register(areaCollectionViewCell, forCellWithReuseIdentifier: "AreaCollectionViewCell")
        areacollectionView.rx.modelSelected(Area.self).subscribe(onNext: { element in
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
        areacollectionView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
    
    func binđDataAreaCollectionView(){
        viewModel.area_array.bind(to: areacollectionView.rx.items(cellIdentifier: "AreaCollectionViewCell", cellType: AreaCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //nếu mà width của text đó mà bé hơn 50 thì cho width của collectionViewCell đó = 80s
        if(collectionView == areacollectionView){
            return CGSize(width:
                            Int(viewModel.area_array.value[indexPath.item].name.widthOfString(usingFont: UIFont.systemFont(ofSize: 14))) < 50
                            ? 80
                            : Int(viewModel.area_array.value[indexPath.item].name.widthOfString(usingFont: UIFont.systemFont(ofSize: 16)) + 10)
                          ,height: 60)
        }
        return CGSize(width: 0, height: 0)
    }
    
}

