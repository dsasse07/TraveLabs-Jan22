import UIKit

// A variable can be marked as optional by using ?

struct Person {
    var age: Int?
}

var missingString: String?
var string = "my string"
missingString
string

// Unwrap an optional to get the value without erroring
func printLength(someString: String?){
    if let unwrappedString = someString { // if someString exists, its value will be saved to a new var
        print(unwrappedString.count)
    } else {
        print("There is no string")
    }
}
printLength(someString: missingString)
printLength(someString: string)

// Unwrap with a guard let
// Allows you to deal with problems at the beginning of the function and then exit

func greet(_ name: String?){
    guard let unwrapped = name else {
        print("You didn't provide a name!")
        return
    }
    // This is the happy path if we pass the guard clause
    print("hello \(unwrapped)")
}

// Force unwrap - if we know for sure it isnt nil
let str = "5"
let num = Int(str) // This makes this an Int? bc Swift doesnt know fore sure it was convertable
let num2 = Int(str)! // ! will force the unwrap to Int. Will Crash the app if it fails. Use sparingly

// Implicitly unwrapping.  We dont need to unwrap them to use them. Created by using ! after its used
let age: Int! = nil // We are telling Swift that we guarantee age will be an Int value before it is used
// So we can use it without unwrapping. If we use it and it in nil, app will crash



// Nil coalescing
func username(for id: Int) -> String? {
    if id == 1{
        return "Taylor Swift"
    } else {
        return nil
    }
}
let username1 = username(for: 1) ?? "not found"
let username2 = username(for: 2) ?? "not found"


// Optional Chaining - Will be checked and unwrapped before continuing
username(for: 1)?.count
username(for: 2)?.count

// Optional try
enum PasswordError : Error {
    case obvious
}

func checkPassword(_ password: String) throws -> Bool {
    if password == "password"{
        throw PasswordError.obvious
    } else {
        return true
    }
}

if let result = try? checkPassword("password") {
    print("Result was \(result)")
} else {
    print("D'oh")
}

// Failable initializers - initializer might work, or might not. Retuns nil if it doesnt work
struct FailableStruct {
    var id: String
    init?(id: String){
        if (id.count == 9){
            self.id = id
        } else {
            return nil
        }
    }
}
let failed = FailableStruct(id: "abc")
let passed = FailableStruct(id: "123456789")


// Typecasting
class Animal {}
class Fish : Animal {}
class Dog : Animal {
    func makeNoise(){
        print("Woof!")
    }
}
// Swift can tell all of these inherit from Animal, so it makes this an array of animals
// We can use "as" to cast it to a Dog if possible, or nil if it can't
let pets = [Fish(), Dog(), Fish(), Dog()]
for pet in pets {
    if let dog = pet as? Dog {
        dog.makeNoise()
    }
}

