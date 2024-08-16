import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dataArr = ["跳转第一个模块", "跳转第二个模块"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置视图背景颜色
        view.backgroundColor = .white
        
        // 将 tableView 添加到视图中
        view.addSubview(tableView)
        
        // 设置 tableView 的 delegate 和 dataSource
        tableView.delegate = self
        tableView.dataSource = self
    }

    // 懒加载 tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - UITableViewDataSource

    // 返回表格的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count // 示例：返回10行
    }

    // 配置每一行的单元格内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row] // 示例：设置行文本
        return cell
    }

    // MARK: - UITableViewDelegate
    
    // 处理行选择事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected row \(indexPath.row + 1)")
        if indexPath.row == 0 {
            let vc = ReactController.createInstance(url: "", path: "main.jsbundle", type: .InApp, moduleName: "MetroBundlersDemo")
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ReactController.createInstance(url: "http://172.16.3.30:3000/api/getApp1Bundle", path: "sub.jsbundle", type: .NetWork, moduleName: "App1")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
