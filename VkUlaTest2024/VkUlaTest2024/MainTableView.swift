import Foundation
import UIKit

class MainTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var data: [Elements] = []
    private let cellIdentifier = "MainTableViewCell"

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .black
        self.separatorColor = .darkGray
        
        self.register(MainTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateWithData(_ elements: [Elements]) {
            self.data = elements
            self.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MainTableViewCell else {
//            return UITableViewCell()
//        }
        let cell = MainTableViewCell(style: .default, reuseIdentifier: nil)
        let element = data[indexPath.row]
        cell.nameLabel.text = element.name
        cell.infoLabel.text = element.description
        cell.cellUrlStr = element.link
        if let iconUrl = URL(string: element.icon_url) {
                cell.setImage(from: iconUrl)
            }
        let arrowImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let arrowImageView = UIImageView(image: arrowImage)
        arrowImageView.tintColor = .gray
        cell.accessoryView = arrowImageView
        cell.separatorInset = UIEdgeInsets(top: 0, left: 68, bottom: 0, right: 0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(data[indexPath.row].name)
        tableView.deselectRow(at: indexPath, animated: true)
        guard let webURL = URL(string: data[indexPath.row].link) else {
            print("invalid web app url")
            return
        }
        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

class MainTableViewCell: UITableViewCell {
     lazy var imageIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var cellUrlStr:String = "https://example.com"
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        let text = NSAttributedString(string: "неизвестно", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        label.textColor = .white
        label.attributedText = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    func setImage(from url: URL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data), error == nil else {
                    print("Ошибка загрузки изображения")
                    return
                }

                DispatchQueue.main.async {
                    self?.imageIcon.image = image
                }
            }.resume()
        }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        layer.borderWidth = 0
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            imageIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageIcon.widthAnchor.constraint(equalToConstant: 60),
            imageIcon.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leftAnchor.constraint(equalTo: imageIcon.rightAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            infoLabel.leftAnchor.constraint(equalTo: imageIcon.rightAnchor, constant: 8),
            infoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
        ])
        
    }
    
    
}
