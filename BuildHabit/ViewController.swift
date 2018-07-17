//
//  ViewController.swift
//  BuildHabit
//
//  Created by Admin on 5/15/18.
//  Copyright © 2018 Admin. All rights reserved.
//


import UIKit
import UserNotifications
import Alamofire
import SwiftyJSON
import Firebase
/*
struct ImgureResponse:Decodable{
    let data:[Gallery]
    let success:Bool
    let status:Int
}

struct Gallery:Decodable{
    let id:String
    let title:String
}
*/
/*
struct tag:Decodable{
    "name": "dog",
    "display_name": "dog",
}
 
struct image:Decodable{
    "link": "https://i.imgur.com/lfCgT8l.jpg",
}
 */


class ViewController: UIViewController, UITableViewDelegate , UITableViewDataSource
{

    let elements = ["One","Two","Three","Four","Five"]
    //var countries = [Country]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNUserNotificationCenter.current().requestAuthorization(options:
        [.alert, .badge, .sound]) { (success, error) in
            if error != nil {
                print("Authorization Unsuccessful")
            }
            else{
                print("Authorization successful")
            }
        }
        
      //  let url = URL (string:"https://restcountries.eu/rest/v2/all")
        let url = URL (string:"https://api.imgur.com/3/gallery/search/?q=dogs&page=10&client_id=ce8adac7e9067b6")
       // let url = URL (string:"https://api.letsbuildthatapp.com/jsondecodable/website_description")
        
        Alamofire.request(url!).responseJSON { (response) in
            let result = response.data!
            print(result)
            
            do{
                let countries = try JSONDecoder().decode(ImgureResponse.self, from: result)
                /*
                for country in self.countries{
                    print(country.name," : ",country.capital)
                }
              */
             //  print(countries.data[1].title)
            }catch{
                print("error")
            }
 

        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return elements.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as!
        CustomTableViewCell
        
        cell.myLabel.text = elements[indexPath.row]
        return cell
    }
    
    
    /// For Notification below code
    
    /*
    @IBAction func notifyButton(_ sender: UIButton) {
        timedNotification(inSeconds: 10) { (success) in
            if success {
                print("Successfully Notified")
            }
        }
    }
    
    
    func timedNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool)->()){
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let content = UNMutableNotificationContent()
        
        content.title = "Breaking news"
        content.subtitle = "hey wassup this is subtitle"
        content.body = "asdasdadasda asdasdad asdadasdasd zqasdasdas "
        
        let request = UNNotificationRequest(identifier: "customeNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            }
            else {
                completion(true)
            }
        }
        
    }
 */

}

