//
//  ViewController.swift
//  IHPopMeunView
//
//  Created by hlf on 2022/7/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExampleCell.self, forCellReuseIdentifier: "ExampleCellId")
        tableView.tableFooterView = UIView()
        return tableView
    }()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCellId") as! ExampleCell
        cell.titleLab.text = "示例\(indexPath.row)"
        cell.moreBtn.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    @objc func buttonEvent(_ sender: UIButton) {
        //编辑
        let editItem = IHPopMenuData(action: "edit", text: "编辑")
        //删除
        let deleteItem = IHPopMenuData(action: "delete", text: "删除")
        //其他
        let otherItem = IHPopMenuData(action: "delete", text: "其它")
        let enumList = [editItem, deleteItem, otherItem]
        let popView = IHPopMenuView()
        let rect = sender.convert(sender.bounds, to: self.view)
        let point = CGPoint(x: rect.origin.x + rect.size.width*0.5, y: rect.origin.y + rect.size.height*0.5 + 4)
        popView.show(inView: view, source: enumList, allowPoint: point, themClor: .black) { [weak self] data in
            guard let self = self else { return }
            switch data.action {
            case "edit":
                self.editButtonClick()
            case "delete":
                self.deleteButtonClick()
            default:
                print("其他选项")
            }
        }
    }
    
    func editButtonClick() {
        print("点击了编辑")
    }
    
    func deleteButtonClick() {
        print("点击了删除")
    }
}

class ExampleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLab)
        contentView.addSubview(moreBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.size.width
        let height = self.frame.size.height
        titleLab.frame = CGRect(x: 18, y: 0, width: 120, height: height)
        moreBtn.frame = CGRect(x: width - height, y: 0, width: height, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var moreBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deeds_more_icon"), for: .normal)
        return button
    }()
}

