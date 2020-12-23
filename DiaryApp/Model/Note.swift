import Foundation
import ObjectMapper

class Note : NSObject, Mappable {
	var id : String?
	var title : String?
	var content : String?
	var date : String?
    
    override init() {
        super.init()
    }
    required init?(map: Map) {

    }
    func mapping(map: Map) {
		id <- map["id"]
		title <- map["title"]
		content <- map["content"]
		date <- map["date"]
	}
}


