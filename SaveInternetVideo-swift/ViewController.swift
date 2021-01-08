//
//  ViewController.swift
//  SaveInternetVideo-swift
//
//  Created by jixiang on 2021/1/8.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: cell 标识符
    fileprivate let identifier = "GGgirlsID"
    var ctrNames:NSMutableArray?
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + 44, width: self.view.frame.size.width, height: self.view.frame.size.height)
       tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
       tableView.backgroundColor = .white
//       tableView.register(GGirlsCell.self, forCellReuseIdentifier: self.identifier)
        tableView.register(UINib(nibName: "GGirlsCell", bundle: nil), forCellReuseIdentifier: identifier)
       if #available(iOS 11.0, *) {
           tableView.contentInsetAdjustmentBehavior = .never
       }
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        //初始化数据源
        loadData()
    }
}
extension ViewController{
    //初始化数据源
    func loadData(){
        ctrNames = ["1A","2B","3C","4D","5E","6F","7G","8H","9I","10J"]
        self.tableView .reloadData()
    }
    //MARK: 数据源
    //cell个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.ctrNames?.count ?? 0
    }
    
    //tablViewCell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 100.0;
    }
    
    /*
     //头部高度
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 0.01
     }
     
     //底部高度
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     return 0.01
     }
     */
    
    //cell赋值
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Nib注册, 调用的时候会调用自定义cell中的  awakeFromNib  方法
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! GGirlsCell
        cell.girlImage?.image = UIImage(named: "\(indexPath.row).jpg")
        cell.titleLabel?.text = ctrNames![indexPath.row] as? String
        return cell
    }
    
    //cell点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        print(ctrNames![indexPath.row])
        //URL编码
        let encodingStr = ("http://dscloud-digitalmaint-iyou-test-1.oss-cn-beijing.aliyuncs.com/data/20210108111517530.mp4").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let videoUrl = URL(string:encodingStr!) else { return SVProgressHUD.showInfo(withStatus: "视频链接失效！")}
        self.navigationController?.present(JXVideoPlayerViewController(url: videoUrl), animated: true, completion: nil)
    }
    
    //cell填满屏幕
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to:#selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
    //允许编辑cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //右滑触发删除按钮
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.init(rawValue: 1)!
    }
    
    //点击删除cell时触发
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("indexPath.row = editingStyle第\(indexPath.row)行")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
