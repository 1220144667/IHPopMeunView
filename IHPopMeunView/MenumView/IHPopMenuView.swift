//
//  IHPopMenuView.swift
//  iGenealogy
//
//  Created by hlf on 2022/7/4.
//

import Foundation
import UIKit

class IHPopMenuView: UIView, UITableViewDelegate, UITableViewDataSource {
    //选中回调
    typealias DidSelectedItem = (_ data: IHPopMenuData) -> Void
    private var didSelected: DidSelectedItem?
    private var themClolr: UIColor = .black
    private var allowPoint: CGPoint = .zero
    //数据源
    private var dataList: [IHPopMenuData] = []
    private var triangle: IGTriangleView!
    private var tableView: UITableView!
    
    /// 显示弹窗
    /// - Parameters:
    ///   - view: 父View
    ///   - list: 数据源
    ///   - point: 顶部尖角的位置open func convert(_ rect: CGRect, from view: UIView?) -> CGRect
    ///   - themClor: 主题色
    ///   - closure: 选中cell的回调
    func show(inView view: UIView, source list: [IHPopMenuData], allowPoint point: CGPoint = .zero, themClor: UIColor = .black, closure: @escaping DidSelectedItem) {
        self.dataList = list
        self.themClolr = themClor
        self.didSelected = closure
        self.allowPoint = point
        self.alpha = 0
        self.frame = UIScreen.main.bounds
        view.window?.addSubview(self)
        self.addSubViews()
        //动画
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 1
        }) { finsh in
            if finsh {
                self.tableView.reloadData()
            }
        }
    }
    
    /// 隐藏弹窗
    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    //界面
    func addSubViews() {
        var triangle_y = allowPoint.y
        let list_height = MenuConstant.cellHeight*CGFloat(dataList.count)
        let max_y = triangle_y + list_height + MenuConstant.allowSize.height
        var direction: IGTriangleView.Direction = .top
        let isExceed = (max_y > (MenuConstant.screenHeight - MenuConstant.bottomSafeHeight))
        if isExceed {
            direction = .bottom
            triangle_y = allowPoint.y - MenuConstant.allowSize.height*2
        }
        let triangleView = IGTriangleView(direction: direction, color: themClolr)
        triangleView.frame = CGRect(x: allowPoint.x - MenuConstant.allowSize.width*0.5, y: triangle_y, width: MenuConstant.allowSize.width, height: MenuConstant.allowSize.height - 1)
        self.addSubview(triangleView)
        
        let width = UIScreen.main.bounds.size.width
        let table_x = width - MenuConstant.width - MenuConstant.cellPadding
        var table_y = triangleView.frame.maxY
        if isExceed {
            table_y = triangle_y - list_height
        }
        let listView = UITableView(frame: CGRect(x: table_x, y: table_y, width: MenuConstant.width, height: MenuConstant.cellHeight*CGFloat(dataList.count)))
        listView.backgroundColor = themClolr
        listView.delegate = self
        listView.dataSource = self
        listView.register(IGPopOverMenuCell.self, forCellReuseIdentifier: MenuConstant.cellId)
        listView.tableFooterView = UIView()
        listView.separatorColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        listView.layer.cornerRadius = 4
        listView.layer.masksToBounds = true
        listView.isScrollEnabled = false
        self.addSubview(listView)
        tableView = listView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let currentPoint = touches.first?.location(in: self)
        if !self.tableView.frame.contains(currentPoint ?? CGPoint()) {
            self.dismiss()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuConstant.cellId) as! IGPopOverMenuCell
        let model = dataList[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuConstant.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        if self.didSelected != nil {
            self.didSelected!(model)
            dismiss()
        }
    }
}

class IGPopOverMenuCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: MenuConstant.cellMargin, bottom: 0, right: MenuConstant.cellMargin)
        
        contentView.addSubview(titleLab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.size.width
        let height = self.frame.size.height
        titleLab.frame = CGRect(x: MenuConstant.cellMargin, y: 0, width: width - MenuConstant.cellMargin*2, height: height)
    }
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    func setData(_ data: IHPopMenuData) {
        self.titleLab.text = data.text
    }
}

class IGTriangleView: UIView {
    //设置方向
    enum Direction {
        case top, bottom
    }
    var color: UIColor = .black
    var direction: Direction = .top
    convenience init(direction: Direction = .top, color: UIColor = .black) {
        self.init()
        self.color = color
        self.direction = direction
        self.backgroundColor = .clear
    }
    //绘制曲线
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        color.set()
        let path = UIBezierPath.init()
        let x = 0.0
        let y = 6.0
        let width = rect.size.width
        let height = rect.size.height
        switch direction {
        case .top:
            path.move(to: CGPoint(x: x + width*0.5, y: y))
            path.addLine(to: CGPoint(x: x, y: height))
            path.addLine(to: CGPoint(x: x + width, y: height))
        case .bottom:
            path.move(to: CGPoint(x: x + width*0.5, y: height - y))
            path.addLine(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x + width, y: 0))
        }
        path.close()
        path.fill()
    }
}
