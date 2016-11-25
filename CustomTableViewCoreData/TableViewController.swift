//
//  TableViewController.swift
//  CustomTableViewCoreData
//
//  Created by Kashif on 24/11/16.
//  Copyright © 2016 Kashif. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var parsedData = [[String:String]]()
    var pics = [String:UIImage]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fileUrl = Bundle.main.url(forResource: "Test", withExtension: "json")
        
        let jsonData = NSData(contentsOf: fileUrl!)
        do {
            
            parsedData = try JSONSerialization.jsonObject(with: jsonData as! Data  , options: .allowFragments) as! [[String:String]]
        } catch let error as NSError {
            print(error)
        }
        
        return parsedData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = CustomCellClass()
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellClass

        let student = Student(context: context)

        
        let row = indexPath.row
        
        let currentCellData = parsedData[row]
        
        cell.tag = row
        cell.imageViewCell.image=nil
        cell.name.text = currentCellData["name"]
        cell.marks.text = currentCellData["marks"]
        
        student.id = Int16(row)
        student.name = currentCellData["name"]
        student.marks = Int32(currentCellData["marks"]!)!
        
        let imgLink = currentCellData["imageUrl"]!
        let imgUrl = URL(string: imgLink)
        
        if Int16(row) == getStudentData(row: row).id{
            if getStudentData(row: row).image != nil {
            cell.imageViewCell.image = UIImage(data: getStudentData(row: row).image as Data)
            }
        }else{
            DispatchQueue.global().async {[weak self] in
                do {
                    let imgData = try Data(contentsOf: imgUrl!)
                    student.image = imgData as NSData?
                    let downloadedImage = UIImage(data: imgData)
                    print(indexPath.row)
                    self?.pics[imgLink] = downloadedImage
                    print(self?.pics[imgLink] ?? "No Image Here!")
                    DispatchQueue.main.async {
                        print(" Cell tag : \(cell.tag)")
                        if cell.tag == row{
                            cell.imageViewCell.image=downloadedImage
                        }
                        else {
                            print("Data ignored!!")
                        }
                    }
                }
                catch{
                    
                }
            }
        }
        
        
        
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
//        getStudentData()
        return cell
    }
    
    func getStudentData(row:Int) -> (id:Int16, image:NSData) {
        var result = [Student]()
        var res : NSData?
        do{
            result = try context.fetch(Student.fetchRequest()) as! [Student]
            
            res = result[row].image
            return (result[row].id, res! as NSData)
        }catch{
            print("Data cant be fetched !!")
        }
        return (result[row].id, res! as NSData)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
