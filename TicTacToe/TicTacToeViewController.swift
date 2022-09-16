//
//  TicTacToeViewController.swift
//  TicTacToe
//
//  Created by 장민주 on 2022/09/08.
//

import UIKit
import AVFoundation

class TicTacToeViewController: UIViewController {
    
    private var player: AVAudioPlayer?
    
    enum Turn {
        case FirstPlayer
        case SecondPlayer
    }

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    @IBOutlet var buttons: [UIButton]!
    
    var userList = ["1P", "2P"]
    
    var firstTurn = Turn.FirstPlayer
    var currentTurn = Turn.FirstPlayer
    
    var FIRSTPLAYER = "X"
    var SECONDPLAYER = "O"
    var board = [UIButton]()
    
    var firstScore = 0
    var secondScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInit()
        initBoard()
        userLabel.font = UIFont(name: "NanumBarunpen", size: 35)
        turnLabel.layer.borderColor = UIColor.white.cgColor
        turnLabel.layer.borderWidth = 2.0
        turnLabel.layer.cornerRadius = 8
        turnLabel.layer.backgroundColor = UIColor.white.cgColor
        turnLabel.layer.masksToBounds = false
        turnLabel.layer.shadowColor = UIColor.darkGray.cgColor
        turnLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        turnLabel.layer.shadowRadius = 2
        turnLabel.layer.shadowOpacity = 0.7
        
        for (_, button) in buttons.enumerated() {
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 2.0
            button.layer.cornerRadius = 10
            button.layer.backgroundColor = UIColor.white.cgColor
            button.layer.masksToBounds = false
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.layer.shadowRadius = 2
            button.layer.shadowOpacity = 0.7
        }
    }
    
    func playSound() {
        let soundName = "sound"
        // forResource: 파일 이름(확장자 제외) , withExtension: 확장자(mp3, wav 등) 입력
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.numberOfLoops = 0
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func userInit() {
        let alert = UIAlertController(title: "이름을 입력하세요.", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (field) in
            field.becomeFirstResponder()
            field.placeholder = "First Player"
            field.returnKeyType = .next
            field.textAlignment = .center
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Second Player"
            field.returnKeyType = .next
            field.textAlignment = .center
        }
        
        let ok = UIAlertAction(title: "확인", style: .default, handler: {
            action in
            guard let fields = alert.textFields, fields.count <= 2 else {
                return
            }
            let firstField = fields[0]
            let secondField = fields[1]
            guard let firstName = firstField.text,
                  let secondName = secondField.text else {
                return
            }
            
            if (firstName.isEmpty) {
                self.userList[0] = "1P"
            } else {
                self.userList[0] = firstName
            }
            
            if (secondName.isEmpty) {
                self.userList[1] = "2P"
            } else {
                self.userList[1] = secondName
            }
            
            self.userLabel.text = self.userList[0]
        })
        
        let cancle = UIAlertAction(title: "취소", style: .default, handler: {
            action in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(ok)
        alert.addAction(cancle)
        
        present(alert, animated: true, completion: nil)
    }
    
    func initBoard() {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender)

        if checkForVictory(FIRSTPLAYER) {
            firstScore += 1
            resultAlert(title: userList[0] + " Win")
        }
        
        if checkForVictory(SECONDPLAYER) {
            secondScore += 1
            resultAlert(title: userList[1] + " Win")
        }
        
        if (fullBoard()) {
            resultAlert(title: "Draw")
        }
    }
    
    func checkForVictory(_ s : String) -> Bool {
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s) {
            return true
        }
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s) {
            return true
        }
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s) {
            return true
        }
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s) {
            return true
        }
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s) {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s) {
            return true
        }
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s) {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s) {
            return true
        }
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    func resultAlert(title: String) {
        let message = "\n" + userList[0] + " : " + String(firstScore) + "점" + "\n\n" + userList[1] + " : " + String(secondScore) + "점"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if(firstTurn == Turn.FirstPlayer) {
            userLabel.text = userList[1]
            firstTurn = Turn.SecondPlayer
            turnLabel.text = SECONDPLAYER
            self.turnLabel.textColor = UIColor(named: "babyPinkColor")
        } else if(firstTurn == Turn.SecondPlayer) {
            userLabel.text = userList[0]
            firstTurn = Turn.FirstPlayer
            turnLabel.text = FIRSTPLAYER
            self.turnLabel.textColor = UIColor(named: "babyBlueColor")
        }
        currentTurn = firstTurn
    }
    
    func fullBoard() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }
    
    func addToBoard(_ sender: UIButton) {
        playSound()
        if(sender.title(for: .normal) == nil) {
            if (currentTurn == Turn.FirstPlayer) {
                sender.setTitle(FIRSTPLAYER, for: .normal)
                turnLabel.text = SECONDPLAYER
                userLabel.text = userList[1]
                currentTurn = Turn.SecondPlayer
                sender.setTitleColor(UIColor(named: "babyBlueColor"), for: .normal)
                self.turnLabel.textColor = UIColor(named: "babyPinkColor")
            } else if (currentTurn == Turn.SecondPlayer) {
                sender.setTitle(SECONDPLAYER, for: .normal)
                turnLabel.text = FIRSTPLAYER
                userLabel.text = userList[0]
                currentTurn = Turn.FirstPlayer
                sender.setTitleColor(UIColor(named: "babyPinkColor"), for: .normal)
                self.turnLabel.textColor = UIColor(named: "babyBlueColor")
            }
            sender.isEnabled = false
        }
    }
}
