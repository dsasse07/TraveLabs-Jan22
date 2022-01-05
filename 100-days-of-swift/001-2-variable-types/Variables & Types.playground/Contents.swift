import UIKit

func day1() {
    var greeting = "Hello, playground"
    greeting = "Goodbye"
    print(greeting)
    
    //Multi line strings
    var str1 = """
        This goes
        over multiple
        lines
        """
    print (str1)
    
    //Multi line string without saving the line breaks
    var str2 = """
        This goes \
        over multiple \
        lines
        """
    print(str2)
    
    let myConstant = "This value cannot be changed"
    print(myConstant)
    
    var isAwesome: Bool = true
    print(isAwesome)
}
day1()

// Complex Data Types
func day2(){
    //Arrays
    let john = "John Lennon"
    let paul = "Paul McCartney"
    let george = "George Harrison"
    let ringo = "Ringo Starr"
    
    let beatles: [String] = [john, paul, george, ringo]
    print (beatles)
    
    // Sets - Arrays, but no order, and unique values
    let colors = Set(["red", "green", "blue"])
    let colors2 = Set(["red","red", "green", "blue"])
    print(colors)
    print(colors2)
    
    //Tuples
    /** Fixed size and type */
    var name = (first: "Taylor", last: "Swift")
    name.0
    name.first
    
    //Dictionaries - can provide a default value if key is missing
    var heights = [
        "Taylor Swift": 1.78,
        "Ed Sheeran": 1.73
    ]
    heights["Ed Sheeran"]
    
    let favoriteIceCream = [
        "Paul": "chocolate",
        "Rebecca": "vanilla"
    ]
    favoriteIceCream["Danny", default: "Mint"]
    
    // Creating Empty Collections
    var teams = [String: String]() // or Dictionary<String, String>()
    var results = [Int]() // or Array<Int>
    var newSet = Set<String>()
    var newSet2 = Set<Int>()
    
    // enums
    enum Result {
        case success
        case failure
    }
    let result = Result.failure
    
    // Add associated values to an enum
    enum Activity {
        case bored
        case running(destination: String)
        case talking(topic: String)
        case singing(volume: Int)
    }
    var activity = Activity.talking(topic: "football")
    
    // Using raw values
    enum Planets: Int {
        case mercury = 1
        case venus
        case earth
        case mars
    }
    
    let earth = Planets(rawValue: 3)
}
day2()
