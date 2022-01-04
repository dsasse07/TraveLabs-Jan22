import UIKit

/**
 Classes
 1. Never come with a initializer
 2. Can create subclasses (Inheritance). Child classes can override parent methods. Inheritance can be blocked by "final"
 3. Class copies are references, changing the original changes the copy. Structs are value-types, changing the copy does not affect the original
 4. Classes can have a deinitializer - code that is run when it is destroyed
 5.
 */

// Example 1: Classes must be given a custom intializer
class Animal {
    var name: String
    var age: Int
    
    init(name: String, age: Int){
        self.name = name
        self.age = age
    }
    
    func makeNoise() {
        print("Roarrr")
    }
}

let someAnimal = Animal(name: "Poppy", age: 1)

// Example 2: Classes can be inhertited
class Dog : Animal {
    var breed: String
    
    init(name: String, age: Int, breed: String){
        self.breed = breed
        super.init(name: name, age: age)
    }
    
    override func makeNoise() {
        print("Woof")
    }
}

let fido = Dog(name: "Fido", age: 2, breed: "Lab")

someAnimal.makeNoise()
fido.makeNoise()

final class Poodle : Dog {
    init(name: String, age: Int) {
        super.init(name: name, age: age, breed: "Poodle")
    }
}

let poodle = Poodle(name: "Jerry", age: 2)
poodle.breed
poodle.makeNoise()

// Example 3: Classes copy by reference
class Singer {
    var name: String
    init(name: String){
        self.name = name
    }
}
struct StructSinger {
    var name: String
}

var origSinger = Singer(name: "Taylor Swift")
var copySinger = origSinger
copySinger.name = "Beyonce"
origSinger.name
copySinger.name

var origStructSinger = StructSinger(name: "Taylor Swift")
var copyStructSinger = origStructSinger
copyStructSinger.name = "Beyonce"
origStructSinger.name
copyStructSinger.name

// Example 4: Classes can have deinitializers to run when instances are destroyed

class Rando {
    var name: String
    init(name:String){
        self.name = name
        print("\(name) was born")
    }
    deinit {
        print("\(name) has died")
    }
    
    func printGreeting(){
        print("Hello, I'm \(name)")
    }
    
}

for _ in 0...3 {
    var a = Rando(name: "John Doe")
    a.printGreeting()
}

// Example 5: Classes are mutable, even if declared as a constant. Use "let" to prevent property from changing
