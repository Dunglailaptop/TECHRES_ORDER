//
//  SeparateFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation


class SeparateFoodViewController: BaseViewController {
    
    var viewModel = SeparateFoodViewModel()
    private var router = SeparateFoodRouter()
    
    @IBOutlet weak var lbl_header_table_name: UILabel!

    var delegate:OrderMoveFoodDelegate?
    /// Horizontal Group Avatar Collection View
   
    @IBOutlet weak var areacollectionView: UICollectionView!
    
    var areas = [Area]()
    
    var table_id = 0
    var table_name = ""
    var order_id = 0
    var only_one = 0
    @IBOutlet weak var tableCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_header_table_name.text = String(format: "TÁCH MÓN TỪ BÀN %@ SANG", table_name).uppercased()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.exclude_table_id.accept(self.table_id)
        viewModel.status.accept(String(format: "%d,%d,%d", STATUS_TABLE_CLOSED, STATUS_TABLE_USING, STATUS_TABLE_BOOKING))
        viewModel.status_area.accept(ACTIVE)
        
        
        registerAreaCell()
        registerTableCell()
        binđDataAreaCollectionView()
        binđDataTableCollectionView()

        getAreas()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
}


//MARK: This Part of extension is to register cell for tableCollectionView and bind data
extension SeparateFoodViewController:SNCollectionViewLayoutDelegate{
    
    func registerTableCell(){
        let separateFoodCollectionViewCell = UINib(nibName: "SeparateFoodCollectionViewCell", bundle: .main)
        tableCollectionView.register(separateFoodCollectionViewCell, forCellWithReuseIdentifier: "SeparateFoodCollectionViewCell")

        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        tableCollectionView.collectionViewLayout = snCollectionViewLayout


        tableCollectionView.rx.modelSelected(TableModel.self) .subscribe(onNext: { element in
          print("Selected \(element)")
            self.presentModalConfirmSeparateFoodViewController(order_id: self.order_id, destination_table_name: self.table_name, target_table_name: element.name, destination_table_id: self.table_id, target_table_id: element.id, target_order_id: element.order_id)

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
extension SeparateFoodViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
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
                            : Int(viewModel.area_array.value[indexPath.item].name.widthOfString(usingFont: UIFont.systemFont(ofSize: 16)) + 20)
                          ,height: 60)
        }
        return CGSize(width: 0, height: 0)
    }
    
}



