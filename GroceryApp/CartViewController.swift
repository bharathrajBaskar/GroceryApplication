//
//  CartViewController.swift
//  GroceryApp
//
//  Created by Bharath on 10/06/24.
//

import UIKit

class CartViewController: UIViewController {
    var arrayOfDictionary:[[String:String]] = []
    @IBOutlet weak var TableViewCart: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        TableViewCart.delegate = self
        TableViewCart.dataSource = self
        
    }
    
    @IBAction func ButtonCheckoutCLicked(_ sender: Any) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print(arrayOfDictionary)
        arrayOfDictionary = UserDefaults.standard.array(forKey: "addTocart") as? [[String:String]] ?? []
        print("arrayof dict ",arrayOfDictionary)
        print("arrayOfDictionary count" ,arrayOfDictionary.count)

        
        TableViewCart.reloadData()
    }
    func saveCart() {
            UserDefaults.standard.set(arrayOfDictionary, forKey: "addTocart")
            TableViewCart.reloadData()
        }
  

}

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}


func downloadImage(from url: URL,imageViewMain:UIImageView) {
    print("Download Started")

    getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")

        DispatchQueue.main.async() { //[weak self] in
           imageViewMain.image = UIImage(data: data)
            imageViewMain.contentMode = .scaleAspectFit
        }
    }
}


extension CartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCart.dequeueReusableCell(withIdentifier: "CartCell",for: indexPath)
        let imageViewProduct = cell.viewWithTag(300) as! UIImageView
        let productNameLabel = cell.viewWithTag(301) as! UILabel
        let productPriceLabel = cell.viewWithTag(302) as! UILabel
        let productQuantityDecrementButton = cell.viewWithTag(303) as! UIButton
        print("productQuantityDecrementButton",productQuantityDecrementButton.tag)
        let productQuabtityLabel = cell.viewWithTag(304) as! UILabel
        let productQuantityIncrementButton = cell.viewWithTag(305) as! UIButton
        let labelBorderLine =  cell.viewWithTag(306) as! UILabel
        let arr = arrayOfDictionary[indexPath.row]
        cell.selectionStyle = .none
        productNameLabel.text = arr["name"]
        productPriceLabel.text = arr["price_per_kg"]
        productQuabtityLabel.text = arr["quantity"]
        let imageStr = arr["image"]
        
        let imageUrl = URL(string: imageStr!)!
        
        downloadImage(from: imageUrl, imageViewMain: imageViewProduct)
        
        
        productQuantityDecrementButton.layer.cornerRadius = productQuantityDecrementButton.frame.width / 2
        productQuantityIncrementButton.layer.cornerRadius = productQuantityIncrementButton.frame.width / 2
        print("productQuantityIncrementButton", productQuantityIncrementButton.tag)
      //  imageViewProduct.backgroundColor = .blue
      //  productQuantityDecrementButton.tag = indexPath.row
        productQuantityIncrementButton.imageView?.tag = indexPath.row
        print("productQuantityDecrementButton",productQuantityDecrementButton.tag)
     //   productQuantityIncrementButton.tag = indexPath.row
        productQuantityDecrementButton.imageView?.tag = indexPath.row
        print("productQuantityIncrementButton", productQuantityIncrementButton.tag)
        
        

        
        productQuantityDecrementButton.addTarget(self, action: #selector(decrementAction(sender: )), for: .touchUpInside)
        productQuantityIncrementButton.addTarget(self, action: #selector(incrementAction(sender: )), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    @objc func decrementAction(sender:UIButton){
      //  if let tag = sender.imageView?.tag {
          //  let indexp = IndexPath(row: tag, section: 0)
           // let valueToUpdated = arrayOfDictionary[indexp.row]
          //  print(tag)
            
       // }
        
//        if let cell = sender.superview?.superview as? UITableViewCell,
//                 let indexPath = TableViewCart.indexPath(for: cell) {
//                  let rowIndex = indexPath.row
//                  print("Decrement button tapped at row: \(rowIndex)")
//
//              }
        
        let rowIndex = sender.imageView?.tag
        if var quantity = Int(arrayOfDictionary[rowIndex!]["quantity"] ?? "1"), quantity > 1 {
                   quantity -= 1
            arrayOfDictionary[rowIndex!]["quantity"] = String(quantity)
                   saveCart()
               } else {
                   arrayOfDictionary.remove(at: rowIndex!)
                   saveCart()
               }
    }
    
    @objc func incrementAction(sender:UIButton){
      //  if let tag = sender.imageView?.tag {
          //  let indexp = IndexPath(row: tag, section: 0)
       //     let valueToUpdated = arrayOfDictionary[indexp.row]
          //  print(tag)
        
        
       // let rowIndex = sender.imageView?.tag
       // if var quantity = Int(arrayOfDictionary[rowIndex!]["quantity"] ?? "1")  {
            //if let available_stock = Int(arrayOfDictionary[rowIndex!]["available_quantity"] = quantity){
//            if let availableStock = Int(arrayOfDictionary[rowIndex!]["available_quantity"]!)! >= quantity{
//            quantity += 1
//            }
//            else{
//                sender.isUserInteractionEnabled = false
//            }
//                  // quantity += 1
//            arrayOfDictionary[rowIndex!]["quantity"] = String(quantity)
//                   saveCart()
            
        //}
        let rowIndex = sender.imageView?.tag
        if var quantity = Int(arrayOfDictionary[rowIndex!]["quantity"] ?? "1"),
           let availableQuantity = Int(arrayOfDictionary[rowIndex!]["available_quantity"] ?? "0"),
                 quantity < availableQuantity {
                  quantity += 1
            arrayOfDictionary[rowIndex!]["quantity"] = String(quantity)
            saveCart()
              } else {
                  showAlert(message: "No more stock available for this product")
              }
              saveCart()
        
        
        
//        if let cell = sender.superview?.superview as? UITableViewCell,
//                 let indexPath = TableViewCart.indexPath(for: cell) {
//                  let rowIndex = indexPath.row
//                  print("Increment button tapped at row: \(rowIndex)")
//
//              }
        
    }
    func showAlert(message:String){
        let alertController = UIAlertController(title: "Cart", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        present(alertController,animated: true,completion: nil)
        
    }
    
}
