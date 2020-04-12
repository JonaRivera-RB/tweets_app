//
//  HomeVC.swift
//  tweets-app
//
//  Created by Misael Rivera on 09/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Simple_Networking
import NotificationBannerSwift
import AVKit

class HomeVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let cellId = "TweetTVCell"
    private var dataSource = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPosts() {
        SVProgressHUD.show()
        
        SN.get(endpoint: Routes.GET_POST) { (result: SNResultWithEntity<[Tweet], ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            switch result {
            case .success(let tweets):
                self.dataSource = tweets
                self.tableView.reloadData()
                
            case .error(let error):
                NotificationBanner(subtitle: "\(error)", style: .warning).show()
                return
                
            case .errorResult(let entity):
                NotificationBanner(subtitle: "\(entity.error)", style: .warning).show()
                
                return
            }
        }
    }
    
    private func deletePost(indexPath: IndexPath) {
        SVProgressHUD.show()
        
        let postID = dataSource[indexPath.row].id
        let endpoint = Routes.DELETE_POST + postID
        
        SN.delete(endpoint: endpoint) { (result: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            SVProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.dataSource.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
            case .error(let error):
                NotificationBanner(subtitle: "\(error)", style: .warning).show()
                
            case .errorResult(let entity):
                NotificationBanner(subtitle: "\(entity.error)", style: .warning).show()
            }
        }
    }
}

//MARK: -UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? TweetTVCell {
            cell.setupCellWith(tweet: dataSource[indexPath.row])
            
            cell.needsToShowVideo = { url in
                let avPlayer = AVPlayer(url: url)
                
                let avPlayerController = AVPlayerViewController()
                avPlayerController.player = avPlayer
                
                self.present(avPlayerController, animated: true) {
                    avPlayerController.player?.play()
                }
            }
        }
        
        return cell
    }
}

//MARK: -UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (_, _) in
            self.deletePost(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //guardar correo del usuario y validar con uno real
        return dataSource[indexPath.row].author.email != "test@test.com"
    }
}
