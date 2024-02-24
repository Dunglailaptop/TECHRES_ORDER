//
//  CreateNoteViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import JonAlert
class CreateNoteViewController: BaseViewController {
    var viewModel = CreateNoteViewModel()
    var router = CreateNoteRouter()
    
    var delegate:TechresDelegate?
    
    @IBOutlet weak var lbl_count_text: UILabel!
    @IBOutlet weak var root_view: UIView!
    
    var is_deleted = 0
    @IBOutlet weak var textview_note: UITextView!
    @IBOutlet weak var btnCreate: UIButton!
    var noteRequest = NoteRequest.init()
    var note = Note()
    
    @IBOutlet weak var lbl_header: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        textview_note.withDoneButton()
        textview_note.becomeFirstResponder()
        btnCreate.setTitle("THÊM", for: .normal)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.is_deleted.accept(is_deleted)
        
        
        _ = textview_note.rx.text.map { $0 ?? "" }.bind(to: viewModel.noteContentText)

        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btnCreate.isEnabled = isValid
            strongSelf.btnCreate.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
            strongSelf.btnCreate.titleLabel?.textColor = .white
            
            self?.lbl_count_text.text = "\(self?.textview_note.text.trim().count ?? 0)/50"
            if (self?.textview_note.text.trim().count)! > 50 {
                self?.textview_note.text = String((self?.textview_note.text.prefix(50))!)
//                Toast.show(message: "Ghi chú tối đa 50 ký tự!", controller: self!)
                JonAlert.showError(message: "Ghi chú tối đa 50 ký tự!", duration: 2.0)
            }
        })
        lbl_header.text = "tạo mới ghi chú".uppercased()
        if(note!.id > 0 ){// update note
            lbl_header.text = "cập nhật ghi chú".uppercased()
            btnCreate.setTitle("CẬP NHẬT", for: .normal)
            var noteRequest = NoteRequest()
            noteRequest.id = note!.id
            noteRequest.content = note!.content
            viewModel.noteRequest.accept(noteRequest)
            textview_note.text = note?.content
        }
        
    }

    @IBAction func actionCreate(_ sender: Any) {
        noteRequest.content = viewModel.noteContentText.value.trimmingCharacters(in: .whitespacesAndNewlines)
        noteRequest.delete = is_deleted
        noteRequest.id = note!.id
        noteRequest.branch_id = ManageCacheObject.getCurrentBranch().id
        viewModel.noteRequest.accept(noteRequest)
        
        self.createUpdateNote()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.viewModel.makePopViewController()
    }
    

}
