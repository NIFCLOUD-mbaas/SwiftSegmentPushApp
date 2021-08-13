//
//  ViewController.swift
//  SwiftSegmentPushApp
//
//  Created by FJCT on 2019/09/26.
//  Copyright 2019 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController,UITextFieldDelegate{
    
    //viewDidLoad
    var titleLabel: UILabel!
    var key: UILabel!
    var value: UILabel!
    var scroll:UIScrollView!
    let screenSize = UIScreen.main.bounds.size
    
    //getInstalation
    var keyLabel: UILabel!
    var valueField: UITextField!
    var addKeyField: UITextField!
    var addValueField: UITextField!
    var postButton: UIButton!
    
    //postInstallation
    var keyLabelArr: Array<UILabel> = []
    var valueFieldlArr: Array<UITextField> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //スクロールの設定
        scroll = UIScrollView(frame:CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height))
        scroll.layer.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        scroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 1000)
        self.view.addSubview(scroll)
        
        //ページタイトル
        let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 100))
        titleLabel = UILabel(frame: rect)
        titleLabel.text = "CurrentInstallation"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        titleLabel.layer.position = CGPoint(x:self.view.bounds.width/2,y:60)
        scroll.addSubview(titleLabel)
        
        //見出し（key）
        key = UILabel(frame:CGRect(x: 5, y: 70, width: 80, height: 40))
        key.backgroundColor = UIColor.white
        key.textAlignment = NSTextAlignment.center
        key.textColor = UIColor.black
        key.font = UIFont.systemFont(ofSize: 12)
        key.text = "key"
        self.scroll.addSubview(key)
        
        //見出し（value）
        value = UILabel(frame:CGRect(x: 90, y:70, width:self.view.frame.size.width-55, height: 40))
        value.backgroundColor = UIColor.white
        value.textAlignment = NSTextAlignment.center
        value.textColor = UIColor.black
        value.font = UIFont.systemFont(ofSize: 12)
        value.text = "value"
        self.scroll.addSubview(value)
        
        
        //installationの取得と表示
        getInstallation()
        
    }
    
    
    /* Installation の 取 得 ・ 表 示 を す る メ ソ ッ ド */
    func getInstallation() {
        
        //installationの生成
        let installation = NCMBInstallation.currentInstallation
        //ローカルのinstallationをfetchして更新
        installation.fetchInBackground(callback: { result in
            switch result {
                case .success:
                    print("取得成功:\(installation)")
                    DispatchQueue.main.async {
                        self.updateTable(installation)
                    }
                    
                case let .failure(error):
                    print(error)
            }
        })
    }
    
    func updateTable(_ installation: NCMBInstallation) {
        //key（フィールド）の取得
        let keys:Array<String> = Array(installation._fields.keys)

        //value（フィールドの要素）の取得
        for i in (0..<keys.count){
            
            let values:Any = installation[keys[i]]!
            
            //keyを表示するLabelの生成
            self.keyLabel = UILabel(frame:CGRect(x: 5, y: 100 + CGFloat(i)*45, width: 80, height: 40))
            self.keyLabel.backgroundColor = UIColor.blue
            self.keyLabel.textAlignment = NSTextAlignment.center
            self.keyLabel.textColor = UIColor.white
            self.keyLabel.font = UIFont.systemFont(ofSize: 12)
            self.keyLabel.text = keys[i]
            self.scroll.addSubview(self.keyLabel)
            
            
            /*valueの中身を表示するLabel生成*/
            //既存のkeyはLabel,それ以外のkeyとchannelsは編集できるようにtextFieldで表示する
            let checkArray:[String] = ["objectId","appVersion","badge","deviceToken","sdkVersion","timeZone","createDate","updateDate","deviceType","applicationName","acl"]//既存keyかを確認するための配列を用意
            if checkArray.index(of:keys[i]) != nil {
                
                //既存keyのvalueを表示するLabelの作成
                let valueLabel = UILabel(frame:CGRect(x: 90, y:100 + CGFloat(i)*45, width:self.view.frame.size.width-90, height: 40))
                valueLabel.backgroundColor = UIColor.black
                valueLabel.textAlignment = NSTextAlignment.center
                valueLabel.textColor = UIColor.white
                valueLabel.font = UIFont.systemFont(ofSize: 12)
                valueLabel.text = String(describing: values)
                self.scroll.addSubview(valueLabel)
                
            } else {
                
                //独自keyのvalueを表示するtextFieldの作成
                self.valueField = UITextField(frame:CGRect(x: 90, y:100 + CGFloat(i)*45, width:self.view.frame.size.width-90, height: 40))
                self.valueField.borderStyle = UITextField.BorderStyle.roundedRect
                self.valueField.textAlignment = NSTextAlignment.center
                self.valueField.textColor = UIColor.black
                self.valueField.font = UIFont.systemFont(ofSize: 12)
                self.valueField.delegate = self
                self.valueField.clearButtonMode = UITextField.ViewMode.whileEditing
                
                //channelsのｖａｌｕｅは配列で送られてくるため、文字列に変換してからtextに設定する処理をする
                if keys[i] == "channels"{
                    let array = values as? [String]
                    let text = array?.joined(separator:",")
                    self.valueField.text = text
                    self.valueField.accessibilityIdentifier = "tfChannels"
                } else {
                    self.valueField.text = String(describing: values)
                }
                
                //installation更新時に、入力情報を入れる配列を用意してセットしておく
                self.keyLabelArr.append(self.keyLabel)
                self.valueFieldlArr.append(self.valueField)
                self.scroll.addSubview(self.valueField)
                
                
            }
            
            //繰り返し最終回に追加key・valueの挿入と送信ボタンの追加を行う
            if i == (keys.count - 1) {
                
                //追加keyのtextField生成
                self.addKeyField = UITextField(frame:CGRect(x:5,y:100 + CGFloat(i+1)*45, width:80,height:40))
                self.addKeyField.textAlignment = NSTextAlignment.center
                self.addKeyField.borderStyle = UITextField.BorderStyle.roundedRect
                self.addKeyField.textColor = UIColor.black
                self.addKeyField.font = UIFont.systemFont(ofSize: 12)
                self.addKeyField.placeholder = "追加key"
                self.addKeyField.delegate = self
                self.addKeyField.accessibilityIdentifier = "tfKey"
                self.scroll.addSubview(self.addKeyField)
                
                //追加valueのTextField生成
                self.addValueField = UITextField(frame:CGRect(x: 90, y:100 + CGFloat(i+1)*45, width:self.view.frame.size.width-90, height: 40))
                self.addValueField.textAlignment = NSTextAlignment.center
                self.addValueField.borderStyle = UITextField.BorderStyle.roundedRect
                self.addValueField.textColor = UIColor.black
                self.addValueField.font = UIFont.systemFont(ofSize: 12)
                self.addValueField.placeholder = "追加value"
                self.addValueField.delegate = self
                self.addValueField.accessibilityIdentifier = "tfValue"
                self.scroll.addSubview(self.addValueField)
                
                //追加情報を更新するボタン生成
                self.postButton = UIButton(frame: CGRect(x:0,y:0,width:100,height:50))
                self.postButton.backgroundColor = UIColor.black
                self.postButton.setTitle("更新",for:UIControl.State.normal)
                self.postButton.accessibilityIdentifier = "btnSave"
                self.postButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                self.postButton.addTarget(self, action:#selector(postInstallation(sender:)), for: UIControl.Event.touchUpInside)
                self.postButton.layer.position = CGPoint(x:self.view.frame.size.width/2,y:180 + CGFloat(i+1)*45)
                self.scroll.addSubview(self.postButton)
                
            }
            
        }
    }
    
    
    /* 入 力 さ れ た installation を 送 信 す る メ ソ ッ ド */
    @objc func postInstallation(sender: UIButton!) {
        
        let installation = NCMBInstallation.currentInstallation
        
        //もし追加keyのTextFieldに入力があればセット
        let newValues:String = (addValueField.text)!
        let newKey:String = (addKeyField.text)!
        if newValues != "" {
            //セット
            installation[newKey] = newValues
        }
        
        //編集可能なTextFieldの内容をセット
        for i in (0..<keyLabelArr.count){
            
            //channelsに入っている文字列を配列に変換してからセットする
            if keyLabelArr[i].text! == "channels" {
                let channelsText:String = valueFieldlArr[i].text!
                let arrayText:[String] = channelsText.components(separatedBy: ",")
                //セット
                installation["channels"] = arrayText
                
            } else {
                //セット
                installation[String(keyLabelArr[i].text!)] = String(valueFieldlArr[i].text!)
                
            }
        }
        
        //更新する
        installation.saveInBackground(callback: { result in
            switch result {
                case .success:
                    //insitallation更新成功時の処理
                    print("installation更新に成功しました")
                    DispatchQueue.main.async {
                        //viewの再読み込み
                        self.loadView()
                        self.viewDidLoad()
                    }
                case let .failure(error):
                    //installation更新失敗時の処理
                    print("installation更新に失敗しました :\(error)")
                    
                    //アラートを出す
                    DispatchQueue.main.async {
                        let errAlert: UIAlertController = UIAlertController(title: "ERROR!", message: "installation更新に失敗しました", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { action in
                        }
                        errAlert.addAction(okAction)
                        self.present(errAlert, animated: true, completion: nil)
                    }
            }
        })
    }
    
    
    //textFieldを編集直後に呼ばれるdelegateメソッド
    func textFieldDidEditing(textField: UITextField){
    }
    
    
    //textField編集時、returnを押した際に呼ばれるdelegateメソッド
    func textFieldShouldReturn(textField: UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
