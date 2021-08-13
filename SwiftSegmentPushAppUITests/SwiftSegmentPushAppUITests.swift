//
//  SwiftSegmentPushAppUITests.swift
//  SwiftSegmentPushAppUITests
//
//  Created by HungNV on 4/13/21.
//  Copyright © 2021 MbaaS. All rights reserved.
//

import XCTest
@testable import NCMB

class SwiftSegmentPushAppUITests: XCTestCase {
    var app: XCUIApplication!
    var tfKey: XCUIElement!
    var tfValue: XCUIElement!
    var tfChannels: XCUIElement!
    var btnSave: XCUIElement!
    var scrollView: XCUIElement!
    var strKey = "favorite"
    var strValue = "music"
    var channels = "apple, orange"
    
    //********** APIキーの設定 **********
    let applicationkey = "YOUR-APPLICATION-KEY"
    let clientkey      = "YOUR-CLIENT-KEY"
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        NCMB.initialize(applicationKey: applicationkey, clientKey: clientkey)
        app = XCUIApplication()
        scrollView = app.scrollViews.element(boundBy: 0)
        tfKey = scrollView.textFields["tfKey"]
        tfValue = scrollView.textFields["tfValue"]
        tfChannels = scrollView.textFields["tfChannels"]
        btnSave = scrollView.buttons["btnSave"]
    }
    
    func testAddKeyForInstallation() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
       
        // Update channels
        tfChannels.tap()
        tfChannels.typeText(channels)
        scrollView.swipeUp()
        
        // Add key
        tfKey.tap()
        tfKey.typeText(strKey)
        
        // Add value
        tfValue.tap()
        tfValue.typeText(strValue)
        
        // Save key + value
        btnSave.tap()
        
        // Check result
        let result = app.scrollViews.containing(NSPredicate(format: "label CONTAINS '\(strKey)'")).element
        XCTAssertTrue(result.waitForExistence(timeout: 10))
    }
    
    func testReceivedPush() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
        sendPush()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.activate()
        let notification = springboard.otherElements["Notification"].descendants(matching: .any)["NotificationShortLookView"]
        XCTAssertEqual(waiterResultWithExpectation(notification), XCTWaiter.Result.completed)
        notification.tap()
        XCTAssertTrue(app.staticTexts["CurrentInstallation"].waitForExistence(timeout: 10))
    }
}

extension SwiftSegmentPushAppUITests {
    private func allowPushNotificationsIfNeeded() {
        addUIInterruptionMonitor(withDescription: "Remote Authorization") { alerts -> Bool in
            if alerts.buttons["Allow"].exists {
                alerts.buttons["Allow"].tap()
                return true
            }
            return false
        }
        app.tap()
    }
    
    private func sendPush() {
        let push: NCMBPush = NCMBPush()
        push.title = "title"
        push.message = "message"
        push.isSendToIOS = true
        push.setImmediateDelivery()
        push.sendInBackground(callback: { result in
            switch result {
            case .success:
                print("登録に成功しました。プッシュID: \(push.objectId!)")
            case let .failure(error):
                print("登録に失敗しました: \(error)")
            }
        })
    }
    
    private func waiterResultWithExpectation(_ element: XCUIElement) -> XCTWaiter.Result {
        let myPredicate = NSPredicate(format: "exists == true")
        let myExpectation = XCTNSPredicateExpectation(predicate: myPredicate, object: element)
        let result = XCTWaiter().wait(for: [myExpectation], timeout: 180)
        return result
    }
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
    
    func tap(button: String) {
        XCUIApplication().keyboards.buttons[button].tap()
    }
}

