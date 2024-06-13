//
//  ViewController.swift
//  GroceryApp
//
//  Created by Bharath on 03/06/24.
//

import UIKit
 import SDWebImage
class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var ViewHiddenInitial: UIView!
    
    @IBOutlet weak var TextFieldSearch: UITextField!
    @IBOutlet weak var ViewShownInitial: UIView!
    @IBOutlet weak var CollectionViewmain: UICollectionView!
    var initialBool:Bool = true
    var sideBar:UIView!
    var TableView:UITableView!
    var isSideBarOpen:Bool = false
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TableViewHidden: UIView!
    

    var arrData:[String] = []
    var arr:[UIImage]! = []
    var LabelMenu:UILabel!
    var Menuimg :UIImageView!
    var ProfilePic:UIImageView!
    var NameLabel:UILabel!
    var profName = "MsDhoni"
    var swipeToRight:UIGestureRecognizer!
    var tabView:UIView!
    var buttonSideBar = UIButton()
    var arrayOfDictionaryApi:[[String:String]] = []
    var detailModel = [ProductModel]()
    var tempModel = [ProductModel]()
    override func viewDidLoad() {
     
        super.viewDidLoad()
        TextFieldSearch.delegate = self
        apiCall(link: "https://mocki.io/v1/4594154b-599b-4ce2-bce8-d7212c82604a")
        arrData = ["Home","Cart","Language","Logout"]
        arr = [UIImage(named: "Home")!,UIImage(named: "Cart")!,UIImage(named: "Tamil")!,UIImage(named: "Logout")!]
               
        sideBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.bounds.height))
        TableView = UITableView(frame:CGRect(x: 0, y: 0, width: 0, height: self.view.bounds.height) )
        self.view.addSubview(sideBar)
        
               
        CollectionViewmain.dataSource = self
        CollectionViewmain.delegate = self
        TableView.dataSource = self
        TableView.delegate = self
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
               
        self.sideBar.addSubview(TableView)
        self.sideBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
     
                buttonSideBar = UIButton(frame: CGRect(x: 250, y: 100, width: 50, height:  25))
                buttonSideBar.setTitle("Close", for: .normal)
      
        buttonSideBar.backgroundColor = .black
                buttonSideBar.isHidden = true
                buttonSideBar.addTarget(self, action: #selector(closeSideBar), for: .touchUpInside)
        self.sideBar.addSubview(buttonSideBar)
      // apiCall(link: "https://mocki.io/v1/46cc668c-9e1b-45c0-b1a6-a06e0471651b")
       
        
//
//        self.downloadImage(from: URL(string: "https://fastly.picsum.photos/id/851/200/300.jpg?hmac=AD_d7PsSrqI2zi-ubHY_-urUxCN77Gnev3k5o0P6nlE")!)
//        self.downloadImage(from: URL(string: "https://www.researchgate.net/publication/337976820/figure/fig7/AS:1086081361543213@1635953383440/Sample-tomato-images-a-c-Healthy-tomato-d-and-e-Tomato-malformed-fruit-f-Tomato.jpg")!)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let searchFieldText = TextFieldSearch.text as NSString? else{return true}
        let updatedText = searchFieldText.replacingCharacters(in: range, with: string)
        
        if updatedText.isEmpty {
            detailModel = tempModel
        }
        else{
            
            
            detailModel = tempModel.filter({
                $0.name?.lowercased().contains(updatedText.lowercased()) ?? false
            })
        }
        CollectionViewmain.reloadData()
        return true
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

            DispatchQueue.main.async() { [weak self] in
               imageViewMain.image = UIImage(data: data)
                imageViewMain.contentMode = .scaleAspectFit
            }
        }
    }
    

    
    func apiCall(link :String){
    let url = URL(string: link)!
    var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlReq){data,response,error in
            if let output = data{
                print("Output",output)
                do{
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode([ProductModel].self, from: output)
                    print("Response Model",responseModel)
                    self.detailModel = responseModel
                    self.tempModel = responseModel
                   
                }
                catch (let err){
                    print("error",err)
                }
            }
        }.resume()
        
    }
    
    @objc func closeSideBar() {
          toggleSideBar()
      }
    
    
    func toggleSideBar() {
          if isSideBarOpen {
              UIView.animate(withDuration: 0.3) {
                  self.sideBar.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.bounds.height)
                  self.TableView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.bounds.height)
                  self.buttonSideBar.isHidden = true
                  
              }
          } else {
              UIView.animate(withDuration: 0.3) {
                  self.buttonSideBar.isHidden = false
                  self.sideBar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 80, height: self.view.bounds.height)
                  self.TableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 80, height: self.view.bounds.height)
                  //self.buttonSideBar.isHidden = true
              }
          }
          isSideBarOpen.toggle()
      }
  
    

    
    @IBAction func HamburgerMenuClicked(_ sender: Any) {
        toggleSideBar()
        
    }
    
    
    @IBAction func SearchButtonClicked(_ sender: Any) {
        print("Initial Bool",initialBool)
        if initialBool
        {
            print("ViewShownInitial",ViewShownInitial.isHidden)
 //           ViewShownInitial.isHidden = true
            print("ViewShownInitial",ViewShownInitial.isHidden)
            print("ViewHiddenInitial",ViewHiddenInitial.isHidden)
            TableViewHidden.isHidden = false
            print("ViewHiddenInitial",ViewHiddenInitial.isHidden)

      }
                initialBool.toggle()
        
    }
    
    
    @IBAction func BackButton(_ sender: Any) {

            if !initialBool{
//                    MainView.isHidden = false
//                    TableViewHidden.isHidden = true
                TableViewHidden.isHidden = true
                }
           
                initialBool.toggle()
        
    }
    

}


