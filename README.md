# 【iOS Swift】個別、グループごとに絞り込んでプッシュ通知を送ろう！

![画像1](/readme-img/001.png)

## 概要
* [ニフクラ mobile backend](https://mbaas.nifcloud.com/)の『プッシュ通知』機能を利用したサンプルプロジェクトです！
* 全配信だけでなく、ユーザー(端末)のグループで絞り込んでプッシュ通知を送れます。たとえば、appleとorangeとbananaという重複可能なグループがあったときに、appleに属しているユーザー(端末)にだけプッシュ通知を送ることが出来ます。
* 簡単な操作ですぐに [ニフクラ mobile backend](https://mbaas.nifcloud.com/)の機能を体験いただけます！！

## 目次
* [ニフクラ mobile backendって何？？](#ニフクラmobilebackendって何)
* [プッシュ通知の仕組み](#プッシュ通知の仕組み)
* [作業の手順](#作業の手順)
* [コードの解説](#解説)

## ニフクラmobilebackendって何？？
スマートフォンアプリのバックエンド機能（プッシュ通知・データストア・会員管理・ファイルストア・SNS連携・位置情報検索・スクリプト）が**開発不要**、しかも基本**無料**(注1)で使えるクラウドサービス！

注1：詳しくは[こちら](https://mbaas.nifcloud.com/function.htm)をご覧ください

![画像2](/readme-img/002.png)

## 動作環境

* Mac OS 12.5.1 (Monterey)
* Xcode Version 14.0
* iPhone X (iOS 16)
 * このサンプルアプリは、実機ビルドが必要です

※上記内容で動作確認をしています


## プッシュ通知の仕組み
* ニフクラ mobile backendのプッシュ通知は、iOSが提供している通知サービスを利用しています
 * iOSの通知サービス　__APNs（Apple Push Notification Service）__

 ![画像1](/readme-img/010.png)

* 上図のように、アプリ（Xcode）・サーバー（ニフクラ mobile backend）・通知サービス（APNs）の間でやり取りを行うため、認証が必要になります
 * 認証に必要な鍵や証明書の作成は作業手順の「0.プッシュ通知機能使うための準備」で行います

## 作業の手順
* これから、次のような流れで作業を行います（少し長いので休憩しつつ行うことをオススメします）

1. [プッシュ通知機能を使うための準備](#1プッシュ通知機能を使うための準備)
2. [ニフクラ mobile backendの会員登録とログイン→アプリ作成と設定](#2-ニフクラ-mobile-backendの会員登録とログインアプリ作成と設定)
3. [GitHubからサンプルプロジェクトのダウンロード](#3-githubからサンプルプロジェクトのダウンロード)
4. [Xcodeでアプリを起動](#4-xcodeでアプリを起動)
5. [実機ビルド](#5-実機ビルド)
6. [動作確認](#6動作確認)
7. [プッシュ通知を送りましょう！](#7特定のグループに向けてプッシュ通知を送りましょう)


### 1.プッシュ通知機能を使うための準備
__[【iOS】プッシュ通知の受信に必要な証明書の作り方(開発用)](https://github.com/NIFCloud-mbaas/iOS_Certificate)__
* 上記のドキュメントをご覧の上、必要な証明書類の作成をお願いします
 * 証明書の作成には[Apple Developer Program](https://developer.apple.com/account/)の登録（有料）が必要です

![画像i002](/readme-img/i002.png)


### 2-ニフクラ-mobile-backendの会員登録とログインアプリ作成と設定
* 上記リンクから会員登録（無料）をします。登録ができたらログインをすると下図のように「アプリの新規作成」画面が出るのでアプリを作成します
　
![画像3](/readme-img/003.png)
　
* アプリ作成されると下図のような画面になります
* この２種類のAPIキー（アプリケーションキーとクライアントキー）はXcodeで作成するiOSアプリに[ニフクラ mobile backend](https://mbaas.nifcloud.com/)を紐付けるために使用します
　
![画像4](/readme-img/004.png)
　
* 続けてプッシュ通知の設定を行います
* ここで⑦APNs用証明書(.p12)の設定も行います

![画像5](/readme-img/005.png)
　
　

### 3. [GitHub](https://github.com/NIFCLOUD-mbaas/SwiftSegmentPushApp)からサンプルプロジェクトのダウンロード
　
* 下記リンクをクリックしてプロジェクトをダウンロードをMacにダウンロードします

 * __[SwiftSegmentPushApp](https://github.com/NIFCLOUD-mbaas/SwiftSegmentPushApp/archive/master.zip)__


### 4. Xcodeでアプリを起動
* ダウンロードしたフォルダを開き、「__SwiftSegmentPushdApp.xcworkspace__」をダブルクリックしてXcode開きます(白い方です)

![画像09](/readme-img/009.png)

![画像i25](/readme-img/i025.png)
* 「SwiftSegmentpushApp.xcodeproj」（青い方）ではないので注意してください！

![画像08](/readme-img/008.png)


### 5. 実機ビルド
* 始めて実機ビルドをする場合は、Xcodeにアカウント（AppleID）の登録をします
 * メニューバーの「Xcode」＞「Preferences...」を選択します
 * Accounts画面が開いたら、左下の「＋」をクリックします
 * Apple IDとPasswordを入力して、「Add」をクリックします
 　
 ![図F2.png](/readme-img/b029.png)
　
 * 追加されると、下図のようになります。追加した情報があっていればOKです
 * 確認できたら閉じます。
　
 ![図F3.png](/readme-img/b030.png)
　
* プロジェクトをクリックして、「Build Settings」＞「Code Signing」に②開発用証明書(.cer)と⑤プロビジョニングプロファイルを設定します
　![画像06](/readme-img/006.png)
　
* 「Code Signing Identity」に②開発用証明書(.cer)を設定しますが、「Provisioning Profile」に作成した⑤プロビジョニングプロファイルを設定すれば、「Code Signing Identity」の部分は「Automatic」で構いません
 * __注意__：作成した⑤プロビジョニングプロファイルは一度ダブルクリックをしておかないと、「Provisioning Profile」に設定できません
* Bundle ID を設定します
* 「General」＞「Identity」の「Bundle Identifier」に③AppID を作成したときに入力したBundle IDに書き換えてください
　
![画像i26](/readme-img/i026.png)
　
* 設定は完了です
* lightningケーブルで④端末の登録で登録した、動作確認用iPhoneをMacにつなぎます
* Xcode画面で左上で、接続したiPhoneを選び、実行ボタン（さんかくの再生マーク）をクリックします
* __ビルド時にエラーが発生した場合の対処方法__
 * Xcodeのバージョンが古い場合`import NCMB`にエラーが発生し、上手くSDKが読み込めないことがあります

### 6.動作確認
* インストールしたアプリを起動します
 * **注意！！！** プッシュ通知の許可を求めるアラートが出たら、**必ず許可してください！**
* 起動されたらこの時点でデバイストークンが取得されます
* [ニフクラ mobile backend](https://mbaas.nifcloud.com/)のダッシュボードで「データストア」＞「installation」クラスを確認してみましょう！
　
![画像12](/readme-img/012.png)



### 7.__特定のグループに向けてプッシュ通知を送りましょう！__

#### まずは全配信のプッシュ通知を送る

* [ニフクラ mobile backend](https://mbaas.nifcloud.com/)のダッシュボードで「プッシュ通知」＞「＋新しいプッシュ通知」をクリックします
* プッシュ通知のフォームが開かれます
* 必要な項目を入力して「プッシュ通知を作成する」をクリックします

![画像13](/readme-img/013.png)
　
* 端末を確認しましょう！
* 少し待つとプッシュ通知が届きます！！！

#### 絞り込んで配信

今回は、ユーザーの属性を「apple」、「orange」、「banana」の3つのグループに分けます（グループは重複していても良いとします）。「apple」か「orange」、どちらかのグループに入っているユーザーに対してプッシュ通知を送ってみましょう。

* アプリをまず起動しましょう。初期状態はこのような状態になっており、channelsの編集と新しいフィールドの追加ができます
 * "channels"は、mBaaSに最初から用意されているフィールドで、任意の配列を入れることができます。今回はグループ分けに使っていますが、使い方は自由です

![画像cap1](/readme-img/cap01.png)

* channelsに、"apple,orange"と入れてみましょう
 * channelsは`,`で区切ることで、配列の要素として処理することができます
* 同時に新しいフィールドの追加もしてみましょう。"favorite"というフィールドを作り、中身には"music"と入れてみました。こうすることで、ユーザーに新しい属性を付与することができるようになります！

* 編集が完了したら送信ボタンをタップして下さい

![画像cap2](/readme-img/cap02.png)

* 送信後、viewが自動でリロードされ、追加・更新が行われていることがわかります。追加したフィールドは後から編集することが可能です

![画像cap3](/readme-img/cap03.png)
　

* ダッシュボードから、更新ができていることを確認してみましょう！

![画像cap4](/readme-img/cap04.png)

* 端末側で起動したアプリは一度閉じておきます

##### いよいよグループ配信

* プッシュ通知を作成する際に、「配信端末」を「installationクラスから絞り込み」に設定します
* channelsに「apple」と「orange」が含まれている人だけにプッシュ通知を送る場合は、次のように設定します

![画像cap5](/readme-img/cap05.png)

* 作成をクリックし、少し待つと端末にプッシュ通知が届きます。・・・届きましたか？？

![画像cap6](/readme-img/cap06.png)

* 作成したプッシュ通知の「SearchCondition」を開くとどのように絞りこまれているか確認することができます

![画像7](/readme-img/cap07.png)

* ちなみに、「banana」で絞り込もうとした場合はが配信端末が**なし**になります。試して確認してみましょう！

![画像8](/readme-img/cap08.png)

#### まとめると

* 上のようにinstallationの絞り込み設定をしてプッシュ通知を作成することで、特定のグループや個人に対してプッシュ通知を送ることができます！！
 * 「favorite」が「music」のユーザーにだけ配信や、ある特定のユーザーにだけ配信ということも出来ます。
* 様々な絞り込みを試してみましょう！


## コードの解説
サンプルプロジェクトに実装済みの内容のご紹介

#### SDKのインポートと初期設定
* ニフクラ mobile backend の[ドキュメント（クイックスタート）](https://mbaas.nifcloud.com/doc/current/introduction/quickstart_swift.html)をご用意していますので、ご活用ください

#### deviceToken取得ロジック
 * `AppDelegate.swift`の`didFinishLaunchingWithOptions`メソッドにAPNsに対してデバイストークンの要求するコードを記述し、デバイストークンが取得された後に呼び出される`didRegisterForRemoteNotificationsWithDeviceToken`メソッドを追記をします
 * デバイストークンの要求はiOSのバージョンによってコードが異なります
　
```swift
import UIKit
import NCMB
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    // APIキーの設定
    let applicationkey = "YOUR-APPLICATION-KEY"
    let clientkey      = "YOUR-CLIENT-KEY"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // SDKの初期化
        NCMB.initialize(applicationKey: applicationkey, clientKey: clientkey)
        
        // Register notification
        registerForPushNotifications()
        
        return true
    }
    
    // デバイストークンが取得されたら呼び出されるメソッド
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        let installation = NCMBInstallation()
        installation.setDeviceTokenFromData(data: deviceToken)
        installation.saveInBackground { (error) in
            
        }
    }
}
```

#### installation取得ロジック

* `ViewController.swift`の`getInstallation`メソッド内でinstallationクラスを生成しています
*  `.allkey()`で、フィールドを全件取得できます
* `.objectForKey()`で、指定したフィールドの中身を取り出すことができます

```Swift
 func getInstallation() {
        //installationの生成
        let installation = NCMBInstallation.currentInstallation
        //ローカルのinstallationをfetchして更新
        installation.fetchInBackground(callback: { result in
            switch result {
                case .success:
                    print("取得成功:\(installation)")
                    DispatchQueue.main.async {
                        self.updateTable()
                    }
                    
                case let .failure(error):
                    print(error)
            }
        })
    }
```

#### installation更新ロジック
* `postInstallation`メソッド内で行います。
* `.setObject()`で更新内容とフィールド名を指定し、`.saveInBackgroundWithBlock`で更新します
```Swift 
installation.saveInBackground(callback: { result in
    switch result {
        case .success:
            //insitallation更新成功時の処理
            print("installation更新に成功しました")
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
```
* 更新後は自動でviewのリロードが実行され、更新内容が書き換わります


## 参考
* 同じ内容の【Objective-C】版も作成しておりますのでお待ちください
