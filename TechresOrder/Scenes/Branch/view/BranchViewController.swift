//
//  BranchViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import ObjectMapper
import RxRelay
import RxSwift

class BranchViewController: BaseViewController {

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    var viewModel = BranchViewModel()
    var router = BranchRouter()
    var key_word = ""
    var delegate:BranchDelegate?
    var brand_id:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        root_view.round(with: .top, radius: 8)
        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()
        viewModel.brand_id.accept(self.brand_id)
        fetBranches()
        
        
        
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
extension BranchViewController{
        func registerCell() {
            let branchTableViewCell = UINib(nibName: "BranchTableViewCell", bundle: .main)
            tableView.register(branchTableViewCell, forCellReuseIdentifier: "BranchTableViewCell")
            
            self.tableView.estimatedRowHeight = 170
            self.tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            tableView.rx.modelSelected(Branch.self) .subscribe(onNext: { [self] element in
                print("Selected \(element)")
                self.delegate?.callBackChooseBranch(branch: element)
                ManageCacheObject.saveCurrentBranch(element)
                self.navigationController?.dismiss(animated: true)
            })
            .disposed(by: rxbag)
            
//            tableView
//                .rx.setDelegate(self)
//                .disposed(by: rxbag)
        }
    
    

}



extension BranchViewController{
    
    private func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "BranchTableViewCell", cellType: BranchTableViewCell.self))
           {  (row, branch, cell) in
               cell.data = branch
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}
extension BranchViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
}


extension BranchViewController{
    private func fetBranches(){
        viewModel.status.accept(-1)
        viewModel.key_word.accept(key_word)
        
        viewModel.getBranches().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let branches = Mapper<Branch>().mapArray(JSONObject: response.data) {
                    if(branches.count > 0){
                        dLog(branches.toJSONString(prettyPrint: true) as Any)
                        let branches_filter = branches.filter({$0.is_office == DEACTIVE})// Loại trừ chi nhánh văn  mảng phòng ra khỏi
                        self.viewModel.dataArray.accept(branches_filter)
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

