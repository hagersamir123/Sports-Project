//
//  AllSportsViewController.swift
//  sports
//
//  Created by MacOSSierra on 2/26/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class AllSportsViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate {
   

    var arrRes : [AllSports] = Array <AllSports>()
    var leaguas  = LeagueViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        leaguas  = self.storyboard?.instantiateViewController(withIdentifier: "league") as! LeagueViewController
        
       
        
        // All sports data
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/all_sports.php").validate().responseJSON {response in


            switch response.result{

            case .success:

                let result = try? JSON(data: response.data!)
                //print("Alamofire")
                let sport = result!["sports"]
                for i in sport.arrayValue{
                    //print(i)
                    var s1 = AllSports()
                    s1.strsport = i["strSport"].stringValue
                    s1.strsportThumb = i["strSportThumb"].stringValue
                    self.arrRes.append(s1)

                }


                DispatchQueue.main.async {

                    self.collection.reloadData()

                }


                break
            case .failure:
                print(response.error)
                break


            }


        }
        
    }
    
    
    @IBOutlet weak var collection: UICollectionView!
    

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRes.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SportsCollectionViewCell
        
        // Configure the cell
        
        let currentSport = arrRes[indexPath.row]
                
        cell.sportName.text = currentSport.strsport
        
        cell.sportImage.sd_setImage(with: URL(string: currentSport.strsportThumb ?? ""), placeholderImage: UIImage(named: "SDWebImage_logo_small"))
        
     
        //rounded cell
        
        
        
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 2.0
        cell.layer.shadowColor = UIColor.white.cgColor
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        leaguas.sportName = arrRes[indexPath.row].strsport!
        
        self.navigationController?.pushViewController(leaguas, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
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
