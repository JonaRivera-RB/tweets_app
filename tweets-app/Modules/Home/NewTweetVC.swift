//
//  NewTweetVC.swift
//  tweets-app
//
//  Created by Misael Rivera on 10/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import FirebaseStorage
import AVFoundation
import MobileCoreServices
import AVKit

class NewTweetVC: UIViewController {
    
    //MARK: - IBOtlets
    @IBOutlet weak var postTextfield: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var showVideoButton: UIButton!
    
    //MARK: - Properties
    private var imagePicker: UIImagePickerController?
    private var currentVideUrl: URL?
    
    //MARK: - IBActions
    @IBAction func addPostAction() {
        //uploadImageToFirebase()
        uploadVideoFirebase()
    }
    
    @IBAction func openCameraAction() {
        
        let alert = UIAlertController(title: "Cámara", message: "Selecciona una opción", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Foto", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.openCameraVideo()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
              
    }
    
    @IBAction func showVideoAction() {
        showVideo()
    }
    
    @IBAction func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showVideoButton.isHidden = true
    }
    
    private func showVideo() {
        guard let currentVideUrl = currentVideUrl else { return }
        let avPlayer = AVPlayer(url: currentVideUrl)
        
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        
        present(avPlayerController, animated: true) {
            avPlayerController.player?.play()
        }
    }
    
    private func openCameraVideo() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = [kUTTypeMovie as String]
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .video
        imagePicker?.videoMaximumDuration = TimeInterval(5)
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else { return }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else { return }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadVideoFirebase() {
        guard let currentVideoSavedURL = currentVideUrl,
            let videoData: Data = try? Data(contentsOf: currentVideoSavedURL) else { return }
        
        SVProgressHUD.show()
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "video/mp4"
        
        let storage = Storage.storage()
        let videoName = Int.random(in: 100...1000)
        let folderReference = storage.reference(withPath: "video-tweet/\(videoName).mp4")
        
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(videoData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(subtitle: "\(error.localizedDescription)", style: .warning).show()
                        return
                    }
                    
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        print(url?.absoluteString ?? "")
                        let videoUrl = url?.absoluteString
                        self.savePost(imageUrl: nil, videoUrl: videoUrl)
                    }
                }
            }
        }
    }
    
    private func uploadImageToFirebase() {
        guard let imageSaved = postImageView.image,
            let imageSavedData: Data = imageSaved.jpegData(compressionQuality: 0.1) else { return }
        
        SVProgressHUD.show()
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        let storage = Storage.storage()
        let imageName = Int.random(in: 100...1000)
        let folderReference = storage.reference(withPath: "fotos-tweet/\(imageName).jpg")
        
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(imageSavedData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(subtitle: "\(error.localizedDescription)", style: .warning).show()
                        return
                    }
                    
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        print(url?.absoluteString ?? "")
                        let imageUrl = url?.absoluteString
                        self.savePost(imageUrl: imageUrl, videoUrl: nil)
                    }
                }
            }
        }
    }
    
    private func savePost(imageUrl: String?, videoUrl: String?) {
        
        guard let text = postTextfield.text, !text.isEmpty else {
            return
        }
        
        let request = TweetRequest(text: text, imageUrl: imageUrl, videoUrl: videoUrl, location: nil)
        SVProgressHUD.show()
        
        SN.post(endpoint: Routes.SEND_POST, model: request) { (result: SNResultWithEntity<Tweet, ErrorResponse>) in
            SVProgressHUD.dismiss()
            
            switch result {
            case .success( _):
                self.dismiss(animated: true, completion: nil)
                
            case .error(let error):
                NotificationBanner(subtitle: "\(error)", style: .warning).show()
                
                
            case .errorResult(let entity):
                NotificationBanner(subtitle: "\(entity.error)", style: .warning).show()
                
                
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension NewTweetVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker?.dismiss(animated: true, completion: nil)
        if info.keys.contains(.originalImage) {
            postImageView.isHidden = false
            postImageView.image = info[.originalImage] as? UIImage
        }
        
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL {
            showVideoButton.isHidden = false
            currentVideUrl = recordedVideoUrl
        }
    }
}
