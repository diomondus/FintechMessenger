//
//  PersonalChatViewController.swift
//  TinkoffChat
//
//  Created by Дмитрий Бутилов on 11.04.17.
//  Copyright © 2017 Дмитрий Бутилов. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PeerManagerDelegate, UITextViewDelegate {
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupGestureRecognizer() {
        let tapToDismissKeyboards = UITapGestureRecognizer(target: self, action: #selector(ConversationViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboards)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomSpaceConstraint.constant = keyboardSize.height
        }
    }
    
    
    @IBOutlet weak var messageTexView: UITextView!
    @IBOutlet weak var messagesListTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomPartHeightConstraint: NSLayoutConstraint!
    
    fileprivate let incomingMessageCellId = "incomingMessage"
    fileprivate let outcomingMessageCellId = "outcomingMessage"
    
    var peerManager: PeerManager? {
        didSet {
            oldValue?.removeDelegate(self)
            peerManager?.addDelegate(self)
        }
    }
    
    @IBAction fileprivate func sendMessage(_ sender: UIButton) {
        if let peerManager = peerManager {
            peerManager.sendMessage(text: messageTexView.text)
            messageTexView.text = ""
            sendButton.isEnabled = false
            updateTextViewHeight(for: messageTexView.attributedText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesListTableView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        messagesListTableView.dataSource = self
        messagesListTableView.delegate = self
        messagesListTableView.estimatedRowHeight = 44
        messagesListTableView.rowHeight = UITableViewAutomaticDimension
        messagesListTableView.tableFooterView = UIView()
        subscribeForKeyboardNotification()
        setupGestureRecognizer()
        
        sendButton.isEnabled = false
        
        if let peerManager = peerManager {
            navigationItem.title = peerManager.chat.name
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesListTableView.reloadData()
    }
    
    deinit {
        unsubscribeFromKeyboardNotification()
        peerManager?.removeDelegate(self)
    }
    
    fileprivate func setup() {

    }
    
    
    func updateTextViewHeight(for text: NSAttributedString) {
        let size = text.boundingRect(with: CGSize(width: messageTexView.textContainer.size.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let totalHeight = textViewTopSpaceConstraint.constant + textViewBottomSpaceConstraint.constant + size.height + messageTexView.textContainerInset.top + messageTexView.textContainerInset.bottom
        var resultingHeight = totalHeight < ConversationViewController.maxBottomPartHeight ? totalHeight : ConversationViewController.maxBottomPartHeight
        resultingHeight = resultingHeight > ConversationViewController.minBottomPartHeight ? resultingHeight : ConversationViewController.minBottomPartHeight
        let heightDiff = fabs(bottomPartHeightConstraint.constant - resultingHeight)
        guard let font = messageTexView.font else { return }
        if heightDiff > font.lineHeight - ConversationViewController.lineHeightDeviation {
            bottomPartHeightConstraint.constant = resultingHeight
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    func subscribeForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return calculateNumberOfRows()
    }
    
    
    func calculateNumberOfRows() -> Int {
        
        return peerManager!.chat.messages.count
    }
    
    static let maxBottomPartHeight: CGFloat = 120
    static let minBottomPartHeight: CGFloat = 42
    static let lineHeightDeviation: CGFloat = 2
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            sendButton.isEnabled = text != ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let futureText = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
            futureText.replaceCharacters(in: range, with: text)
            updateTextViewHeight(for: futureText)
        }
        
        return true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomSpaceConstraint.constant = 0
    }
    
    func updateMessageList() {
        self.messagesListTableView.reloadData()
    }
    
    func handleUserStatusChange() {
        if let state = peerManager?.chat.online {
            sendButton.isEnabled = state
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messages = peerManager!.chat.messages
        let messageIndex = messages.count - indexPath.row - 1
        let message = messages[messageIndex]
        let cellId = (message.isOutcoming) ? outcomingMessageCellId : incomingMessageCellId
        let cell = messagesListTableView.dequeueReusableCell(withIdentifier:cellId, for:indexPath) as! MessageCell
        cell.updateCellForMessage(message)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        return cell
    }

 }


