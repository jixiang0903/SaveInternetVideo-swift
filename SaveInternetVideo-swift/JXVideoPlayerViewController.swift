//
//  JXVideoPlayerViewController.swift
//  SaveInternetVideo-swift
//
//  Created by jixiang on 2021/1/8.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import Moya

class JXVideoPlayerViewController: AVPlayerViewController {
    var videoUrl : URL!
    //初始化请求的provider
    let pro = UIProgressView()
    var cancelledData : Data?//用于停止下载时,保存已下载的部分
    var downloadRequest:DownloadRequest!//下载请求对象
    var destination:Alamofire.DownloadRequest.Destination!//下载文件的保存路径
    
    var playItem: AVPlayerItem! {
        didSet {
            let player = AVPlayer(playerItem: playItem)
            self.player = player
            self.player?.play()
        }
    }
    
    convenience init(url: URL) {
        self.init()
        let videoStr = url
        print(videoStr)
        self.videoUrl = videoStr
        print(self.videoUrl!)
        let player = AVPlayer(playerItem: AVPlayerItem(url:url))
        self.player = player
        self.player?.play()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(longPress:)))
        longPress.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPress)
    }
         
    func loadData() {
        let session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let downloadTask = session.downloadTask(with: self.videoUrl!)
        downloadTask.resume()
        
        }

    @objc func longPressAction(longPress: UILongPressGestureRecognizer) {
        guard longPress.state == .began else {
            return
        }
        let alertV = UIAlertController()
        let saveAction = UIAlertAction(title: "保存视频", style: .default) { (alertV) in
            self.loadData()
        }
        //取消保存不作处理
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertV.addAction(saveAction)
        alertV.addAction(cancelAction)
        self.present(alertV, animated: true, completion: nil)
    }
    
}

extension JXVideoPlayerViewController: URLSessionDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //1.拿到cache文件夹的路径
        let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        //2,拿到cache文件夹和文件名
        let file : String = (cache?.appending(downloadTask.response?.suggestedFilename ?? ""))!
        do {
            try FileManager.default.moveItem(at: location, to: URL.init(fileURLWithPath: file))
        } catch let error {
            print(error)
        }
        //3，保存视频到相册
        let videoCompatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(file)
        //判断是否可以保存
        if videoCompatible {
            UISaveVideoAtPathToSavedPhotosAlbum(file, self, #selector(didFinishSavingVideo(videoPath:error:contextInfo:)), nil)
        } else {
            SVProgressHUD.showInfo(withStatus: "该视频无法保存至相册")
        }
    }
    
    @objc func didFinishSavingVideo(videoPath: String, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if error != nil{
            SVProgressHUD.showError(withStatus: "保存失败")
        }else{
            SVProgressHUD.showSuccess(withStatus: "保存成功，请到相册中查看")
        }
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
       {
           if error != nil  {
//               callBackClosure!(nil , 0, error)
           }
       }


    //下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let  currentBytes :CGFloat = CGFloat(totalBytesWritten)
        let  allTotalBytes :CGFloat = CGFloat(totalBytesExpectedToWrite)
        //获取进度
        let proValue :Float = (Float)(currentBytes/allTotalBytes)
        print("----下载进度:------\(proValue*100)%");
        weak var weakSelf : JXVideoPlayerViewController? = self
        DispatchQueue.main.async
            {
            //用于进度展示
            SVProgressHUD.showProgress(proValue, status: "正在保存到本地")
        }
    }
        
    //下载偏移
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //主要用于暂停续传
    }
}

