//
//  VideoViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/08/28.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import SkyWay

class VideoViewController: UIViewController {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var toUserView: UIView!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    fileprivate var peer: SKWPeer?
    fileprivate var mediaConnection: SKWMediaConnection?
    fileprivate var localStream: SKWMediaStream?
    fileprivate var remoteStream: SKWMediaStream?
    var toUserId = ""
    private var user = User()
    private var currentUser = User()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserAndValidate()
        setupUI()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mediaConnection?.close()
        self.peer?.destroy()
    }
    
    // MARK: - Actions
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        
        let position = localStream?.getCameraPosition()
        if position == SKWCameraPositionEnum.CAMERA_POSITION_BACK {
            localStream?.setCameraPosition(.CAMERA_POSITION_FRONT)
        } else {
            localStream?.setCameraPosition(.CAMERA_POSITION_BACK)
        }
    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        
        guard let peer = self.peer else{
            return
        }
        self.callPeerIDSelectDialog(peer: peer, myPeerId: peer.identity, toUser: self.user) { (peerId) in
            self.call(targetPeerId: peerId)
        }
    }
    
    @IBAction func callEndButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "通話を終了します\nよろしいですか？", preferredStyle: .alert)
        let endCall: UIAlertAction = UIAlertAction(title: "終了する", style: UIAlertAction.Style.default) { (alert) in
            self.mediaConnection?.close()
            self.changeConnectionStatusUI(connected: false)
            updateToUser(self.toUserId, withValue: [ISCALL: false])
            updateUser(withValue: [CALLED: false])
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(endCall)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        
        let move:CGPoint = sender.translation(in:self.view)
        sender.view!.center.x += move.x
        sender.view!.center.y += move.y
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // MARK: - Fetch
    
    private func fetchUserAndValidate() {
        
        User.fetchToUserAddSnapshotListener(toUserId: toUserId) { (user) in
            self.user = user
            self.nameLabel.text = self.user.username

            User.fetchUser(User.currentUserId()) { (user) in
                self.currentUser = user
                
                if self.user.isCall == true && self.currentUser.isCall == true && self.user.called == true && self.currentUser.called == true {
                    
                    self.onlineView.backgroundColor = .systemGreen
                    self.onlineLabel.text = "オンライン"
                    self.signalLabel.isHidden = true
                    
                } else {
                    self.onlineView.backgroundColor = .systemOrange
                    self.onlineLabel.text = "オフライン"
                    self.signalLabel.isHidden = false
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        callButton.layer.cornerRadius = 55 / 2
        endCallButton.layer.cornerRadius = 55 / 2
        changeButton.layer.cornerRadius = 55 / 2
        currentView.layer.cornerRadius = 15
        onlineView.layer.cornerRadius = 6
    }
    
    func changeConnectionStatusUI(connected:Bool){
        if connected {
            self.callButton.isEnabled = false
            self.endCallButton.isEnabled = true
        }else{
            self.callButton.isEnabled = true
            self.endCallButton.isEnabled = false
        }
    }
    
    func oneButton(_ title: String, message: String, btnOk: String = "OK", handler: ((UIAlertAction?) -> Void)?) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: btnOk, style: .default, handler: handler)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSelectPeerIdDialog(peerIds:[String], toUser: User, handler:@escaping (_ peerId:String)->Void){
        
        if onlineLabel.text == "オフライン" {
            let alert: UIAlertController = UIAlertController(title: "確認", message: "接続中のお相手はいません", preferredStyle: .alert)
            let endCall: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            
            alert.addAction(endCall)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        let alert: UIAlertController = UIAlertController(title: "", message: "接続先を選択してください\n通話を開始するとポイントが使用されます", preferredStyle: .alert)
        
        for peerId in peerIds{
            let peerIdAction = UIAlertAction(title: "\(toUser.username ?? "接続中のお相手はいません")", style: .default, handler: { (alert) in
                guard toUser.uid != nil else { return }
                handler(peerId)
            })
            alert.addAction(peerIdAction)
        }
        let noAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadConnectedPeerIds(peer:SKWPeer, myPeerId:String?, handler:@escaping (_ peerIds:[String]?)->Void){
        peer.listAllPeers({ (peers) -> Void in
            if let connectedPeerIds = peers as? [String]{
                let res = connectedPeerIds.filter({ (connectedPeerId) -> Bool in
                    return connectedPeerId != myPeerId
                })
                handler(res)
            }else{
                handler(nil)
            }
        })
    }
    
    func callPeerIDSelectDialog(peer:SKWPeer, myPeerId:String?, toUser: User, handler:@escaping (_ selectedPeerId:String)->Void){
        self.loadConnectedPeerIds(peer: peer, myPeerId: myPeerId) { (peerIds) in
            if let _peerIds = peerIds, _peerIds.count == 1 {
                self.showSelectPeerIdDialog(peerIds: _peerIds, toUser: toUser, handler: { (peerId) in
                    handler(peerId)
                })
            }else{
                self.oneButton("確認", message: "接続中のお相手はいません", handler: nil)
            }
        }
    }
}

// MARK: setup skyway

extension VideoViewController {
    
    func setup(){
        
        guard let apikey = (UIApplication.shared.delegate as? AppDelegate)?.skywayAPIKey, let domain = (UIApplication.shared.delegate as? AppDelegate)?.skywayDomain else{
            print("Not set apikey or domain")
            return
        }
        
        let option: SKWPeerOption = SKWPeerOption.init();
        option.key = apikey
        option.domain = domain
        
        peer = SKWPeer(options: option)
        
        if let _peer = peer{
            self.setupPeerCallBacks(peer: _peer)
            self.setupStream(peer: _peer)
        }else{
            print("failed to create peer setup")
        }
    }
    
    func setupStream(peer:SKWPeer){
        SKWNavigator.initialize(peer);
        let constraints:SKWMediaConstraints = SKWMediaConstraints()
        self.localStream = SKWNavigator.getUserMedia(constraints)
        self.localStream?.addVideoRenderer(self.currentView as! SKWVideo, track: 0)
    }
    
    func call(targetPeerId:String){
        let option = SKWCallOption()
        
        if let mediaConnection = self.peer?.call(withId: targetPeerId, stream: self.localStream, options: option){
            updateUser(withValue: [POINTS: self.currentUser.points - 3])
            updateToUser(self.toUserId, withValue: [POINTS: self.user.points - 3])
            self.mediaConnection = mediaConnection
            self.setupMediaConnectionCallbacks(mediaConnection: mediaConnection)
        }else{
            print("failed to call :\(targetPeerId)")
        }
    }
}

// MARK: skyway callbacks

extension VideoViewController{
    
    func setupPeerCallBacks(peer:SKWPeer){
        
        // MARK: PEER_EVENT_ERROR
        peer.on(SKWPeerEventEnum.PEER_EVENT_ERROR, callback:{ (obj) -> Void in
            if let error = obj as? SKWPeerError{
                print("Error:\(error)")
            }
        })
        
        // MARK: PEER_EVENT_OPEN
        peer.on(SKWPeerEventEnum.PEER_EVENT_OPEN,callback:{ (obj) -> Void in
            if let peerId = obj as? String{
                DispatchQueue.main.async {
                    //                    self.myPeerIdLabel.text = peerId
                    //                    self.myPeerIdLabel.textColor = UIColor.darkGray
                }
                print("your peerId: \(peerId)")
            }
        })
        
        // MARK: PEER_EVENT_CONNECTION
        peer.on(SKWPeerEventEnum.PEER_EVENT_CALL, callback: { (obj) -> Void in
            if let connection = obj as? SKWMediaConnection{
                self.setupMediaConnectionCallbacks(mediaConnection: connection)
                self.mediaConnection = connection
                connection.answer(self.localStream)
            }
        })
    }
    
    func setupMediaConnectionCallbacks(mediaConnection:SKWMediaConnection){
        
        // MARK: MEDIACONNECTION_EVENT_STREAM
        mediaConnection.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_STREAM, callback: { (obj) -> Void in
            if let msStream = obj as? SKWMediaStream{
                self.remoteStream = msStream
                DispatchQueue.main.async {
                    //                    self.targetPeerIdLabel.text = self.remoteStream?.peerId
                    //                    self.targetPeerIdLabel.textColor = UIColor.darkGray
                    
                    self.remoteStream?.addVideoRenderer(self.toUserView as! SKWVideo, track: 0)
                }
                self.changeConnectionStatusUI(connected: true)
            }
        })
        
        // MARK: MEDIACONNECTION_EVENT_CLOSE
        mediaConnection.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_CLOSE, callback: { (obj) -> Void in
            if let _ = obj as? SKWMediaConnection{
                DispatchQueue.main.async {
                    updateToUser(self.toUserId, withValue: [ISCALL: false])
                    self.remoteStream?.removeVideoRenderer(self.toUserView as! SKWVideo, track: 0)
                    self.remoteStream = nil
                    self.mediaConnection = nil
                }
                self.changeConnectionStatusUI(connected: false)
            }
        })
    }
}
