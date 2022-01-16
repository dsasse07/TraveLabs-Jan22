import UIKit

protocol Toggleable {
    mutating func toggle()
}

enum Switch: Toggleable {
    case on,off
    
    mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
}

struct LightBulb: Toggleable {
    var state: Switch
    
    mutating func toggle() {
        state.toggle()
    }
}

class LightBulbClass: Toggleable {
    var state: Switch
    
    init(state: Switch){
        self.state = state
    }
        
    func toggle() {
        state.toggle()
    }
}




print ("Using structs")
var lightBulb1 = LightBulb(state: .off)
var lightBulb2 = lightBulb1

print("Lamp 1 is: \(lightBulb1.state)")
print("Lamp 2 is: \(lightBulb2.state)")

print("Toggle lamp 1")
lightBulb1.toggle()

print("Lamp 1 is: \(lightBulb1.state)")
print("Lamp 2 is: \(lightBulb2.state)")


print("Using classes")
var lightBulbClass1 = LightBulbClass(state: .off)
var lightBulbClass2 = lightBulbClass1

print("Lamp 1 Class is: \(lightBulbClass1.state)")
print("Lamp 2 Class is: \(lightBulbClass2.state)")

print("Toggle lamp 1")
lightBulbClass1.toggle()

print("Lamp 1 Class is: \(lightBulbClass1.state)")
print("Lamp 2 Class is: \(lightBulbClass2.state)")



// Optionals

var name: String
name = "Danny"

func printGreeting1(_ possibleName: String?){
    if let name = possibleName {
        print("Hello \(name), how are you?")
    }
}

func printGreeting2(_ possibleName: String?){
    guard let name = possibleName else {return}
    print("Hello \(name), how are you?")
}

func printGreeting3(_ possibleName: String?){
    let name = possibleName ?? "Friend"
    print("Hello \(name), how are you?")
}

printGreeting1(name)
printGreeting1(nil)

printGreeting2(name)
printGreeting2(nil)

printGreeting3(name)
printGreeting3(nil)

