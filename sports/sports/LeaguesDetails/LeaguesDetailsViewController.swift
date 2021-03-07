//
//  LeaguesDetailsViewController.swift
//  sports
//
//  Created by MacOSSierra on 2/25/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
import CoreData

class LeaguesDetailsViewController: UIViewController ,UICollectionViewDataSource , UICollectionViewDelegate {
    
    // variables
    
    var league : Leagues?
    var leagueId = ""
    var eventsArray : [Event] = Array<Event>()
    var arrRes : [Results] = Array<Results>()
    var images : [Team] = Array<Team>()
    var favoriteLeagues = FavoriteLeagueViewController()
    
    
    
   
    
    //Favorite league Button
    
    @IBAction func favorite(_ sender: Any) {
    
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mangeContext = appdelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteLeagueEntity", in: mangeContext)
        let favoriteLeague = NSManagedObject(entity: entity!, insertInto: mangeContext)
        
        favoriteLeague.setValue(league!.id, forKey: "id")
        favoriteLeague.setValue(league!.image, forKey: "image")
        favoriteLeague.setValue(league!.name, forKey: "name")
        favoriteLeague.setValue(league!.youtube, forKey: "youtube")
        
        do{
            try mangeContext.save()
        }catch let error{
            print(error)
        }
        
        
    }
    
    //collections outlet
    
    @IBOutlet weak var teamCollection: UICollectionView!
    @IBOutlet weak var ResultCollection: UICollectionView!
    @IBOutlet weak var eventCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
        tap.direction = .right
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
        
        // calling functions
        
