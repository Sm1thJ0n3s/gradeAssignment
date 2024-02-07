//
//  main.swift
//  gradingStuff
//
//  Created by StudentAM on 1/29/24.
//

import Foundation
import CSV

var studentNames: [String] = []
var studentGrades: [[String]] = []
var finalGrades: [Double] = []

do{
    let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv")
    let csv = try CSVReader(stream: stream!)
    while let row = csv.next(){
        manageData(row: row)
    }
}
catch{
    print("! There was a change to the grades or an error in your file !")
    print("We'll shut down this program for a brief moment. Please try again or check upon the file you want to view if it has changed or corrupted.")
}


func manageData(row: [String]){
    var tempArray: [String] = []
    for i in row.indices {
        if i == 0 {
            studentNames.append(row[i])
        } else {
            tempArray.append(row[i])
        }
    }
    studentGrades.append(tempArray)
    calcFinalGrades(grades: tempArray)
}
func calcFinalGrades (grades: [String]) {
    var finalGrade: Double = 0.0
    for grade in grades {
        finalGrade += Double(grade)!
    }
    finalGrade = finalGrade / 10
    finalGrades.append(finalGrade)
}

var studentIndex: Int = 0
print(studentNames)
print(studentGrades)
print(finalGrades)


print("Hello Professor Gomez")
printTeacherInputs()

