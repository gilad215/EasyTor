
import MapKit

class PinAnnotation : NSObject, MKAnnotation
    
{
    var title: String?
    var subTitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String,subTitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
        
    }
    
    
}