        getEvent()
        getResult()
        getImages()
        
    }
    

   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
  
    
    @objc func handleTap(gesture: UISwipeGestureRecognizer) -> Void{
        if gesture.direction == .right {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == eventCollection){
       // print("event count = \(eventsArray.count)")
        return eventsArray.count
        }else if(collectionView == ResultCollection){
           // print("result count = \(arrRes.count)")
            return arrRes.count
        }else if(collectionView == teamCollection){
           // print("image count = \(images.count)")
            return images.count
        }
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell1 = eventCollection.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! EventCollectionViewCell
        
        // Event collection
        
        if(collectionView == eventCollection){
        let cell1 = eventCollection.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! EventCollectionViewCell
        
        let currentEvent = eventsArray[indexPath.row]
       // print("name : \(currentEvent.name)")
            if currentEvent.name != ""{
                cell1.eventName.text = currentEvent.name
            }else{
                cell1.eventName.text = "Event Name"
            }
            if currentEvent.date != ""{
                cell1.eventDate.text = currentEvent.date
            }else{
                cell1.eventDate.text = "Event Date"
            }
            if currentEvent.time != ""{
                cell1.eventTime.text = currentEvent.time
            }else{
                cell1.eventTime.text = "Event Time"
            }
            
            cell1.layer.cornerRadius = 20
            cell1.layer.borderWidth = 2.0
            cell1.layer.shadowColor = UIColor.white.cgColor
           
       
            return cell1
        }
        
        //result collection
        
        if(collectionView == ResultCollection){
            let cell2 = ResultCollection.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! ResultsCollectionViewCell
            
            
            let currentRes = arrRes[indexPath.row]
            if(currentRes.team1 != ""){
            cell2.team1.text = currentRes.team1
            }else{
                cell2.team1.text = "Team1"
            }
            if(currentRes.team2 != ""){
            cell2.team2.text = currentRes.team2
            }else{
                cell2.team2.text = "Team2"
            }
            cell2.vs1.text = "VS"
            
            if currentRes.score1 != ""{
                cell2.score1.text = currentRes.score1
            }
            else{
                cell2.score1.text = "Score"
            }
            if currentRes.score2 != ""{
                cell2.score2.text = currentRes.score2
            }else{
                cell2.score2.text = "Score2"
            }
            cell2.vs2.text = "VS"
            if currentRes.date != ""{
                cell2.date.text = currentRes.date
            }else{
                cell2.date.text = "Date"
            }
            if currentRes.time != ""{
                cell2.time.text = currentRes.time
            }else{
                cell2.time.text = "Time"
            }
            
            //print(currentRes.team1)
            
            
            cell2.layer.cornerRadius = 20
            cell2.layer.borderWidth = 2.0
            cell2.layer.shadowColor = UIColor.black.cgColor
            return cell2
            
        }
        
        // team collection
        
        if(collectionView == teamCollection){
            
            let cell3 = teamCollection.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! TeamsCollectionViewCell
        
            let currentTeam = images[indexPath.row]
            if currentTeam.teamImage != ""{
                cell3.image.sd_setImage(with: URL(string: currentTeam.teamImage ), placeholderImage: UIImage(named: "SDWebImage_logo_small"))
            }else{
                cell3.image.image = UIImage(named: "Sport")
            }
            //print("image")
            //print(images[indexPath.row])
            
            cell3.image.layer.borderWidth = 0.0
            cell3.image.layer.masksToBounds = false
            cell3.image.layer.cornerRadius =  cell3.image.frame.size.width/2
            cell3.image.clipsToBounds = true
            
            return cell3
        }
        
        return cell1
   }

    
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
                if(collectionView == teamCollection){

                        let teamDetails = self.storyboard!.instantiateViewController(withIdentifier: "Team") as! TeamDetailsViewController

                        teamDetails.teamId = images[indexPath.row].teamId

                        self.navigationController?.pushViewController(teamDetails, animated: true)

                }
    }
    
    
    //get Event function
    
    func getEvent() {
        
        let url = "https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id="
        
        
        
        Alamofire.request(url+leagueId).validate().responseJSON {response in
            //print(self.leagueId)
            switch response.result{
                
            case .success:
                
                let result = try? JSON(data: response.data!)
                let event = result!["events"]
                for i in event.arrayValue{
                    //print(i)
                    
                    var e1 = Event()
                    e1.name = i["strEvent"].stringValue
                    e1.date = i["dateEvent"].stringValue
                    e1.time = i["strTime"].stringValue
                    
                    self.eventsArray.append(e1)
                }
                
               // print(self.arrRes)
                
                DispatchQueue.main.async {
                    //print("reload dispatch")
                    self.eventCollection.reloadData()
                    
                }
                
                
                
                
                break
            case .failure:
                print(response.error)
                break
                
                
            }
            
            
        }
        
    //end of get Event function
    }
    
    
    // get Result function
    
    func getResult() {
        let year  = "&s=2020-2021"
        
        let url = "https://www.thesportsdb.com/api/v1/json/1/eventsseason.php?id="
        //let eventUrl = "https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id="
        
        //"https://www.thesportsdb.com/api/v1/json/1/lookupevent.php?id="
        
        Alamofire.request(url+leagueId+year).validate().responseJSON {response in
           // print(self.leagueId)
            switch response.result{
                
            case .success:
                
                let result = try? JSON(data: response.data!)
                let event = result!["events"]
                for i in event.arrayValue{
                    //print(i)
                    
                    var e1 = Results()

                    e1.team1 = i["homeTeam"].stringValue
                    e1.team2 = i["strAwayTeam"].stringValue
                    e1.score1 = i["intHomeScore"].stringValue
                    e1.score2 = i["intAwayScore"].stringValue
                    e1.date = i["dateEvent"].stringValue
                    e1.time = i["strTime"].stringValue
                    
                    self.arrRes.append(e1)
                }
                
                //print(self.arrRes)
                
                DispatchQueue.main.async {
                    //print("reload dispatch")
                    self.ResultCollection.reloadData()
                    
                    
                }
                
                break
            case .failure:
                print(response.error)
                break
            
            }
            
            
        }
    // end of get Result function
    }
    
    
    
    // get Teanm Images function
    func getImages()  {
        
        //let url = "https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id="
        
    //teams API
        
     let url = "https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id="
        
        Alamofire.request(url+leagueId).validate().responseJSON {response in
            //print(self.leagueId)
            switch response.result{
                
            case .success:
                
                let result = try? JSON(data: response.data!)
                let event = result!["teams"]
                for i in event.arrayValue{
                   // print(i)
                    //let image = i["strThumb"].stringValue
                    var t1 = Team()
                    
                    t1.teamImage =  i["strTeamBadge"].stringValue
                    t1.teamId = i["idTeam"].stringValue
                    self.images.append(t1)
                }
                
                //print(self.arrRes)
                
                DispatchQueue.main.async {
                    //print("reload dispatch")
                    
                    self.teamCollection.reloadData()
                    
                }
                
                
                
                
                break
            case .failure:
                print(response.error)
                break
                
                
            }
            
            
        }
    // end of get Teanm Images function
    }
    
}

