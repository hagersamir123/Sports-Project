//
//  LeagueViewController.swift
//  sports
//
//  Created by MacOSSierra on 2/28/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class LeagueViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    
    
    // variables
    var sportName : String = ""
    var arrRes : [Leagues] = Array <Leagues>()
    var idArray :[String] = Array<String>()
    var event = LeaguesDetailsViewController()
    var str = ""

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func youtubeButton(_ sender: Any) {
       // print("\(str)")
        let url = URL(string: "https://"+str)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       // print(sportName)
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/all_leagues.php").validate().responseJSON {response in
            
            self.idArray.removeAll()
            switch response.result{
                
            case .success:
                
                let result = try? JSON(data: response.data!)
                //print("Alamofire")
                let leagues = result!["leagues"]
                
                for i in leagues.arrayValue{
                    // print(i)
                    if (self.sportName == i["strSport"].stringValue){
                        //print("found the sport")
                        let id = i["idLeague"].stringValue
                        self.idArray.append(id)
                    }
                }
                self.callApiLeagueDetailsByID()
                
                
                
                break
            case .failure:
                print("error")
                print(response.error as Any)
                break
                
                
            }
            
            
        }
    }
    
    // callApiLeagueDetailsByID function
    
    func callApiLeagueDetailsByID(){
       // print(idArray)
        
        for i in self.idArray{
           
            
            let id = i
            
            let url =  "https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id="+i
            
            Alamofire.request(url).validate().responseJSON {response in
                
                
                switch response.result{
                    
                case .success:
                    
                    let result = try? JSON(data: response.data!)
                    //print("Alamofire")
                    let leagues = result!["leagues"]
                    for j in leagues.arrayValue{
                        var l1 = Leagues()
                        l1.image = (j["strBadge"].stringValue as? String)!  
                        l1.name = j["strLeague"].stringValue
                        l1.youtube = j["strYoutube"].stringValue
                        l1.id = id
                        self.arrRes.append(l1)

                    }
                    
                    
                    self.tableView.reloadData()
                    

                    
                    break
                case .failure:
                    print("error")
                    print(response.error as Any)
                    break
                    
                    
                }
            }
        }
        
        // end of callApiLeagueDetailsByID function
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrRes.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as!LeagueTableViewCell
        
        var currentLeague = arrRes[indexPath.row]
        
        cell.leaguetName.text = currentLeague.name
        cell.leagueImage.sd_setImage(with: URL(string: currentLeague.image ?? ""), placeholderImage: UIImage(named: "SDWebImage_logo_small"))
        
        str = arrRes[indexPath.row].youtube
        
        // circular image
        cell.leagueImage.layer.borderWidth = 1.0
        cell.leagueImage.layer.masksToBounds = false
        cell.leagueImage.layer.borderColor = UIColor.white.cgColor
        cell.leagueImage.layer.cornerRadius =  cell.leagueImage.frame.size.width/2
        cell.leagueImage.clipsToBounds = true
        
        return cell
    }
    
    

    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsVC = self.storyboard!.instantiateViewController(withIdentifier: "Detail") as! LeaguesDetailsViewController
        //print(arrRes[indexPath.row])
        detailsVC.leagueId = arrRes[indexPath.row].id
        detailsVC.league = arrRes[indexPath.row]
        
        let navController = UINavigationController(rootViewController: detailsVC)
        self.present(navController, animated:true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.idArray.removeAll()
        self.arrRes.removeAll()
        self.tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
