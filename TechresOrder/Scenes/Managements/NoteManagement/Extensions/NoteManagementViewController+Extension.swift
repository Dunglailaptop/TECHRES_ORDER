//
//  NoteManagementViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension NoteManagementViewController{
    func registerCell() {
        let noteTableViewCell = UINib(nibName: "NoteTableViewCell", bundle: .main)
        tableView.register(noteTableViewCell, forCellReuseIdentifier: "NoteTableViewCell")
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
        
        tableView.rx.modelSelected(Note.self) .subscribe(onNext: { [self] element in
            print("Selected \(element)")
//            ManageCacheObject.saveCurrentBrand(element)
//            self.delegate?.callBackChooseBrand(brand: element)
//            self.navigationController?.dismiss(animated: true)
        })
        .disposed(by: rxbag)
        
    }
    
    func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "NoteTableViewCell", cellType: NoteTableViewCell.self))
           {  (row, note, cell) in
               cell.data = note
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}
extension NoteManagementViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.viewModel.dataArray.value[indexPath.row]
        self.presentModalCreateNote(note: note)
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var  configuration : UISwipeActionsConfiguration?
        // edit action
        let edit = UIContextualAction(style: .normal,
                                         title: "Chỉnh sửa") { [weak self] (action, view, completionHandler) in
            
            let notes = self?.viewModel.dataArray.value
            self?.handleEditNote(note:notes![indexPath.row])
                                            completionHandler(true)
        }
        edit.image = UIImage(named: "icon-edit")

        // delete action
        let delete = UIContextualAction(style: .normal,
                                         title: "Xóa") { [weak self] (action, view, completionHandler) in
            
            let notes = self?.viewModel.dataArray.value
            self?.handleDeleteNote(note:notes![indexPath.row])
                                            completionHandler(true)
        }
        delete.backgroundColor = ColorUtils.red_color()
        delete.image = UIImage(named: "icon-cancel-food")
        
        
        
        configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration!.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
}

//MARK: -- CALL API
extension NoteManagementViewController {
    func getNotes(){
        viewModel.getNotesManagement().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let notes = Mapper<Note>().mapArray(JSONObject: response.data) {
//                    if(notes.count > 0){
//                        self.viewModel.dataArray.accept(notes)
//                    }else{
//                        self.viewModel.dataArray.accept([])
//                    }
//                    
                    self.viewModel.dataArray.accept(notes.count > 0 ? notes : [])
                    self.no_data_view.isHidden = notes.count > 0 ? true : false
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    func deleteNote(){
        viewModel.deleteNote().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Create Note Success...")
//                Toast.show(message: "Xóa ghi chú thành công", controller: self)
                JonAlert.showSuccess(message: "Xóa ghi chú thành công!", duration: 2.0)
                self.getNotes()
//                self.viewModel.makePopViewController()
            }
        }).disposed(by: rxbag)
}
    
    
}
extension NoteManagementViewController:TechresDelegate{

    func presentModalCreateNote(note:Note = Note()!) {
            let createNoteViewController = CreateNoteViewController()
            createNoteViewController.note = note
            createNoteViewController.delegate = self
            createNoteViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: createNoteViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.medium()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
//            brandViewController.delegate = self
            present(nav, animated: true, completion: nil)

        }
    func callBackReload() {
        self.getNotes()
    }
}
extension NoteManagementViewController{

    public func handleEditNote(note:Note) {
        print("handleEditNote")
        dLog(note.toJSON())
        self.presentModalCreateNote(note: note)
    }

    public func handleDeleteNote(note:Note) {
        print("handleDeleteNote")
        var noteRequest = NoteRequest()
        noteRequest.id = note.id
        noteRequest.delete = ACTIVE
        noteRequest.content = note.content
        viewModel.noteRequest.accept(noteRequest)
        self.deleteNote()
        

    }
    
}
