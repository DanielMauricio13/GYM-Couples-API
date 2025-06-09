import Fluent
import Vapor
struct basicLogin{
    var email: String
}
final class User: Model, Content, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "lastName")
    var lastName: String
    
    @Field(key: "firstName")
    var firstName: String
    
    @Field(key: "age")
    var age: Int?
    
    @Field(key: "gender")
    var gender: String?
    
    @Field(key: "weight")
    var weight: Int?
    
    @Field(key: "goal")
    var goal: String?
    
    @Field(key: "bodyStructure")
    var bodyStructure: String?
    
    @Field(key: "height")
    var height: Int?
    
    @Field(key: "DailyProtein")
    var DailyProtein: Int?
    
    @Field(key: "DailyCalories")
    var DailyCalories: Int?
    
    @Field(key: "email")
    var email: String?
    
    @Field(key: "password")
    var password: String?
    @Field(key: "numDays")
    var numDays: Int?
    @Field(key: "numHours")
    var numHours: String?
    @Field(key:"heightFt")
    var heightFt: Int?
    @Field(key:"heightInc")
    var heightInc: Int?
    @Field(key:"burnCalories")
     var burnCalories: Int?
    @Field(key: "water")
    var water: Double?
    @Field(key: "sugars")
    var sugars:Int?
    @Field(key: "carbs")
    var carbs:Int?
    
    init() { }
    
  
    init(id: UUID?, firstName: String, lastName: String, age: Int, gender: String, weight: Int, goal: String, bodyStructure: String, height: Int, DailyCalories: Int, DailyProtein: Int, email: String, password: String, heightFt: Int, heightInc: Int, numHours: String, numDays: Int, sugars: Int, carbs: Int, burnCalories: Int, water: Double) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.gender = gender
        self.weight = weight
        self.goal = goal
        self.bodyStructure = bodyStructure
        self.height = height
        self.DailyCalories = DailyCalories
        self.DailyProtein = DailyProtein
        self.email = email
        self.password = password
        self.heightFt = heightFt
        self.heightInc = heightInc
        self.numHours = numHours
        self.numDays = numDays
        self.sugars = sugars
        self.carbs = carbs
        self.burnCalories = burnCalories
        self.water = water
    }
    
}
//extension User: ModelAuthenticatable {
//
//
//    static let passwordHashKey = \User.$password
//
//    func verify(password: String) throws -> Bool {
//        try Bcrypt.verify(password, created: self.password!)
//    }
//}


