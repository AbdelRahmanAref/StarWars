//
//  BaseScreen.swift
//  Delegates-Protocols
//
//  Created by Sean Allen on 5/20/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit
import UserNotifications

let lightNotificationKey = "light"
let darkNotificationKey = "dark"

class BaseScreen: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!

    let light = Notification.Name(lightNotificationKey)
    let dark = Notification.Name(darkNotificationKey)

    //remove observer when the screen is deallocating from memory
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseButton.layer.cornerRadius = chooseButton.frame.size.height/2
        createObserver()

        callLocalNotification()
        callPushNotificationFCM()
    }

    func callPushNotificationFCM(){
        if let url = URL(string: "https://fcm.googleapis.com/fcm/send"){
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-type":"application/json", "Authorization":" key=AAAAp7NXtWk:APA91bH2EwNu0WfPDXfp9w90EP0GAAOOCBNBt00d_5fFCos_JsWIFfD82DJFi3J0RXvWKmqQiSoMvMi2itXSXya4_3Z9EnGeEgW_LYWS9oXszfeS3TWVoyWRgzhiPkYYsdpbhNyVXNon"]
            request.httpMethod = "POST"
            request.httpBody = "{\"to\":\"d_g1msiQmdk:APA91bH0mMYMf8slud_6BO_PPjvc8ZvcgiOLDbV53Mj3JoFGwa948Nax29AObQ9cVgyhldXqPkKh9ffeZAVAbNEdNlanli3vq_UeiLQcQGHNZWhU_wq7_ep_qvjXa61a2rPJa2lOdmTy\",\"notification\":{\"title\":\"This is from HTTP!\"}}".data(using: .utf8)

            URLSession.shared.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
                if  error != nil {
                    print("hamada ***********************\n")
                    print(error!)
                    print("hamada ***********************\n")
                }
                print(String(data: data!, encoding: .utf8)!)
            }).resume()
        }
    }
    func callLocalNotification(){
        //Local Notification setup
        //1. Ask for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound
        ]) { (granted, error) in

        }
        //2. create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Hey I am notification"
        content.body = "Look at me"

        //3. create the notification trigger
        let date = Date().addingTimeInterval(15)

        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)

        //4. create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        //5. Register the request
        center.add(request) { (error) in
            //check error parameter and handle error

        }
    }

    func createObserver() {
        //light
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateCharacterImage(notification:)), name: light, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateBGColor(notification:)), name: light, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateNameLabel(notification:)), name: light, object: nil)

        //dark
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateCharacterImage(notification:)), name: dark, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateCharacterImage(notification:)), name: dark, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateCharacterImage(notification:)), name: dark, object: nil)
    }

    func updateBGColor(notification: NSNotification){
        let isLight = notification.name == light
        let color = isLight ? UIColor.cyan : UIColor.red
        view.backgroundColor = color
    }

    func updateNameLabel(notification: NSNotification){
        let isLight = notification.name == light
        let image = isLight ? UIImage(named: "luke")! : UIImage(named: "vader")!
        mainImageView.image = image
    }

    func updateCharacterImage(notification: NSNotification){
        let isLight = notification.name == light
        let name = isLight ? "Mai 3arosa" : "Haroon shaba7"
        nameLabel.text = name
    }

    @IBAction func chooseButtonTapped(_ sender: UIButton) {
        let selectionVC = storyboard?.instantiateViewController(withIdentifier: "SelectionScreen") as! SelectionScreen
//        selectionVC.selectionDelegate = self
        present(selectionVC, animated: true, completion: nil)
    }
}


//extension BaseScreen: SideSelectionDelegate {
//    
//    func didTapChoice(image: UIImage, name: String, color: UIColor) {
//        mainImageView.image = image
//        nameLabel.text = name
//        view.backgroundColor = color
//    }
//    
//}
