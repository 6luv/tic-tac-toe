import UIKit
import AVFoundation

enum Turn {
    case User
    case Computer
}

var check = true
var count = 0

class AiTicTacToeViewController: UIViewController {
    
    private var player: AVAudioPlayer?

    var moves: Dictionary <Int, String> = [0:"E", 1:"E", 2:"E", 3:"E", 4:"E", 5:"E", 6:"E", 7:"E", 8:"E"]
    
    private var isUserTurn = true
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    var userList = ["User", "Tac Bot"]
    
    var firstTurn = Turn.User
    var currentTurn = Turn.User
    var userScore = 0
    var computerScore = 0
    
    var COMPUTER = "O"
    var USER = "X"
    var board = [UIButton]()
    
    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        userInit()
        initBoard()
        turnLabel.textColor = UIColor(named: "babyPinkColor")
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
        
        for (i, button) in buttons.enumerated() {
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 2.0
            button.layer.cornerRadius = 10
            button.layer.backgroundColor = UIColor.white.cgColor
            button.layer.masksToBounds = false
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.layer.shadowRadius = 2
            button.layer.shadowOpacity = 0.7
            button.tag = i
        }
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
            field.placeholder = "User Name"
            field.returnKeyType = .next
            field.textAlignment = .center
        }
  
        let ok = UIAlertAction(title: "확인", style: .default, handler: {
            action in
            guard let fields = alert.textFields, fields.count == 1 else {
                return
            }
            let nameField = fields[0]
            guard let userName = nameField.text else {
                return
            }
            
            if (userName.isEmpty) {
                self.userList[0] = "1P"
            } else {
                self.userList[0] = userName
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
    
    @IBAction func boardTapAction(_ sender: UIButton) {
        if (currentTurn == Turn.User) {
            addToBoard(sender)
        }

        if (check == true) {
            aiAddToBoard()
        }
        victory()
    }
    
    func victory() {
        if checkForVictory(USER) {
            userScore += 1
            resultAlert(title: userList[0] + " Win")
        }
               
        if checkForVictory(COMPUTER) {
            computerScore += 1
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
        
        let message = "\n" + userList[0] + " : " + String(userScore) + "점" + "\n\n" + userList[1] + " : " + String(computerScore) + "점"
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
        for (i, _) in moves.enumerated() {
            moves.updateValue("E", forKey: i)
        }
        count = 0
        if(firstTurn == Turn.Computer) {
            userLabel.text = userList[0]
            firstTurn = Turn.User
            turnLabel.text = USER
            self.turnLabel.textColor = UIColor(named: "babyPinkColor")
        } else if(firstTurn == Turn.User) {
            userLabel.text = userList[1]
            firstTurn = Turn.Computer
            turnLabel.text = COMPUTER
            self.turnLabel.textColor = UIColor(named: "babyBlueColor")
            aiAddToBoard()
            check = true
        }
        currentTurn = firstTurn
    }
    
    func fullBoard() -> Bool {
        if (count < 9) {
            return false
        }
        check = false
        return true
    }
    
    func isSquareOccupied(_ sender: Int) -> Bool {
        if (moves[sender] != "E") {
            return true
        } else {
            return false
        }
    }
    
    func determineComputerMovePosition() -> Int {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMove = moves.compactMap {$0}.filter { (key: Int, value: String) in
            if (moves[key] == "O") {
                return true
            }
            return false
        }
            
        let computerPosition = Set(computerMove.map() { (key: Int, value: String) in
            return key
        })

        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(winPositions.first!)
                if isAvaiable {
                    return winPositions.first!
                }
            }
        }
        
        let userMove = moves.compactMap {$0}.filter { (key: Int, value: String) in
            if (moves[key] == "X") {
                return true
            }
            return false
        }
            
        let userPosition = Set(userMove.map() { (key: Int, value: String) in
            return key
        })

        for pattern in winPatterns {
            let winPositions = pattern.subtracting(userPosition)
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(winPositions.first!)
                if isAvaiable {
                    return winPositions.first!
                }
            }
        }
        
        let centerPosition = 4
        if !isSquareOccupied(centerPosition) {
            return centerPosition
        }
        
        var movePosition = Int.random(in: 0..<9)
        
        while (isSquareOccupied(movePosition)) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func aiAddToBoard() {
        let computerPosition = determineComputerMovePosition()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [self] in
            for (i, button) in buttons.enumerated() {
                if (i == computerPosition) {
                    playSound()
                    moves.updateValue("O", forKey: computerPosition)
                    button.setTitle("O", for: .normal)
                    currentTurn = Turn.User
                    turnLabel.text = USER
                    userLabel.text = userList[0]
                    button.setTitleColor(UIColor(named: "babyBlueColor"), for: .normal)
                    turnLabel.textColor = UIColor(named: "babyPinkColor")
                    button.isEnabled = false
                    count += 1
                }
            }
            victory()
        }
    }
    
    func addToBoard(_ sender: UIButton) {
        playSound()
        if(sender.title(for: .normal) == nil) {
            if (currentTurn == Turn.User) {
                sender.setTitle(USER, for: .normal)
                currentTurn = Turn.Computer
                turnLabel.text = COMPUTER
                userLabel.text = userList[1]
                sender.setTitleColor(UIColor(named: "babyPinkColor"), for: .normal)
                self.turnLabel.textColor = UIColor(named: "babyBlueColor")
                moves.updateValue("X", forKey: sender.tag)
                count += 1
            }
            
            if (checkForVictory(USER) || fullBoard()) {
                check = false
            } else {
                check = true
            }
            
            sender.isEnabled = false
        }
    }
}
