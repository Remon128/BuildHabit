//
//  AddReminderViewController.swift
//  BuildHabit
//
//  Created by Admin on 6/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import AlamofireImage

struct ImgureResponse:Decodable{
    let data:Content
    let success:Bool
    let status:Int
}

struct Content:Decodable{
 //   let images:[image]?
      let items:[Item]
}

struct Item:Decodable{
    let link:String
}


class AddReminderViewController: UIViewController,UITextFieldDelegate {

    var reminder: Reminder?
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var LinkFetch:String?
    var habitSelected:String!
    var selection: Bool?
    
    @IBOutlet var habitButtons: [UIButton]!
    
    enum Habits:String{
        case workouts = "Workouts"
        case socializing = "Socializing"
        case read = "Reading"
        case meditate = "Meditating"
        
    }
    
    @IBAction func handleSelection(_ sender: UIButton) {
        habitButtons.forEach { (button) in
            UIView.animate(withDuration: 0.1, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @IBAction func habitTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let habit = Habits(rawValue: title) else {
            return
        }
        
        switch habit{
        case .meditate:
            print(" meditate ")
            self.habitSelected = "meditate"
            habitButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
            selection = true
            checkName()
        case .read:
            print(" read ")
            self.habitSelected = "reading"
            habitButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
            selection = true
            checkName()
        case .workouts:
            print(" workout ")
            self.habitSelected = "workout_motivation"
            habitButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
            selection = true
            checkName()
        case .socializing:
            print(" socialize ")
            self.habitSelected = "social_life"
            habitButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
            selection = true
            checkName()
        default:
            print("Nothing")
        }
        
        let url = URL (string:"https://api.imgur.com/3/gallery/t/\(habitSelected!)/?client_id=ce8adac7e9067b6")
        print (url , " shoooo ")
        Alamofire.request(url!).responseJSON { (response) in
            let result = response.data!
            do{
                let Data = try JSONDecoder().decode(ImgureResponse.self, from: response.data!)
                var number = arc4random_uniform(UInt32(Data.data.items.count ))
                //   print(Data.data.items[0].link, " Linkkk  ")
                print(Data.data.items.count ,  "   Count " )
                self.LinkFetch = Data.data.items[Int(number )].link
                
            }catch{
                print("error feha ")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reminderTextField.delegate = self
        timePicker.minimumDate = NSDate() as Date
        timePicker.locale = NSLocale.current
        //set current date/time as minimum date for the picker
        saveButton.isEnabled = false
        selection = false
        // Do any additional setup after loading the view.
        
    }
    
    func checkName(){
        //Disable of any resources if text field is empty
        
        let text = reminderTextField.text ?? ""
        if(selection!){
            saveButton.isEnabled = !text.isEmpty
        }
        else{
            saveButton.isEnabled = false
        }
        print (selection , " selection ")
    }
    
    func checkDate(){
        //Disbale save button if the date in the date picker
        //has passed
        if NSDate().earlierDate(timePicker.date) == timePicker.date{
            saveButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkName()
        navigationItem.title = textField.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //saveButton.isEnabled = false
    }
    
    @IBAction func timeChanged(_ sender: Any) {
        checkDate()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if saveButton.isEqual(sender)
        {
            var name = reminderTextField.text!
            var time = timePicker.date
           // print(Int(time.timeIntervalSinceNow) , " yalaaaa ")
            let interval = Int(time.timeIntervalSinceNow)
            let timeInterval = floor(time.timeIntervalSinceReferenceDate/60)*60
            time = NSDate(timeIntervalSinceReferenceDate: timeInterval) as Date
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            //build Notification
            let content = UNMutableNotificationContent()
        //    let reminderRequest = reminderTextField.text!
            //let url = URL (string:"https://api.imgur.com/3/gallery/search/?q=dog&page=10&client_id=ce8adac7e9067b6")
        
            
            content.title = "Check Link Below!!!"
          //  print(self.LinkFetch , " hwa dah ")
            if(self.LinkFetch == nil){
                content.body = "Not found"
            }else{
                content.body = self.LinkFetch!
            }
            
            content.sound = UNNotificationSound.default()
            
            var urlx = Bundle.main.url(forResource: "Images/rose", withExtension: "jpeg")
            if(habitSelected == "reading"){
              //  name = "My Reading Habit"
                urlx = Bundle.main.url(forResource: "Images/read", withExtension: "jpg")
            }
            else if(habitSelected == "meditate"){
              //  name = "My Meditation Habit"
                urlx = Bundle.main.url(forResource: "Images/meditate", withExtension: "jpg")
            }
            else if(habitSelected == "workout_motivation"){
              //  name = "My Workout Habit"
                urlx = Bundle.main.url(forResource: "Images/workout", withExtension: "jpg")
            }
            else if(habitSelected == "social_life"){
              //  name = "My Socializing Habit"
                urlx = Bundle.main.url(forResource: "Images/socialize", withExtension: "jpg")
            }
            let attachment = try! UNNotificationAttachment(identifier: "image", url: urlx!, options: [:])
            content.attachments = [attachment]
            
            let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let error = error{
                    print("Build Notification error: \(error)")
                }
            })
            
            reminder = Reminder(name: name, time: time as NSDate, notification: request)
 
            
        }
    }
}

    

