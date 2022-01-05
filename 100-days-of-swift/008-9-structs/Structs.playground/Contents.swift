import UIKit

/** Creating custom types & classes */

// Structs
struct Sport {
    var name: String // Stored property
    var isOlympicSport: Bool // Stored property
    
    // Computed Property
    var olympicStatusMessage: String {
        if isOlympicSport {
            return "\(name) is an Olympic sport"
        } else {
            return "\(name) is not an Olympic sport"
        }
    }
}

var tennis = Sport(name: "tennis", isOlympicSport: true)
print(tennis.olympicStatusMessage)

var chessBoxing = Sport(name:"Chess Boxing", isOlympicSport: false)
print(chessBoxing.olympicStatusMessage)

/** Property Observers */
/** Create a progress struct that prints a message any time Progress.amount changes */

struct Progress {
    var task: String
    // didSet and willSet are property observers that run after/before the value is changed
    var amount: Int {
        didSet {
            print("\(task) is now \(amount)% complete")
        }
    }
}

var progress = Progress(task: "Loading Data", amount: 0)
progress.amount = 30
progress.amount = 80
progress.amount = 100

/** Methods in structs */
/** By default, Swift will not let you write methods that chage property values unless specifically labeled as mutating */
/** Mutating funcs can still only  change properties if the instance of the Struct is a variable, not a constant */

struct City {
    var population: Int
    func collectTaxes() -> Int {
        return population * 1000
    }
    mutating func babyBoom() -> Void {
        population += 20_000
    }
}

var london = City(population: 900_000)
london.collectTaxes()
print(london.population)
london.babyBoom()
print(london.population)

/** Advanced Structs */
/** Intiializers:
        Typically all properties must be set manually when creating a new structure. You could use an initializer to set defaults instead
 */
struct User {
    var name: String
    
    init() {
        name = "Anonymous"
    }
}
var fred = User()
fred.name
fred.name = "Fred"
fred.name

struct Employee {
    var name: String
    var yearsActive: Int = 0
}

extension Employee {
    init(){
        name = "Anonymous"
        print("Creating an anonymous employee")
    }
}
let roslin = Employee(name: "Laura Roslin") // Uses synthetic initializer
let anon = Employee() // Uses custom initializer that takes no params


// Lazy properties
/** A Lazy property will not be populated/created until it is called at least once.
        Here, we assme making a family tree would be time/resource intensive, so we won't create it until it is asked for.
            This is similar to a computed property, however unlike a computed property the result will not be recomputed
                    each time the property is called.
        Since a Lazy property changes the struct, it cannot be used on constant structs
 */
struct FamilyTree {
    init() {
        print("Creating Family Tree")
    }
}

struct Person {
    var name: String
    lazy var familyTree = FamilyTree()
    
    init(name: String){
        self.name = name
        
    }
}

// Static properties
/** belong to the struct, not an instance of it */

struct Student {
    static var classSize = 0
    var name: String
    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}

let s1 = Student(name: "Sam")
Student.classSize
let s2 = Student(name: "Bono")
Student.classSize

// Access control : Public & Private
struct Citizen {
    var name: String
    private var id: String
    init(name: String, id: String){
        self.name = name
        self.id = id
    }
}

let bob = Citizen(name:"Bob", id:"12345")
bob.name
// bob.id will throw an error
