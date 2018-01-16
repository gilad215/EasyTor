
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MessagesTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var chatLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var partnerID:String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getPartnerPic()
    {
        let imageURL = Storage.storage().reference(forURL: "gs://eztor-b332f.appspot.com").child(partnerID).child("userPhoto")
        
        imageURL.downloadURL(completion: { (url, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                guard let imageData = UIImage(data: data!) else { return }
                
                DispatchQueue.main.async {
                    self.profileImage.image = imageData
                }
                
            }).resume()
            
        })
    }
    
}
