import UIKit

func day3(){
    let firstScore = 12
    let secondScore = 4
    
    let total = firstScore + secondScore
    let difference = firstScore - secondScore
    let product = firstScore * secondScore
    let dividend = firstScore / secondScore
    let remainer = firstScore % secondScore

    // operator overloading, meaning action depends on types that it is used with
    let firstNum = 10
    let total2 = firstNum + 5
    
    let str = "Hello"
    let str2 = "Goodbye"
    str + str2
    
    let arr1=["a", "b"]
    let arr2 = ["c","d"]
    arr1 + arr2
    
    
    //compound assignment
    var initial = 7
    initial += 10
    
    //Comparisons
    // <, >, <=, >=, ==, !=
    
    // Conditionals using comparisons & Combinations
    // && and ||
    
    // Ternary's also work, but are rare in swift
    
    // Switch. Will automatically terminate at the end of the case unless "fallthrough" is present
    let weather = "sunny"
    switch weather {
        case "rain":
            print("Bring an umbrella")
        case "snow":
            print("Dress warm")
        case "sunny":
            print("wear sunblock")
            fallthrough
        default:
            print("Enjoy the weather")
    }
    
    // Range operator - ... is inclusive, ..< is exclusive
    let score = 85
    switch score {
        case 0..<70:
            print("Study more")
        case 71...85:
            print("Ok")
        default:
            print("Good Job")
    }
    
}
day3()

// Loops
func day4(){
    let count = 1...10
    
    for number in count{
        print("The number is \(number)")
    }
    // if iteration number, or value not needed....
    for _ in count {
        print ("Shake it off")
    }
    
    // While loops
    var timer = 0
    while timer < 20 {
        print(timer)
        timer += 1
    }
    print("Here I Come!")
    
    // Repeat loop - runs atleast once
    var guessCount = 0
    repeat {
        print(guessCount)
        guessCount += 1
    } while guessCount < 1
                
    // Exit a loop early - use break
    var countDown = 10
    while countDown >= 0 {
        print(countDown)
        countDown -= 1
        if (countDown == 4){
            print("Im bored. Go Now")
            break
        }
    }
    
    // Break nested loops using break. "continue" skips current value
    outerloop: for i in 1...10{
        print("Outer")
            secondloop: for j in 1...10{
                print("second")
            thirdloop: for k in 1...10{
                let product = i * j
                if product == 50 {
                    print ("bullseye")
                    print("breaksecond")
                    break secondloop // regular break will break current loop, this breaks out at the named loop
                }
            }
        }
    }
}
day4()

// Functions
func day5(){
    func printHelp(){
        let message = """
            Welcome to MyApp!

            Run this app inside a directory of images and
            MyApp will resize them all into thumbnails
            """
        print(message)
    }
    printHelp()
    
    func printMessage(message: String){
        print(message)
    }
    printMessage(message: "Hello")
    
    func returnMessage(message: String) -> String {
        return "Your message is: \n \(message)"
    }
    returnMessage(message: "'Hello'")
    
    func returnMultipeValues(firstValue: Int, secondValue: Int) -> (sum: Int, dif: Int, prod: Int){
        let sum = firstValue + secondValue
        let dif = firstValue - secondValue
        let prod = firstValue * secondValue
        return (sum, dif, prod)
    }
    returnMultipeValues(firstValue: 10, secondValue: 20)
    
    // labelling params. First value is external label, second value is internal label
    func sayHello(to name: String, from sender: String){
        print("Hello \(name), from \(sender)")
    }
    sayHello(to: "Jenny", from: "Danny")
    
    // Removing labels
    func greet(_ name: String){
        print("Hello \(name)")
    }
    greet("James")
    
    // Default parameters
    func greetWithDefault(to name: String, type nicely: Bool = true){
        if nicely{
            print ("Hello \(name)")
        } else {
            print("What do you want \(name)")
        }
    }
    greetWithDefault(to: "Bubba")
    greetWithDefault(to: "Denver", type: false)
    
    
    // Variatic functions (accept an unknown number of the same type of param
    func squareInts(numbers: Int...){
        for num in numbers{
            print(num * num)
        }
    }
    squareInts(numbers: 2,3,4,5)
    
    // ERRORABLE FUNCTIONS
    enum PasswordError: Error {
        case obvious
    }
    
    func isOkPassword (potentialPassword password: String) throws -> Bool {
        if password == "password" {
            throw PasswordError.obvious
        } else {
            return true
        }
    }
    do {
        try isOkPassword(potentialPassword: "password")
    } catch PasswordError.obvious {
        print("Your Password is too obvious")
    } catch {
        print("Unknown Error")
    }
    do {
        try isOkPassword(potentialPassword: "somethingElse")
    } catch PasswordError.obvious {
        print("Your Password is too obvious")
    } catch {
        print("Unknown Error")
    }

    
    // InOut params - change the values directly rather than return new values
    // inout variable must be var, not constant
    // Called with an ampersand to show that it is knowingly being changed
    func doubleInPlace(number: inout Int){
        number *= 2
    }
    var myNum = 10
    doubleInPlace(number: &myNum)
}
day5()

