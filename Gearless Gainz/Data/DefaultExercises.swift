//
//  DefaultExercises.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 14/08/24.
//

import Foundation

let DefaultExercises: [Exercise] = [
    // Chest
    Exercise(name: "Cable Crossovers", targetMuscle: .chest, note: "Stand between two cable machines and pull the handles together in front of you."),
    Exercise(name: "Bench Press", targetMuscle: .chest, note: "Lie on a flat bench and press the barbell upwards."),
    Exercise(name: "Dumbbell Press", targetMuscle: .chest, note: "Lie on a flat bench and press the dumbbells upwards."),
    Exercise(name: "Incline Bench Press", targetMuscle: .chest, note: "Lie on an inclined bench and press the barbell upwards."),
    Exercise(name: "Incline Dumbbell Press", targetMuscle: .chest, note: "Lie on an inclined bench and press dumbbells upwards."),
    Exercise(name: "Machine Flies", targetMuscle: .chest, note: "Sit on a machine and bring the handles together in front of you, keeping your arms slightly bent and your chest up at all time."),
    Exercise(name: "Dumbbell Flies", targetMuscle: .chest, note: "Lie on a flat bench and open and close your arms with dumbbells in a hugging motion."),
    Exercise(name: "Incline Dumbbell Flies", targetMuscle: .chest, note: "Lie on an inclined bench and open and close your arms with dumbbells in a hugging motion."),
    Exercise(name: "Decline Bench Press", targetMuscle: .chest, note: "Lie on a declined bench and press the barbell upwards."),
    Exercise(name: "Decline Dumbbell Flies", targetMuscle: .chest, note: "Lie on a declined bench and open and close your arms with dumbbells in a hugging motion."),
    Exercise(name: "Decline Dumbbell Press", targetMuscle: .chest, note: "Lie on a declined bench and press dumbbells upwards."),
    Exercise(name: "Smith Machine Bench Press", targetMuscle: .chest, note: "Lie on a flat bench and press the barbell upwards using the Smith machine."),
    Exercise(name: "Smith Machine Incline Bench Press", targetMuscle: .chest, note: "Lie on an inclined bench and press the barbell upwards using the Smith machine."),
    
    // Back
    Exercise(name: "Lat Pulldown", targetMuscle: .back, note: "Sit at a lat pulldown machine and pull the bar down towards your chest."),
    Exercise(name: "Close Grip Lat Pulldown", targetMuscle: .back, note: "Sit at a lat pulldown machine with a close grip and pull the bar down towards your chest."),
    Exercise(name: "Single Hand Cable Lat Pulldown", targetMuscle: .back, note: "Sit at a cable machine and pull the handle down towards your chest one hand at a time."),
    Exercise(name: "Bent Over Rows", targetMuscle: .back, note: "Bend at the waist and pull a barbell or dumbbells towards your torso."),
    Exercise(name: "V-Bar Row", targetMuscle: .back, note: "Sit at a cable row machine with a V-bar handle and pull the handle towards your torso."),
    Exercise(name: "Seated Cable Row (V-Bar)", targetMuscle: .back, note: "Sit at a cable row machine with a V-bar handle and pull the handle towards your torso."),
    Exercise(name: "Smith Machine Rows", targetMuscle: .back, note: "Bend over and pull the barbell towards your torso using the Smith machine."),
    Exercise(name: "Dumbbell Rows", targetMuscle: .back, note: "Place one knee and hand on a bench and row a dumbbell towards your torso with the other hand."),
    Exercise(name: "Deadlift", targetMuscle: .back, note: "Lift a barbell from the ground to hip level while keeping your back straight."),
    Exercise(name: "Pull Ups", targetMuscle: .back, note: "Hang from a bar with an overhand grip and pull your body up until your chin is above the bar."),
    Exercise(name: "Pullovers (Rod)", targetMuscle: .back, note: "Slightly lean forward and pull the weight from above your head towards your torso"),
    Exercise(name: "Pullovers (Rope)", targetMuscle: .back, note: "Slightly lean forward and pull the weight from above your head towards your torso"),

    // Legs
    Exercise(name: "Barbell Squat", targetMuscle: .legs, note: "Stand with your feet shoulder-width apart, place a barbell on your shoulders, and squat down by bending your knees and hips, then return to standing."),
    Exercise(name: "Smith Machine Squat", targetMuscle: .legs, note: "Stand with your feet shoulder-width apart under a barbell on the Smith machine, and squat down by bending your knees and hips, then return to standing."),
    Exercise(name: "Leg Press", targetMuscle: .legs, note: "Sit on a leg press machine and push the platform away from you using your feet, then return to the starting position."),
    Exercise(name: "Leg Extension", targetMuscle: .legs, note: "Sit on a leg extension machine and extend your legs until they are straight, then lower them back to the starting position."),
    Exercise(name: "Laying Leg Curls", targetMuscle: .legs, note: "Lie face down on a leg curl machine and curl your legs up towards your glutes, then return to the starting position."),
    Exercise(name: "Hack Squats", targetMuscle: .legs, note: "Stand on a hack squat machine with your shoulders under the pads, and squat down by bending your knees and hips, then return to standing."),
    Exercise(name: "Romanian Deadlift", targetMuscle: .legs, note: "Stand with a barbell in front of you, hinge at your hips to lower the barbell down while keeping your legs slightly bent, then return to standing."),
    Exercise(name: "Good Morning", targetMuscle: .legs, note: "Stand with a barbell on your shoulders, hinge at your hips to lower your torso while keeping your back straight, then return to standing."),
    Exercise(name: "Hip Thrusts", targetMuscle: .legs, note: "Sit on the floor with your upper back against a bench, place a barbell over your hips, and thrust your hips up towards the ceiling, then lower them back down."),
    Exercise(name: "Lunges", targetMuscle: .legs, note: "Step forward with one leg and lower your body until both knees are bent at about 90 degrees, then push back to the starting position."),
    Exercise(name: "Bulgarian Split Squats", targetMuscle: .legs, note: "Place one foot behind you on a bench and squat down with the other leg until your thigh is parallel to the ground, then return to standing."),

    // Shoulders
    Exercise(name: "Seated Dumbbell Press", targetMuscle: .shoulders, note: "Sit on a bench with back support, hold dumbbells at shoulder height, and press them upward until your arms are fully extended."),
    Exercise(name: "Seated Machine Press", targetMuscle: .shoulders, note: "Sit on a shoulder press machine, adjust the seat and handles to shoulder height, and press the handles upward."),
    Exercise(name: "Dumbbell Front Raises", targetMuscle: .shoulders, note: "Stand with a dumbbell in each hand, arms extended in front of you, and lift the dumbbells to shoulder height, then lower them back down."),
    Exercise(name: "Dumbbell Lateral Raises", targetMuscle: .shoulders, note: "Stand with a dumbbell in each hand, arms by your sides, and lift the dumbbells out to the sides until they reach shoulder height."),
    Exercise(name: "Single Hand Dumbbell Lateral Raise", targetMuscle: .shoulders, note: "Stand with one dumbbell in one hand, arm by your side, and lift the dumbbell out to the side until it reaches shoulder height."),
    Exercise(name: "Cable Lateral Raises", targetMuscle: .shoulders, note: "Stand next to a cable machine with the handle at the lowest setting, grasp the handle with one hand, and lift it out to the side until it reaches shoulder height."),
    Exercise(name: "Single Hand Cable Lateral Raises", targetMuscle: .shoulders, note: "Stand next to a cable machine, grasp the handle with one hand, and lift it out to the side until it reaches shoulder height."),
    Exercise(name: "Y Raises", targetMuscle: .shoulders, note: "Hold light dumbbells in each hand, bend forward at the hips, and raise your arms in a Y shape to shoulder height."),
    Exercise(name: "Reverse Y Raises", targetMuscle: .shoulders, note: "Hold light dumbbells in each hand, bend forward at the hips, and raise your arms in a reverse Y shape to shoulder height."),
    Exercise(name: "Rear Delt Machine Fly", targetMuscle: .shoulders, note: "Sit on a rear delt fly machine, adjust the seat and handles, and perform a fly motion to target the rear deltoids."),
    Exercise(name: "Seated Bend Over Lateral Raise", targetMuscle: .shoulders, note: "Sit on the edge of a bench, bend forward, and lift dumbbells out to the sides to target the rear deltoids."),

    // Biceps
    Exercise(name: "Bicep Curls", targetMuscle: .biceps, note: "Curl a barbell or dumbbells towards your shoulders."),
    Exercise(name: "Hammer Curls", targetMuscle: .biceps, note: "Curl dumbbells with palms facing each other."),
    Exercise(name: "Preacher Curls", targetMuscle: .biceps, note: "Curl a barbell or dumbbells while resting your upper arms on a preacher bench."),

    // Triceps
    Exercise(name: "Tricep Dips", targetMuscle: .triceps, note: "Lower your body between two bars and push back up."),
    Exercise(name: "Tricep Pushdowns", targetMuscle: .triceps, note: "Push a weight down using a cable machine."),
    Exercise(name: "Overhead Tricep Extensions", targetMuscle: .triceps, note: "Extend a weight overhead and lower it behind your head."),

    // Forearms
    Exercise(name: "Dumbbell Wrist Curls", targetMuscle: .forearms, note: "Curl a dumbbells with your wrists."),
    Exercise(name: "Reverse Wrist Curls", targetMuscle: .forearms, note: "Curl a barbell with your palms facing down."),
    
    // Calves
    Exercise(name: "Calf Raises", targetMuscle: .calves, note: "Raise your heels off the ground while standing on the edge of a step."),
    Exercise(name: "Seated Calf Raises", targetMuscle: .calves, note: "Perform calf raises while seated, with weights on your knees."),
    Exercise(name: "Donkey Calf Raises", targetMuscle: .calves, note: "Perform calf raises while leaning forward with weights on your hips."),

    // Core
]
