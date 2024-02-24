//
//  ChooseTableNeedMoveViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation


class ChooseTableNeedMoveViewController: BaseViewController {
    var viewModel = ChooseTableNeedMoveViewModel()
    private var router = ChooseTableNeedMoveRouter()
    var delegate:OrderMoveFoodDelegate?
    var delegateCallBack:TechresDelegate?
    var areas = [Area]()
    var table_id = 0
    var table_name = ""
    
    
    @IBOutlet weak var view_nodata: UIView!
    @IBOutlet weak var lbl_header_table_name: UILabel!
    @IBOutlet weak var areacollectionView: UICollectionView!
    @IBOutlet weak var tableCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_header_table_name.text = String(format: "CHUYỂN TỪ BÀN %@ SANG", table_name).uppercased()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.status.accept(String(format: "%d", STATUS_TABLE_CLOSED))
        viewModel.status_area.accept(ACTIVE)
        
        registerAreaCell()
        registerTableCell()
        binđDataAreaCollectionView()
        binđDataTableCollectionView()

        getAreas()
    }
 
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }

}
//MARK: This Part of extension is to register cell for tableCollectionView and bind data
extension ChooseTableNeedMoveViewController:SNCollectionViewLayoutDelegate{
    func registerTableCell(){
        let separateFoodCollectionViewCell = UINib(nibName: "SeparateFoodCollectionViewCell", bundle: .main)
        tableCollectionView.register(separateFoodCollectionViewCell, forCellWithReuseIdentifier: "SeparateFoodCollectionViewCell")

        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        tableCollectionView.collectionViewLayout = snCollectionViewLayout

        tableCollectionView.rx.modelSelected(TableModel.self) .subscribe(onNext: { element in
          print("Selected \(element)")
          self.presentModalConfirmMoveTableViewController(destination_table_name: self.table_name, target_table_name: element.name, destination_table_id: self.table_id, target_table_id: element.id)
        }).disposed(by: rxbag)
    }
    
    func binđDataTableCollectionView(){
        viewModel.table_array.bind(to: tableCollectionView.rx.items(cellIdentifier: "SeparateFoodCollectionViewCell", cellType: SeparateFoodCollectionViewCell.self)) { (index, element, cell) in
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
extension ChooseTableNeedMoveViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
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





//extension ChooseTableNeedMoveViewController{
//    func getAreas(){
//        viewModel.getAreas().subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                dLog("Get Areas Success...")
//                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
//                    dLog(areas.toJSON())
//                    self.areas = areas
//                    
//                    var allArea = Area.init()
//                    allArea?.id = -1
//                    allArea?.status = ACTIVE
//                    allArea?.name = "Tất cả khu vực"
//                    self.areas.insert(allArea!, at: 0)
//                    
//                    self.areas[0].is_select = 1
//                    self.viewModel.area_array.accept(self.areas)
//                    self.viewModel.area_id.accept(self.areas[0].id)
//                    self.getTables()
//                }
//               
//            }
//            
//           
//        }).disposed(by: rxbag)
//        
//    }
//    func getTables(){
//        viewModel.getTables().subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                dLog("Get Tables Success...")
//                if let tables  = Mapper<TableModel>().mapArray(JSONObject: response.data){
//                    dLog(tables.toJSON())
//                    self.viewModel.table_array.accept(tables.filter({$0.status != ORDER_STATUS_WAITING_WAITING_COMPLETE && $0.status != STATUS_TABLE_BOOKING}))
//                    
//                    self.view_nodata.isHidden = tables.count > 0 ? true : false
//                }
//
//            }
//        }).disposed(by: rxbag)
//        
//    }
//}
