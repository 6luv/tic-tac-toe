//
//  ViewController.swift
//  TicTacToe
//
//  Created by 장민주 on 2022/09/08.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (_, label) in labels.enumerated() {
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 2.0
            label.layer.cornerRadius = 15
            label.layer.backgroundColor = UIColor.white.cgColor
            label.layer.masksToBounds = false
            label.layer.shadowColor = UIColor.darkGray.cgColor
            label.layer.shadowOffset = CGSize(width: 2, height: 2)
            label.layer.shadowRadius = 3
            label.layer.shadowOpacity = 0.7
            }
        
        for (_, button) in buttons.enumerated() {
            button.titleLabel?.font = UIFont(name: "NanumBarunpen-Bold", size: 35)
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 2.0
            button.layer.cornerRadius = 15
            button.layer.backgroundColor = UIColor.white.cgColor
            button.layer.masksToBounds = false
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.layer.shadowRadius = 3
            button.layer.shadowOpacity = 0.7
        }
    }
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func AiStartButton(_ sender: Any) {
        if let AitttController = self.storyboard?.instantiateViewController(withIdentifier: "AiTicTacToeViewController") {
            self.navigationController?.pushViewController(AitttController, animated: true)
        }
    }
    
    @IBAction func StartButton(_ sender: Any) {
        if let tttController = self.storyboard?.instantiateViewController(withIdentifier: "TicTacToeViewController") {
            self.navigationController?.pushViewController(tttController, animated: true)
        }
    }
}

