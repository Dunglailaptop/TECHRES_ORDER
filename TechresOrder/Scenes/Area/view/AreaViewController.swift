//
//  AreaViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation
import JonAlert

class AreaViewController: BaseViewController {
    var viewModel = AreaViewModel()
    private var router = AreaRouter()
    var count = 1
    var areas = [Area]()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var areaStackView: UIStackView!
    @IBOutlet weak var areaStackViewItem4: UIView!
    @IBOutlet weak var areaStackViewItem3: UIView!
    @IBOutlet weak var areaStackViewItem2: UIView!
    @IBOutlet weak var areaStackViewItem1: UIView!
    @IBOutlet weak var areacollectionView: UICollectionView!
    
    @IBOutlet weak var root_view_branch: UIView!
    @IBOutlet weak var root_view_point: UIView!
    @IBOutlet weak var constraint_filter_view: NSLayoutConstraint!
    @IBOutlet weak var view_locked_order: UIView!
    @IBOutlet weak var lbl_target_amount: UILabel!
    @IBOutlet weak var lbl_target_point: UILabel!
    @IBOutlet weak var tableCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        Utils.isHideAllView(isHide: true, view: view_locked_order)
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE){
            Utils.isHideAllView(isHide: false, view: view_locked_order)
        }
        Utils.isHideView(isHide: true, view: root_view_branch)
      

        viewModel.bind(view: self, router: router)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.status.accept("")
        viewModel.order_statuses.accept("")

        
        setupAreaCollectionView()
        setupTableCollectionView()
        checkLevelShowCurrentPointOfEmployee()
        getCurrentPoint(employee_id: ManageCacheObject.getCurrentUser().id)
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableCollectionView.addSubview(refreshControl)
        
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        
        lbl_target_point.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_target_point))
        lbl_target_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_bonus_salary))
        viewModel.status_area.accept(ACTIVE)
        getAreas()
        
    }
    @objc func refresh(_ sender: AnyObject) {

            self.getTables()
            self.getAreas()
            refreshControl.endRefreshing()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
//
//        lbl_target_point.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_target_point))
//        lbl_target_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_bonus_salary))
//        viewModel.status_area.accept(ACTIVE)
//        getAreas()
        getTables()
    }
    
    private func setupAreaCollectionView(){
        NSLayoutConstraint.activate([
            self.areaStackViewItem1.widthAnchor.constraint(equalTo: self.areaStackView.widthAnchor, multiplier: 0.25),
            self.areaStackViewItem2.widthAnchor.constraint(equalTo: self.areaStackView.widthAnchor, multiplier: 0.27),
            self.areaStackViewItem3.widthAnchor.constraint(equalTo: self.areaStackView.widthAnchor, multiplier: 0.24),
            self.areaStackViewItem4.widthAnchor.constraint(equalTo: self.areaStackView.widthAnchor, multiplier: 0.24)
        ])
        registerTableCollectionViewCell()
        binđDataTableCollectionView()
    }
    
    
    
    private func setupTableCollectionView(){
        registerAreaCell()
        binđDataAreaCollectionView()
    }
}





//MARK: This Part of extension is to register cell for tableCollectionView and bind data
extension AreaViewController:SNCollectionViewLayoutDelegate{
    
    func registerTableCollectionViewCell(){
        let tableCollectionViewCell = UINib(nibName: "TableCollectionViewCell", bundle: .main)
        tableCollectionView.register(tableCollectionViewCell, forCellWithReuseIdentifier: "TableCollectionViewCell")
        
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        tableCollectionView.collectionViewLayout = snCollectionViewLayout
        tableCollectionView.rx.modelSelected(TableModel.self) .subscribe(onNext: { element in
            self.viewModel.order_id.accept(element.order_id)
            self.viewModel.table_name.accept(element.name)
            self.viewModel.area_id.value == -1 ? self.viewModel.area_id.accept(-1) : self.viewModel.area_id.accept(element.area_id)
            self.viewModel.is_gift.accept(ADD_FOOD)
            self.viewModel.table_id.accept(element.id)
            if(element.order_status == ORDER_STATUS_WAITING_WAITING_COMPLETE){
                JonAlert.showError(message:"Đơn hàng đang chờ thu tiền bạn không được phép thao tác.", duration: 3.0)
            }else if(element.status == STATUS_TABLE_MERGED){
                let message = String(format: "Bàn %@ đang được gộp với bàn %@. Bạn có muốn đóng bàn %@ hay không?", element.name, element.merge_table_name, element.name)
                self.presentModalDialogConfirmViewController(dialog_type: 1, title: "XÁC NHẬN ĐÓNG BÀN ĐANG GỘP", content: message)
                self.viewModel.table_id.accept(element.id)
            }else if(element.status == STATUS_TABLE_BOOKING){
                JonAlert.showError(message: "Bàn đang có khách đặt trước bạn không được phép thao tác.", duration: 3.0)
            }else{
                if(element.order_id > 0){
                    self.viewModel.makeOrderDetailViewController()
                }else{
                    self.viewModel.table_id.accept(element.id)
                    self.viewModel.area_id.accept(element.area_id)
                    self.viewModel.makeNavigatorAddFoodViewController()
                }
            }
        }).disposed(by: rxbag)
    }
    
    
    func binđDataTableCollectionView(){
        viewModel.table_array.bind(to: tableCollectionView.rx.items(cellIdentifier: "TableCollectionViewCell", cellType: TableCollectionViewCell.self)) { (index, element, cell) in
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
extension AreaViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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


