//
//  ViewController.swift
//  VkUlaTest2024
//
//  Created by Артемий on 26.03.2024.
//

import UIKit

class ViewController: UIViewController {
    private lazy var upperLabel:UILabel = {
        let label = UILabel()
        let text = NSAttributedString(string: "Сервисы", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        label.textColor = .white
        label.textAlignment = .center
        label.attributedText = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var mainTableView:MainTableView = {
        let mainTableView = MainTableView()
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        return mainTableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(upperLabel)
        view.addSubview(mainTableView)
        NSLayoutConstraint.activate([
            upperLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            upperLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            upperLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            upperLabel.heightAnchor.constraint(equalToConstant: 30),
            
            mainTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mainTableView.topAnchor.constraint(equalTo: upperLabel.bottomAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        getInfoAndUpdateLayout()
        // Do any additional setup after loading the view.
    }
    private func updateUI(status: Int, elements: [Elements]){
        mainTableView.updateWithData(elements)
    }
    private func getInfoAndUpdateLayout(){
        let urlStr = "https://publicstorage.hb.bizmrg.com/sirius/result.json"
        guard let url = URL(string: urlStr) else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        print("Error: Invalid response")
                        return
                    }
                    guard let data = data else {
                        print("Error: No data")
                        return
                    }
                    do {
                        let decodedData = try JSONDecoder().decode(ForecastResponse.self, from: data)
                        DispatchQueue.main.async {
                            self?.updateUI(status: decodedData.status, elements: decodedData.body.services)
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }.resume()
    }
    
}
struct ForecastResponse: Decodable{
    let body: Services
    let status: Int
}
struct Services: Decodable{
    let services: [Elements]
}
struct Elements: Decodable{
    let name: String
    let description:String
    let link: String
    let icon_url: String
}


