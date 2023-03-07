//
//  NewPlaceViewController.swift
//  tableViewApp
//
//  Created by Рустам Т on 2/10/23.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var currentPlace: Place?
    
    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBOutlet weak var placeName: UITextField!
    
    
    @IBOutlet weak var placeLocation: UITextField!
    
    
    @IBOutlet weak var placeType: UITextField!
    
   
    var imageIsChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        //проверка на пустоту текстфилда с именем
        placeName.addTarget(self, action: #selector(textChanged), for: .editingChanged) 
        //убираем разлиновку
        tableView.tableFooterView = UIView()
        setUpEditScreen()
    }
    
    //MARK: - tableViewDelegate
    //скрываем клавиатуру по тапу за пределы ячейки с выбором картинки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
            let cameraIcon = UIImage(imageLiteralResourceName: "camera")
            let photoIcon = UIImage(imageLiteralResourceName: "photo")
            //MARK: - создаем контроллер с выбором камеры, фото и канцелом
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
        }else{
            view.endEditing(true)
        }
    }
    
    private func setUpEditScreen(){
        if currentPlace != nil{
            editNavigationBar()
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeType.text = currentPlace?.type
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            imageIsChange = true 
        }
    }
    
    private func editNavigationBar(){
        if let button = navigationController?.navigationBar.topItem{
            button.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    func savePlace(){
         
        var image:UIImage?
        if imageIsChange{
            image = placeImage.image
        }else{
            image = UIImage(imageLiteralResourceName: "food")
        }
        
        let imageData = image?.pngData()
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData)

        if currentPlace != nil{
            try! realm.write{
                currentPlace?.name = newPlace.name
                currentPlace?.type = newPlace.type
                currentPlace?.location = newPlace.location
                currentPlace?.imageData = newPlace.imageData
            }
            
        }else{
            Storage.addNewPlace(newPlace)
        }
       
            
       
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true )
    }
    
}

// MARK: - TextFieldDelegate

extension NewPlaceViewController: UITextFieldDelegate{
    // скрываем клавиатуру по нажатию на done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //метод проверят пустая ли ячейка с именем
    @objc private func textChanged(){
        if placeName.text?.isEmpty == false{
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
}

//MARK: - work with IMage функциональность позволяет выбирать - добавить фото / сделать снимок
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker (sourse: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourse){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleToFill
        imageIsChange = true
        placeImage.clipsToBounds = true
        dismiss(animated: true )
    }
}
