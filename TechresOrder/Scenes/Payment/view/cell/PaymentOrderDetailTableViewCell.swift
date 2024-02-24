//
//  PaymentOrderDetailTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import RxSwift
class PaymentOrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: PayMentViewModel? {
           didSet {
              
               bindViewModel()
           }
    }
    func registerCell() {
        let paymentOrderDetailItemTableViewCell = UINib(nibName: "PaymentOrderDetailItemTableViewCell", bundle: .main)
        tableView.register(paymentOrderDetailItemTableViewCell, forCellReuseIdentifier: "PaymentOrderDetailItemTableViewCell")
     
        
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false
//        tableView
//            .rx.setDelegate(self)
//            .disposed(by: disposeBag)
        tableView.rowHeight = UITableView.automaticDimension
    }

}
extension PaymentOrderDetailTableViewCell{
    private func bindViewModel() {
            if let viewModel = viewModel {
                viewModel.dataOrderDetails.bind(to: tableView.rx.items(cellIdentifier: "PaymentOrderDetailItemTableViewCell", cellType: PaymentOrderDetailItemTableViewCell.self))
                    {  (row, orderDetail, cell) in
                        cell.data = orderDetail
                        cell.viewModel = self.viewModel
                        cell.preservesSuperviewLayoutMargins = false
                        cell.separatorInset = UIEdgeInsets.zero
                        cell.layoutMargins = UIEdgeInsets.zero
                        

                    }.disposed(by: disposeBag)
            }
     }
        
}
//extension PaymentOrderDetailTableViewCell: UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        dLog(CGFloat((viewModel?.order_detail_height.value)!))
//        return 80
//    }
//
//}