// Closures functions can be passed around within variables
func day6(){
    // Creates anonymous function saved to driving variable
    let driving = {
        print("I am driving in my car")
    }
    driving()
    
    // Accepting parameters
    let drivingWithParams = {(place: String) in
        print("I am driving my car to \(place)")
    }
    drivingWithParams("London")
    
    // Returning values from closures
    let drivingWithReturn = {(place: String) -> String in
        return "I'm going to \(place)"
    }
    let resultString = drivingWithReturn("London")
    
    
    // Passing closures into functions
    let biking = {
        print("I'm riding my bike")
    }
    let flying = {
        print("I'm getting on the plane")
    }
    let travelling = {(action: () -> Void) -> Void in
        print("I am getting ready")
        action()
        print("I have arrived")
    }
    travelling(biking)
    travelling(flying)
    
    // Trailing closure syntax if closure is the last param
    func travel(action: () -> Void){
        print("I'm getting ready to go.")
        action()
        print("I have arrived!")
    }
    // Outer function is not invoked with (), but rather by a block with the closure
    travel{
        flying()
    }
}
day6()

//Advanced Closures
func day7(){
    // Passing params to closures
    func travel2(place: String, action: (String) -> Void) {
        print("I am going")
        action(place)
        print("I am done")
    }
    let blah = {(place: String) -> Void in
        print("Blahh, its \(place)")
    }
    travel2(place: "London", action: blah)
    
    // Force closure to return a value
    func travel3( action: (String) -> String ) {
        print("I am getting ready")
        let description = action("London")
        print(description)
        print("I have arrived")
    }
    let blah2 = {(place: String) -> String in
        return "The trip to \(place) was meh"
    }
    travel3 (action: blah2)
    
    //Shorthand parameter names since the arg & return type of closure is already known
    func travel4( action: (String) -> String) {
        print("I am getting ready to go")
        let description = action("London")
        print(description)
        print("I have arrived!")
    }
    travel4{ "I am going to \($0)" }
    
    //Closure with multiple parameters
    func travel5( place: String, speed: Int, action: (String, Int) -> String){
        print( "I am getting ready to go")
        let description = action(place, speed)
        print(description)
        print("I have arrived!")
    }
    travel5(place:"Germany", speed:200){ "I am going to \($0) at \($1)mph" }
    
    //Return a closure from a function
    func travel6(place: String, speed: Int) -> (String) -> Void {
        return {
            print("We will be going to \(place) at \(speed)mph. \($0)")
        }
    }
    let messageFactory = travel6(place: "France", speed: 100)
    messageFactory("All Aboard!!!!")
}
day7()