// Prints the options the teacher would want to do to check on the students.
func printTeacherInputs () {
    var userChoice: String = "0"
    // While loop will stop the program when the teacher chooses the exit the program.
    while userChoice != "6" {
        print("What would you like to do?")
        print("")
        print("1) Display grades") // Gives option to see grades of a student or all sutdents AND to see a grade or all grades.
        print("2) Find grade average") // Finds the grade average of the class of a selected assignment.
        print("3) Print lowest grade") // Prints the 5 lowest final grades.
        print("4) Print highest grade") // Prints the 5 highest final grades.
        print("5) Grade Range") // Displays the grades of each student that fits within the range.
        print("6) Quit") // Exit the program.
        print("")
        
        if let userInput = readLine() {
            teacherInputHandler(option: userInput)
            userChoice = userInput

        }
    }
}
// Handles with the inputs that the teacher gives to the program.
func teacherInputHandler(option: String) {
    if option == "Display" || option == "display" || option == "1" {
        display(student: "None", assignment: "None")
    } else if option == "Grade average" || option == "2" {
        gradeAverage(student: "None", assignment: "None")
    } else if option == "Lowest" || option == "Lowest grade" || option == "Grades to worry" || option == "3" {
        lowestFinalGrades()
    } else if option == "Highest" || option == "Highest grade" || option == "Least to worry" || option == "4" {
        highestFinalGrades()
    } else if option == "Grade range" || option == "Range" || option == "5" {
        gradeRange(minimum: "None", maximum: "None")
    } else if option == "Quit" || option == "quit" || option == "Leave" || option == "leave" || option == "Stop app" || option == "stop app" || option == "6" {
        quitProgram()
    } else {
        var responseToInvalid: Int = 0
        responseToInvalid = Int.random(in: 1...5)
        if responseToInvalid == 1 {
            print("Please input a valid option professor.")
        } else if responseToInvalid == 2 {
            print("The option you entered is not allowed.")
        } else if responseToInvalid == 3 {
            print("Please check your spelling before entering.")
        } else if responseToInvalid == 4 {
            print("Come on, you're a professor. Please type like one of the options.")
        } else if responseToInvalid == 5 {
            print("Read the options you are allowed to enter, please professor.")
        }
    }
}
// Displays student grades that is in the teacher's class.
func display (student: String, assignment: String) {
    if student == "None" {
        print("Which student would you like to view?")
        print("")
        
        if let userInput = readLine() {
            display(student: userInput, assignment: "None")
        }
    } else if (student == "All" || student == "all" || studentNames.contains(student)) && assignment == "None"{
        print("Which assignment would you like to see?")
        print("")
        
        if let userInput = readLine() {
            display(student: student, assignment: userInput)
        }
    } else if assignment != "None" {
        studentIndex = findStudentIndex(name: student)
        if student == "All" || student == "all" {
            if assignment == "All" || assignment == "all" {
                displayAllStudentsAssignments()
            } else if Int(assignment) != nil {
                displayAllStudentsAssignment(wantedAssignment: Int(assignment)!)
            } else {
                print("You did not enter an assignment or all the assignments. Please try again")
                display(student: student, assignment: "None")
            }
//            for i in studentNames.indices {
//
//            }
        } else {
            if assignment == "All" || assignment == "all" {
                print("Here are \(studentNames[studentIndex])'s grades")
                print (studentGrades[studentIndex])
            } else if Int(assignment) != nil {
                print("Here is \(studentNames[studentIndex])'s grade on assignment #\(assignment)")
                print(studentGrades[studentIndex][(assignment as NSString).integerValue - 1])
            } else {
                print("You did not enter an assignment or all the assignments. Please try again")
                display(student: student, assignment: "None")
            }
        }
    } else {
        print("ERROR: Student's entered name hasn't been found. Please enter a name in the files")
        print("")
        display(student: "None", assignment: "None")
    }
}
// A branching part of display function. This displays all the students' grades without an average.
func displayAllStudentsAssignments () {
    for i in studentNames.indices {
        print("")
        print(studentNames[i] + " ", terminator: "")
        for grade in studentGrades[i] {
            print(grade + ".0, ", terminator: "")
        }
    }
}
// Another branching part of display. This displays the grades of each student of a specific assignment.
func displayAllStudentsAssignment (wantedAssignment: Int) {
    let assignIndex: Int = wantedAssignment - 1
    var assignmentGrades: [Int] = []
    for row in studentGrades {
        assignmentGrades.append(Int(row[assignIndex])!)
    }
    print("Assignment #\(wantedAssignment)'s class grades: \(assignmentGrades)")
}
// Looks for the index of the student. Mainly used for finding the name of the student
func findStudentIndex (name: String) -> Int {
    var ith: Int = 0
    for i in studentNames.indices {
        if name.lowercased() == studentNames[i].lowercased() {
            ith = i
        }
    }
    return ith
}
// Displays the average of either grades of the assignment or grades of the entire class (final grades, then class grade average)
func gradeAverage (student: String, assignment: String) {
    if student == "None" {
        print("Enter a student's name below:")
        
        if let userInput = readLine() {
            gradeAverage(student: userInput, assignment: "None")
        }
    } else if (student == "All" || student == "all" || studentNames.contains(student)) && assignment == "None" {
        print("Please enter a number greater than zero to view to average grade of assignments")
        print("")
        
        if let userInput = readLine() {
            gradeAverage(student: student, assignment: userInput)
        }
    } else if assignment != "None" {
        let studentIndex = findStudentIndex(name: student)
        // If statements are similar to display function.
        if student == "All" || student == "all" {
            if assignment == "All" || assignment == "all" {
                displayAllFinalGrades()
                classAverage()
            } else if Int(assignment) != nil {
                avgClassAssignmentGrade(assignment: Int(assignment)!)
            } else {
                print("ERROR: The assignment you were asking for was not indentified. Please enter a number to view an assignment")
                gradeAverage(student: student, assignment: "None")
            }
        } else {
            if assignment == "All" || assignment == "all" {
                print("Here is \(studentNames[studentIndex])'s final grade: \(finalGrades[studentIndex])")
            } else if Int(assignment) != nil {
                print("Although available to do this similarly in the display grades function, here is \(studentNames[studentIndex])'s grade:")
                print("Requested grade view: \(studentGrades[studentIndex])")
            } else {
                print("ERROR: The assignment you were asking for was not indentified. Please enter a number to view an assignment")
                gradeAverage(student: student, assignment: "None")
            }
        }
    } else {
        print("ERROR: Student's entered name isn't found. Please enter a name recorded in the files")
        gradeAverage(student: "None", assignment: "None")
    }
}
// The class average branch of gradeAverage. Activates when all of the students' final grades are wanted to be display.
func classAverage () {
    var sum: Double = 0.0
    for grade in finalGrades {
        sum += grade
    }
    let classAvg = sum / Double(studentNames.count)
    print("This is the class average final grades: \(String(format:"%.1f", classAvg))")
}
// Displays the final grades of all students. That's what it actually does.
// Another branching part to gradeAverage, comes before the classAverage due to the teacher wanting the entire grades of students which will round it all up to final grades.
func displayAllFinalGrades () {
    for i in studentNames.indices {
        print(String(studentNames[i]) + "'s final grades: " + String(finalGrades[i]))
    }
}
// Another branching part of gradeAverage. This takes the assignment grades of each student and averages it out.
func avgClassAssignmentGrade (assignment: Int) {
    let assignIndex: Int = assignment - 1
    var sum: Int = 0
    for row in studentGrades {
        sum += Int(row[assignIndex])!
    }
    let assignmentAvg: Double = Double(sum) / Double(studentNames.count)
    print("This is the class average of assignment #\(assignment): \(String(format:"%.1f", assignmentAvg))")
}
// Displays the 5 lowest final grades in the whole class
func lowestFinalGrades () {
    var lowestFinalGrade: Double = 100
    var lowestGradeName: String = ""
    
    var secondLowest: Double = 100
    var secondLowestName: String = ""
    
    var thirdLowest: Double = 100
    var thirdLowestName: String = ""
    
    var fourthLowest: Double = 100
    var fourthLowestName: String = ""
    
    var fifthLowest: Double = 100
    var fifthLowestName: String = ""
    
    var name: String = ""
    var gradeIndex: Int = 0
    
    for finalGrade in finalGrades {
        for i in finalGrades.indices {
            if i == gradeIndex {
                name = studentNames[i]
            }
        }
        gradeIndex += 1
        
        if Double(finalGrade) < fifthLowest {
            if Double(finalGrade) < fourthLowest {
                if Double(finalGrade) < thirdLowest {
                    if Double(finalGrade) < secondLowest {
                        if Double(finalGrade) < lowestFinalGrade {
                            fifthLowest = fourthLowest
                            fifthLowestName = fourthLowestName
                            
                            fourthLowest = thirdLowest
                            fourthLowestName = thirdLowestName
                            
                            thirdLowest = secondLowest
                            thirdLowestName = secondLowestName
                            
                            secondLowest = lowestFinalGrade
                            secondLowestName = lowestGradeName
                            
                            lowestFinalGrade = Double(finalGrade)
                            lowestGradeName = name
                        } else {
                            fifthLowest = fourthLowest
                            fifthLowestName = fourthLowestName
                            
                            fourthLowest = thirdLowest
                            fourthLowestName = thirdLowestName
                            
                            thirdLowest = secondLowest
                            thirdLowestName = secondLowestName
                            
                            secondLowest = Double(finalGrade)
                            secondLowestName = name
                        }
                    } else {
                        fifthLowest = fourthLowest
                        fifthLowestName = fourthLowestName
                        
                        fourthLowest = thirdLowest
                        fourthLowestName = thirdLowestName
                        
                        thirdLowest = Double(finalGrade)
                        thirdLowestName = name
                    }
                } else {
                    
                    fifthLowest = fourthLowest
                    fifthLowestName = fourthLowestName
                    
                    fourthLowest = Double(finalGrade)
                    fourthLowestName = name
                }
            } else {
                fifthLowest = Double(finalGrade)
                fifthLowestName = name
            }
        }
    }
    print("Top 5 lowest final grades in the whole class: ")
    print("\(fifthLowestName)'s Final Grade: \(fifthLowest)")
    print("\(fourthLowestName)'s Final Grade: \(fourthLowest)")
    print("\(thirdLowestName)'s Final Grade: \(thirdLowest)")
    print("\(secondLowestName)'s Final Grade: \(secondLowest)")
    print("\(lowestGradeName)'s Final Grade: \(lowestFinalGrade)")
}

