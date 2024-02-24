//
//  UtilitiesBranchTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
import Kingfisher
class UtilitiesBranchTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_branch_name: UILabel!
    
    @IBOutlet weak var lbl_branch_address: UILabel!
    
    @IBOutlet weak var avatar_branch: UIImageView!
    
    @IBOutlet weak var btnEditBranch: UIButton!
    @IBOutlet weak var btnChooseBranch: UIButton!
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        lbl_branch_name.text = ManageCacheObject.getCurrentUser().branch_name
//        lbl_branch_address.text =  ManageCacheObject.getCurrentUser().branch_address
        let link_image = Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo )
        avatar_branch.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text =  ManageCacheObject.getCurrentBranch().address
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: UtilitiesViewModel? {
           didSet {
             
               bindViewModel()
           }
    }
    
}
extension UtilitiesBranchTableViewCell{
    private func bindViewModel() {
        if let viewModel = viewModel{
           
            viewModel.branch.subscribe( // Thực hiện subscribe Observable
              onNext: { [weak self] branch in
                  dLog(branch.toJSON())
                  if(branch.id > 0){
                      self!.lbl_branch_name.text = branch.name
                      self!.lbl_branch_address.text =  branch.address
                     
                  }
                  
              }).disposed(by: disposeBag)
            
            //if(ManageCacheObject.getSetting().service_restaurant_level_id < 1){
                
                viewModel.account.subscribe( // Thực hiện subscribe Observable
                  onNext: { [weak self] account in
                      let link_image = Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo )
                      dLog(link_image)
                      self!.avatar_branch.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
                  }).disposed(by: disposeBag)
           // }
           
             
            
        }
    }
}
