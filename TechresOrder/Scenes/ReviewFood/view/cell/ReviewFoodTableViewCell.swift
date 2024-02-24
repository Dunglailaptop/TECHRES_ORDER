//
//  ReviewFoodTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import RxSwift
class ReviewFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_food_name: UILabel!
    
    @IBOutlet weak var food_avatar: UIImageView!
    
    @IBOutlet weak var btn_very_good: UIButton!
    @IBOutlet weak var btn_good: UIButton!
    @IBOutlet weak var btn_normal: UIButton!
    @IBOutlet weak var btn_bad: UIButton!
    @IBOutlet weak var btn_very_bad: UIButton!
    
    @IBOutlet weak var textfield_comment: UITextField!
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        btn_very_good.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .light)
//        btn_good.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .light)
//        btn_normal.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .light)
//        btn_bad.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .light)
//        btn_very_bad.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .light)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: ReviewFoodViewModel? {
           didSet {
              
               
           }
    }
    func setupReviewCore(btn_selected:UIButton){
        
        btn_very_good.backgroundColor = ColorUtils.white()
        btn_good.backgroundColor = ColorUtils.white()
        btn_normal.backgroundColor = ColorUtils.white()
        btn_bad.backgroundColor = ColorUtils.white()
        btn_very_bad.backgroundColor = ColorUtils.white()
        
        btn_very_good.tintColor = ColorUtils.main_color()
        btn_good.tintColor = ColorUtils.main_color()
        btn_normal.tintColor = ColorUtils.main_color()
        btn_bad.tintColor = ColorUtils.main_color()
        btn_very_bad.tintColor = ColorUtils.main_color()
        
        btn_selected.backgroundColor = ColorUtils.main_color()
        btn_selected.tintColor = ColorUtils.white()
        
    }
    func setupReviewCoreDefault(){
        btn_very_good.backgroundColor = ColorUtils.white()
        btn_good.backgroundColor = ColorUtils.white()
        btn_normal.backgroundColor = ColorUtils.white()
        btn_bad.backgroundColor = ColorUtils.white()
        btn_very_bad.backgroundColor = ColorUtils.white()
        
        btn_very_good.tintColor = ColorUtils.main_color()
        btn_good.tintColor = ColorUtils.main_color()
        btn_normal.tintColor = ColorUtils.main_color()
        btn_bad.tintColor = ColorUtils.main_color()
        btn_very_bad.tintColor = ColorUtils.main_color()
        
    }
    
    // MARK: - Variable -
    public var data: OrderDetail? = nil {
        didSet {
            lbl_food_name.text = data?.name
            
            let link_image = Utils.getFullMediaLink(string: data?.food_avatar ?? "")
            food_avatar.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
            
            if(data?.review_score == -3){
                textfield_comment.isHidden = false
                textfield_comment.text = data?.note
            }else{
                textfield_comment.isHidden = true
                textfield_comment.text = data?.note
            }
           
            
            
            switch(data?.review_score){
            case 1:
                self.setupReviewCore(btn_selected: btn_normal)
                break
            case 2:
                self.setupReviewCore( btn_selected: btn_good)
                break
                
            case 3:
                self.setupReviewCore( btn_selected: btn_very_good)
                break
                
            case -2:
                self.setupReviewCore( btn_selected: btn_bad)
                break
            case -3:
                self.setupReviewCore(btn_selected: btn_very_bad)
                break
            default:
                self.setupReviewCoreDefault()
                break
            }
        }
    }
    
    
    
}
