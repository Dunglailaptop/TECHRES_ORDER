//
//  NoteViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 15/01/2023.
//

import UIKit
import RxSwift
import TagListView
import ObjectMapper

class NoteViewController: BaseViewController, TagListViewDelegate {
    var viewModel = NoteViewModel()

    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var textview_note: UITextView!
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_number_character_note: UILabel!
    var delegate: NotFoodDelegate?
    var pos:Int = 0
    var food_note = ""
    var notes_str = ""
//    var order_detail_id = 0
    var food_id = 0
//    var food_notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        root_view.round(with: .both, radius: 8)
        _ = textview_note.rx.text.map { $0 ?? "" }.bind(to: viewModel.note)

        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btnSubmit.isEnabled = isValid
            strongSelf.btnSubmit.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
            strongSelf.btnSubmit.titleLabel?.textColor = .white
        })

        textview_note.rx.text
               .subscribe(onNext: {
                   self.lbl_number_character_note.text = String(format: "%d/%d", $0!.count, 50)
                   
                   if self.textview_note.text!.count > 50 {
                       self.textview_note.text = String(self.textview_note.text.prefix(50))
                   }
               })
               .disposed(by: rxbag)
        
  
        
        textview_note.withDoneButton()
        dLog(food_note)
        textview_note.text = food_note
        
//        tagListView.textFont = UIFont.systemFont(ofSize: 24)
//        tagListView.alignment = .center // possible values are [.leading, .trailing, .left, .center, .right]
        
      
       
//
//        tagListView.addTag("TagListView")
//        tagListView.addTag("TEAChart")
//        tagListView.addTag("To Be Removed")
//        tagListView.addTag("To Be Removed")
//        tagListView.addTag("Quark Shell")
//        tagListView.removeTag("To Be Removed")
//        tagListView.removeTag("To Be Removed")
//        tagListView.removeTag("To Be Removed")
//        tagListView.removeTag("To Be Removed")
//        tagListView.removeTag("To Be Removed")
//        tagListView.removeTag("To Be Removed")
//        tagListView.removeTag("To Be Removed")
//        tagListView.onTap = { [weak self] tagView in
//            self?.tagListView.removeTagView(tagView)
//        }
        tagListView.delegate = self
        tagListView.tagBackgroundColor = ColorUtils.main_color()
//        tagListView.borderColor = ColorUtils.main_color()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.order_detail_id.accept(self.food_id)
        dLog(self.food_id)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentUser().branch_id)
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
            notes()
        }else{
            notesByFood()
           
        }
    }
    @IBAction func actionAddNote(_ sender: Any) {
        
        if textview_note.text!.count > 50 {
            textview_note.text = String(textview_note.text.prefix(50))
            
        }
        delegate?.callBackNoteFood(pos: pos, note: textview_note.text)
                self.navigationController?.dismiss(animated: true)
    }
    @IBAction func actionCanCel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    
    // MARK: TagListViewDelegate
        func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
            print("Tag pressed: \(title), \(sender)")
//            tagView.isSelected = !tagView.isSelected
//            self.textview_note.text = title
//
//            notes_str.append(contentsOf: textview_note.text)

            if(notes_str.count>0){
                if(!notes_str.contains(title)){
                    notes_str.append(contentsOf: String(format: ", %@", title))
                }
            }else{
                notes_str.append(contentsOf: title)
            }

            if textview_note.text.count > 50 {
                return
            } else {
//                textview_note.text = ""
                textview_note.text = notes_str
            }

//            notes_str = ""
            
        }
        
        func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
            print("Tag Remove pressed: \(title), \(sender)")
            sender.removeTagView(tagView)
        }
    

}
extension NoteViewController{
    func notes(){
        viewModel.notes().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Notes Success...")
                if let notes  = Mapper<Note>().mapArray(JSONObject: response.data){
                    dLog(notes.toJSON())
                    dLog(response.toJSON())
                    dLog(response.data as Any)
                    dLog(response.message)
                    for note in notes {
                        self.tagListView.addTag(note.content)
                        dLog(note.content)
                    }
                }
            }else{
                dLog(response.message)
            }
        }).disposed(by: rxbag)
        
    }
    
    func notesByFood(){
        viewModel.notesByFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Notes Success...")
                if let notes  = Mapper<Note>().mapArray(JSONObject: response.data){
                    dLog(notes.toJSON())
                    for note in notes {
                        self.tagListView.addTag(note.note)
                    }
                }
            }
        }).disposed(by: rxbag)

    }
}
