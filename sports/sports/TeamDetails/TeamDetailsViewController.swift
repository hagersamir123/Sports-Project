//
//  TeamDetailsViewController.swift
//  sports
//
//  Created by MacOSSierra on 3/1/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class TeamDetailsViewController: UIViewController {

   
    @IBOutlet weak var stadiumTxt: UILabel!
    @IBOutlet weak var stadiumImage: UIImageView!
    @IBOutlet weak var sportName: UILabel!
    @IBOutlet weak var TeamName: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    
    var teamId : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var teamDetails = TeamDetails()
        let url = "https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=English%20Premier%20League"
        
        Alamofire.request(url).validate().responseJSON {response in
            
            
            switch response.result{
                
            case .success:
                
                let result = try? JSON(data: response.data!)
                //print("Alamofire")
                let leagues = result!["teams"]
                for i in leagues.arrayValue{
                    if(self.teamId == i["idTeam"].stringValue){
                        
                        teamDetails.teamImage = i["strTeamBadge"].stringValue
                        teamDetails.teamName = i["strTeam"].stringValue
                        teamDetails.sportName = i["strSport"].stringValue
                        teamDetails.establish = i["establishment"].stringValue
                        teamDetails.stadiumImage = i["strStadiumThumb"].stringValue
                        teamDetails.stadiumName = i["strStadium"].stringValue
                        
                       // print(teamDetails.teamName)
                        //print(teamDetails.teamImage)

                        break
                        
                    }
                    
                }
                // print(teamDetails.stadiumImage)
                // print(self.teamId)
                if(teamDetails.sportName != ""){
                self.sportName.text = teamDetails.sportName
                }else{
                    self.sportName.text = "Sport Name"
                }
                if(teamDetails.teamName != ""){
                self.TeamName.text = teamDetails.teamName
                } else{
                     self.TeamName.text = "Team Name"
                }
                 if(teamDetails.teamImage != ""){
                self.teamImage.sd_setImage(with: URL(string: teamDetails.teamImage), placeholderImage: UIImage(named: "SDWebImage_logo_small"))
                 }else{
                    self.teamImage.image = UIImage(named: "Sport")
                }
                if(teamDetails.stadiumName != ""){
                    self.stadiumTxt.text = teamDetails.stadiumName
                }else{
                    self.stadiumTxt.text = "Stadium Name"
                }
                if(teamDetails.stadiumImage != ""){
                    self.stadiumImage.sd_setImage(with: URL(string: teamDetails.stadiumImage), placeholderImage: UIImage(named: "SDWebImage_logo_small"))
                }else{
                    self.stadiumImage.image = UIImage(named: "stadium")
                }
                
                
                
                break
            case .failure:
                print("error")
                print(response.error)
                break
                
                
            }
        }
    

        
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
