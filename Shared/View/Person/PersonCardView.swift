//
//  PersonCardView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 13/07/22.
//

import SwiftUI
import SDWebImageSwiftUI

/// This view is responsible for displaying a given person
/// in a card view, with its name, role, and image.
struct PersonCardView: View {
   let person: Person
   @State private var isFavorite: Bool = false
   init(person: Person) {
       self.person = person
   }
   var body: some View {
       VStack {
           WebImage(url: person.personImage)
               .resizable()
               .placeholder {
                   ZStack {
                       Rectangle().fill(.gray.gradient)
                       Image(systemName: "person")
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 50, height: 50, alignment: .center)
                           .foregroundColor(.white)
                       PersonNameCredits(person: person)
                   }
                   .frame(width: DrawingConstants.profileWidth,
                          height: DrawingConstants.profileHeight)
                   .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.profileRadius,
                                               style: .continuous))
               }
               .aspectRatio(contentMode: .fill)
               .frame(width: DrawingConstants.profileWidth,
                      height: DrawingConstants.profileHeight)
               .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.profileRadius,
                                           style: .continuous))
               .shadow(radius: DrawingConstants.shadowRadius)
               .overlay {
                   ZStack(alignment: .bottom) {
                       if person.personImage != nil {
                           Color.black.opacity(0.2)
                               .frame(height: 40)
                               .mask {
                                   LinearGradient(colors: [Color.black.opacity(0),
                                                           Color.black.opacity(0.383),
                                                           Color.black.opacity(0.707),
                                                           Color.black.opacity(0.924),
                                                           Color.black],
                                                  startPoint: .top,
                                                  endPoint: .bottom)
                               }
                           Rectangle()
                               .fill(.ultraThinMaterial)
                               .frame(height: 80)
                               .mask {
                                   VStack(spacing: 0) {
                                       LinearGradient(colors: [Color.black.opacity(0),
                                                               Color.black.opacity(0.383),
                                                               Color.black.opacity(0.707),
                                                               Color.black.opacity(0.924),
                                                               Color.black],
                                                      startPoint: .top,
                                                      endPoint: .bottom)
                                       .frame(height: 60)
                                       Rectangle()
                                   }
                               }
                           PersonNameCredits(person: person)
                       }
                       
                   }
                   .frame(width: DrawingConstants.profileWidth,
                          height: DrawingConstants.profileHeight)
                   .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.profileRadius,
                                               style: .continuous))
               }
               .transition(.opacity)
       }
       .contextMenu {
           ShareLink(item: person.itemURL)
       }
   }
}


private struct DrawingConstants {
    static let profileWidth: CGFloat = 140
    static let profileHeight: CGFloat = 200
    static let shadowRadius: CGFloat = 2.5
    static let profileRadius: CGFloat = 12
    static let lineLimit: Int = 1
}

private struct PersonNameCredits: View {
    let person: Person
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(person.name)
                    .font(.callout)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .lineLimit(DrawingConstants.lineLimit)
                    .padding(.leading, 6)
                Spacer()
            }
            HStack {
                Text(person.personRole ?? " ")
                    .foregroundColor(.white)
                    .font(.caption)
                    .lineLimit(DrawingConstants.lineLimit)
                    .padding(.leading, 6)
                Spacer()
            }
        }
        .padding(.bottom)
    }
}


struct PersonCardView_Previews: PreviewProvider {
    static var previews: some View {
        PersonCardView(person: Person.previewCast)
    }
}
