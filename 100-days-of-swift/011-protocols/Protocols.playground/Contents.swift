import UIKit

// Describes a contract / inheritance / protocol that other structs can accept
protocol Identifiable {
    var id: String {get set}
}

struct User : Identifiable {
    var id: String
    var email: String
}
struct Dog : Identifiable {
    var id: String
    var breed: String
}

// Item can be of any type as long as that type follows the Identifiable protocol
func displayId(item: Identifiable){
    print("My id is \(item.id)")
}

let fred = User(id: "12345", email: "a@a.com")
let rover = Dog(id: "54321", breed: "Poodle")

displayId(item: fred)
displayId(item: rover)

// Protocols can inherit from multiple other protocols

protocol Payable {
    func calculateWages() -> Int
}
protocol NeedsTraining {
    func study()
}
protocol HasVacation {
    func takeVacation(days: Int)
}

protocol Employee : Payable, NeedsTraining, HasVacation {}
// We can then inherit from this "master" protocol
class Worker : Employee {
    var hourlyRate: Int
    var remainingVacation: Int = 20
    init(hourlyRate: Int){
        self.hourlyRate = hourlyRate
    }
    func study(){
        print("Reading the books, Joe")
    }
    func calculateWages() -> Int {
        return hourlyRate * 40
    }
    func takeVacation(days: Int) {
        if remainingVacation - days >= 0 {
            print("Going on vacation for \(days) day(s)")
            remainingVacation -= days
        } else {
            print("You don't have enough vacation time left. Back to work!")
        }
    }
}
let joe = Worker(hourlyRate: 25)
joe.calculateWages()
joe.remainingVacation
joe.takeVacation(days: 10)
joe.remainingVacation
joe.takeVacation(days: 20)

// Extensions allow you to add methods to existing types to add functionality.
// Cannot add stored properties, but you can add computed properties

extension Int {
    func squared() -> Int {
        return self * self
    }
    var isEven: Bool {
        return self % 2 == 0
    }
}

let number = 8
number.squared()
number.isEven

// Protocol extensions allow you to extend a whole protocl so that all implementers get the change
// Both Arrays and Set structs implement the Collection Protocol.
// We can extend the Collection protocol to include a method, and all implements will gain that method

let pythons = ["Eric", "Graham", "Michael", "Terry", "Terry"]
let beatles = Set(["John", "Paul", "George","Ringo"])

extension Collection {
    func summarize () {
        print("There are \(count) of us:")
        for name in self {
            print(name)
        }
    }
}
pythons.summarize()
beatles.summarize()

// Protocol Oriented Programming
/** CRAFT THE CODE AROUND THE PROTOCOLS */

protocol Named {
    var name: String {get set}
    func sayName ()
}

extension Named {
    func sayName() {
        print("My name is \(name)")
    }
}

struct Pet : Named {
    var name: String
}
 let fido = Pet(name: "Fido")
fido.sayName()
