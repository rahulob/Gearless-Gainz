//
//  ExerciseImage.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 18/08/24.
//

import SwiftUI

struct ExerciseImage: View {
    var photoData: Data?
    var imageSize: CGFloat? = 48
    var iconSize: CGFloat?
    
    var body: some View {
        if let imageData = photoData, let uiImage = UIImage(data: imageData){
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        else{
            Image(systemName: "dumbbell")
                .font(.system(size: iconSize ?? 24))
                .rotationEffect(.degrees(45))
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .background(Color.accentColor.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    ExerciseImage()
}
