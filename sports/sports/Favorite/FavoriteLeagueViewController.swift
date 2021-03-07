//
//  FavoriteLeagueViewController.swift
//  sports
//
//  Created by MacOSSierra on 3/5/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit
import CoreData

let reachabiltity = try! Reachability()

class FavoriteLeagueViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
 
    var arrOfLeagueFav = [NSManagedObject]()
    var idArray :Array = Array <String>()
    var leagueid = ""
    var str = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       


        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for i in idArray{
            if(i == leagueid){
                continue
            }else{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let manageContext = appDelegate.persistentContainer.viewContext
                //fetch request
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeagueEntity")
                
                do{
                    arrOfLeagueFav = try manageContext.fetch(fetchRequest)
                }catch let error{
                    print(error)
                }
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        //fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeagueEntity")
       
        do{
            arrOfLeagueFav = try manageContext.fetch(fetchRequest)
        }catch let error{
            print(error)
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrOfLeagueFav.count)
        return arrOfLeagueFav.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as!LeagueTableViewCell
        
        cell.leaguetName.text = arrOfLeagueFav[indexPath.row].value(forKey: "name") as? String
        
        cell.leagueImage.sd_setImage(with: URL(string: arrOfLeagueFav[indexPath.row].value(forKey: "image") as! String ), placeholderImage: UIImage(named: "SDWebImage_logo_small"))
        
        str = (arrOfLeagueFav[indexPath.row].value(forKey: "youtube") as? String)!
        
        
        
        
        return cell
    }
    
   
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // Delete the row from the data source
            //1 app delgate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //2 manage object context
            let manageContext = appDelegate.persistentContainer.viewContext
            
            manageContext.delete(arrOfLeagueFav[indexPath.row])
            do{
                try manageContext.save()
                
                
            }catch let error{
                
                print(error)
            }
            arrOfLeagueFav.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    @IBAction func youtubeButton(_ sender: Any) {
        
       // print("\(str)")
        let url = URL(string: "https://"+str)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        reachabiltity.whenReachable = { reachabiltity in
            let detailsVC = self.storyboard!.instantiateViewController(withIdentifier: "Detail") as! LeaguesDetailsViewController
            // print(arrResult[indexPath.row])
            var leagueModelObj = Leagues()
            leagueModelObj.id = self.arrOfLeagueFav[indexPath.row].value(forKey: "id") as! String
            leagueModelObj.name = self.arrOfLeagueFav[indexPath.row].value(forKey: "name") as! String
            leagueModelObj.youtube = self.arrOfLeagueFav[indexPath.row].value(forKey: "youtube") as! String
            leagueModelObj.image = self.arrOfLeagueFav[indexPath.row].value(forKey: "image") as! String
            detailsVC.league = leagueModelObj
            detailsVC.leagueId = leagueModelObj.id
            let navController = UINavigationController(rootViewController: detailsVC)
            self.present(navController, animated:true, completion: nil)
            
        }
        
        reachabiltity.whenUnreachable = { reachabiltity in
            // print("no wifi connection ......")
            self.showAlert()
            
        }
        
        do{
            try reachabiltity.startNotifier()
        }catch let error{
            print(error)
        }
        
       
        
    }
    
    func showAlert() {
        // Create new Alert
        let dialogMessage = UIAlertController(title: "wifi connection", message: "You Don't Connect to the internet please connect and try again", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
           // print("Ok button tapped")
        })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }

}
