//
//  DefaultExercises.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 14/08/24.
//

import Foundation

let DefaultExercises: [Exercise] = [
    // Chest
    Exercise(name: "Bench Press", targetMuscle: .chest, note: "Lie on a flat bench and press the barbell upwards."),
    Exercise(name: "Incline Dumbbell Press", targetMuscle: .chest, note: "Press dumbbells upwards while lying on an inclined bench."),
    Exercise(name: "Chest Flyes", targetMuscle: .chest, note: "Open and close your arms while lying on a bench to stretch the chest muscles."),

    // Back
    Exercise(name: "Deadlift", targetMuscle: .back, note: "Lift the barbell from the ground to hip level."),
    Exercise(name: "Pull-Ups", targetMuscle: .back, note: "Pull your body up using a bar until your chin is above the bar."),
    Exercise(name: "Bent Over Rows", targetMuscle: .back, note: "Pull a barbell or dumbbells towards your waist while bending forward."),

    // Legs
    Exercise(name: "Squat", targetMuscle: .legs, note: "Lower your body as if you're sitting back into a chair."),
    Exercise(name: "Leg Press", targetMuscle: .legs, note: "Press a weighted platform away from your body using your legs."),
    Exercise(name: "Lunges", targetMuscle: .legs, note: "Step forward and lower your hips until both knees are bent at a 90-degree angle."),

    // Shoulders
    Exercise(name: "Overhead Press", targetMuscle: .shoulders, note: "Press a barbell or dumbbells overhead while standing or sitting."),
    Exercise(name: "Lateral Raises", targetMuscle: .shoulders, note: "Raise dumbbells to the side until your arms are parallel to the floor."),
    Exercise(name: "Front Raises", targetMuscle: .shoulders, note: "Lift dumbbells in front of you to shoulder height."),

    // Biceps
    Exercise(name: "Bicep Curls", targetMuscle: .biceps, note: "Curl a barbell or dumbbells towards your shoulders."),
    Exercise(name: "Hammer Curls", targetMuscle: .biceps, note: "Curl dumbbells with palms facing each other."),
    Exercise(name: "Preacher Curls", targetMuscle: .biceps, note: "Curl a barbell or dumbbells while resting your upper arms on a preacher bench."),

    // Triceps
    Exercise(name: "Tricep Dips", targetMuscle: .triceps, note: "Lower your body between two bars and push back up."),
    Exercise(name: "Tricep Pushdowns", targetMuscle: .triceps, note: "Push a weight down using a cable machine."),
    Exercise(name: "Overhead Tricep Extensions", targetMuscle: .triceps, note: "Extend a weight overhead and lower it behind your head."),

    // Forearms
    Exercise(name: "Wrist Curls", targetMuscle: .forearms, note: "Curl a barbell or dumbbells with your wrists."),
    Exercise(name: "Reverse Wrist Curls", targetMuscle: .forearms, note: "Curl a barbell or dumbbells with your palms facing down."),
    Exercise(name: "Farmer's Walk", targetMuscle: .forearms, note: "Carry heavy weights in each hand while walking."),

    // Glutes
    Exercise(name: "Hip Thrusts", targetMuscle: .glutes, note: "Thrust your hips upwards while resting your upper back on a bench."),
    Exercise(name: "Glute Bridges", targetMuscle: .glutes, note: "Lift your hips towards the ceiling while lying on your back with your knees bent."),
    Exercise(name: "Squats", targetMuscle: .glutes, note: "Squat down as described above, focusing on engaging your glutes."),
    
    // Calves
    Exercise(name: "Calf Raises", targetMuscle: .calves, note: "Raise your heels off the ground while standing on the edge of a step."),
    Exercise(name: "Seated Calf Raises", targetMuscle: .calves, note: "Perform calf raises while seated, with weights on your knees."),
    Exercise(name: "Donkey Calf Raises", targetMuscle: .calves, note: "Perform calf raises while leaning forward with weights on your hips."),

    // Core
    Exercise(name: "Planks", targetMuscle: .core, note: "Hold your body in a straight line, supported by your forearms and toes."),
    Exercise(name: "Russian Twists", targetMuscle: .core, note: "Rotate your torso side to side while holding a weight or medicine ball."),
    Exercise(name: "Bicycle Crunches", targetMuscle: .core, note: "Alternate bringing your elbows to your opposite knee while lying on your back."),

    // Full Body
    Exercise(name: "Burpees", targetMuscle: .fullBody, note: "Perform a squat, jump to a plank position, do a push-up, then jump back to a squat and stand up."),
    Exercise(name: "Kettlebell Swings", targetMuscle: .fullBody, note: "Swing a kettlebell between your legs and up to shoulder height."),
    Exercise(name: "Battle Ropes", targetMuscle: .fullBody, note: "Wave heavy ropes up and down or side to side to engage multiple muscle groups."),
]