extension ViewController : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            ProfilePic = UIImageView(frame: CGRect(x: 8, y: 8, width: cell1.bounds.height - 10.0 , height: cell1.bounds.height - 10.0 ))
            ProfilePic.contentMode = .scaleAspectFill
//            NameLabel.text = self.profName
            self.ProfilePic.layer.cornerRadius = self.ProfilePic.frame.size.width / 2
            self.ProfilePic.clipsToBounds = true
            ProfilePic.image = UIImage(named: "Msd.jpg")
            cell1.addSubview(ProfilePic)
//            NameLabel.text = self.profName
//            cell1.addSubview(NameLabel)
            
            
            return cell1
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
            
            Menuimg = UIImageView(frame: CGRect(x: 8, y: 8, width: cell.bounds.height - 16.0, height: cell.bounds.height - 16.0))
            Menuimg.contentMode = .scaleAspectFit
            Menuimg.image = self.arr[indexPath.row - 1]
            cell.addSubview(Menuimg)
            LabelMenu = UILabel(frame: CGRect(x: self.Menuimg.bounds.width + 16.0 , y:8 , width: cell.bounds.width - (self.Menuimg.bounds.width + 24), height: cell.bounds.height - 16))
            LabelMenu.text = self.arrData[indexPath.row - 1]
            cell.addSubview(LabelMenu)
            
            return  cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100.0
        }
        else{
            return 50.0
        }
    }

}

extension ViewController :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailModel.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionViewmain.dequeueReusableCell(withReuseIdentifier: "CellMain", for: indexPath)
        if let imageView = cell.viewWithTag(100) as? UIImageView,
           let productName = cell.viewWithTag(101) as? UILabel {
            let product = detailModel[indexPath.item]
            print("type of",type(of: product))
            let imgurl = URL(string: product.image!.first!)
            //cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.6
               cell.layer.shadowColor = UIColor.black.cgColor
            //   cell.layer.shadowOpacity = 0.5
               cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
               cell.layer.shadowRadius = 4.0
               cell.layer.masksToBounds = false
            downloadImage(from: imgurl!, imageViewMain: imageView)
            productName.text = product.name

        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        //return CGSize(width: self.view.frame.width / 2, height: .frame.height)
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.height/2.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailPageViewController") as! DetailPageViewController
        
        

        let selectedProduct = detailModel[indexPath.item]
        print("Product : ", selectedProduct)

        vc.wholeArr = selectedProduct
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
        

        
        //        present(vc,animated: true)
        
        
        
    }
}