// Displays the 5 highest final grades in the whole class
func highestFinalGrades () {
    var highestFinalGrade: Double = 0
    var highestGradeName: String = ""
    
    var secondHighest: Double = 0
    var secondHighestName: String = ""
    
    var thirdHighest: Double = 0
    var thirdHighestName: String = ""
    
    var fourthHighest: Double = 0
    var fourthHighestName: String = ""
    
    var fifthHighest: Double = 0
    var fifthHighestName: String = ""
    
    var name: String = ""
    var gradeIndex: Int = 0
    
    for finalGrade in finalGrades {
        for i in finalGrades.indices {
            if i == gradeIndex {
                name = studentNames[i]
            }
        }
        gradeIndex += 1
            
        if Double(finalGrade) > fifthHighest {
            if Double(finalGrade) > fourthHighest {
                if Double(finalGrade) > thirdHighest {
                    if Double(finalGrade) > secondHighest {
                        if Double(finalGrade) > highestFinalGrade {
                            fifthHighest = fourthHighest
                            fifthHighestName = fourthHighestName
                            
                            fourthHighest = thirdHighest
                            fourthHighestName = thirdHighestName
                            
                            thirdHighest = secondHighest
                            thirdHighestName = secondHighestName
                            
                            secondHighest = highestFinalGrade
                            secondHighestName = highestGradeName
                            
                            highestFinalGrade = Double(finalGrade)
                            highestGradeName = name
                        } else {
                            fifthHighest = fourthHighest
                            fifthHighestName = fourthHighestName
                            
                            fourthHighest = thirdHighest
                            fourthHighestName = thirdHighestName
                            
                            thirdHighest = secondHighest
                            thirdHighestName = secondHighestName
                            
                            secondHighest = Double(finalGrade)
                            secondHighestName = name
                        }
                    } else {
                        fifthHighest = fourthHighest
                        fifthHighestName = fourthHighestName
                        
                        fourthHighest = thirdHighest
                        fourthHighestName = thirdHighestName
                        
                        thirdHighest = Double(finalGrade)
                        thirdHighestName = name
                    }
                } else {
                    fifthHighest = fourthHighest
                    fifthHighestName = fourthHighestName
                    
                    fourthHighest = Double(finalGrade)
                    fourthHighestName = name
                }
            } else {
                fifthHighest = Double(finalGrade)
                fifthHighestName = name
            }
        }
    }
    print("Top 5 higest final grades in the whole class: ")
    print("\(fifthHighestName)'s Final Grade: \(fifthHighest)")
    print("\(fourthHighestName)'s Final Grade: \(fourthHighest)")
    print("\(thirdHighestName)'s Final Grade: \(thirdHighest)")
    print("\(secondHighestName)'s Final Grade: \(secondHighest)")
    print("\(highestGradeName)'s Final Grade: \(highestFinalGrade)")
}
// Displays grades that is within the minimum and maximum grade ranges
// Purposely set the inRangeGrades as a 2D Array. This helps identify what grades belongs to who.
func gradeRange (minimum: String, maximum: String) {
    if minimum == "None" {
        print("Please input a number for the minimum range.")
        print("")
        
        if let userInput = readLine() {
            gradeRange(minimum: userInput, maximum: "None")
        }
    } else if maximum == "None" {
        print("Now enter a number for the maximum range.")
        print("")
        
        if let userInput = readLine() {
            gradeRange(minimum: minimum, maximum: userInput)
        }
    } else {
        if (Int(minimum) == nil) {
            print("ERROR: there has been a problem with what you've inputted as your minimum. Please re-input the numbers you wanna enter in.")
            
            gradeRange(minimum: "None", maximum: maximum)
        }
        if (Int(maximum) == nil) {
            print("ERROR: there has been a problem with what you've inputted as your maximum. Please re-input the numbers you wanna enter in.")
            
            gradeRange(minimum: minimum, maximum: "None")
        }
        
        gradeRangeData(min: Int(minimum)!, max: Int(maximum)!)
    }
}
// Second part of the gradeRange function which loops until the end of the row of grades.
// Then appends the tempArrayHolder into the inRangeGrades to show which grades belongs to who that is in the range the teacher puts in.
func gradeRangeData (min: Int, max: Int) {
    var inRangeGrades: [[String]] = []
    for row in studentGrades {
        var tempArrayHolder: [String] = []
        for grade in row {
            if Int(grade)! > min && Int(grade)! < max {
                tempArrayHolder.append(grade)
            }
        }
        inRangeGrades.append(tempArrayHolder)
        
    }
    print(inRangeGrades)
}
// Quits the program. Simple as that. Unless...
func quitProgram () {
    print("Very well then.")
    print("We will meet again for these grade Professor Gomez.")
    print("Please, have a good time here and with the students.")
    
}
