//
//  ReactionAnimationView.swift
//  CoolWWDC23
//
//  Created by Pratik Gadhesariya on 07/06/23.
//

import SwiftUI

struct AnimationValues {
    var scale = 1.0
    var verticalStretch = 1.0
    var verticalTranslation = 0.0
    var angle = Angle.zero
}

enum Reaction: CaseIterable, Identifiable {
    case thumb
    case heart
    case clap
    
    var id: String { icon }
    
    var icon: String {
        switch self {
        case .thumb:
            return "hand.thumbsup.fill"
        case .heart:
            return "heart.fill"
        case .clap:
            return "hands.clap.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .thumb:
            return .blue
        case .heart:
            return .red
        case .clap:
            return .purple
        }
    }
}

struct ReactionAnimationView: View {
    @State private var selectedReaction: Reaction? = .thumb
    
    var body: some View {
        HStack {
            ForEach(Reaction.allCases) { reaction in
                ReactionVeiw(reaction: reaction, selectedReaction: selectedReaction)
                    .onTapGesture {
                        selectedReaction = reaction
                    }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(.thinMaterial, in: Capsule())
    }
    
    struct ReactionVeiw: View {
        var reaction: Reaction
        var selectedReaction: Reaction?
        @State private var animate = UUID()
        
        var body: some View {
            Image(systemName: reaction.icon)
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(reaction.color)
                .keyframeAnimator(initialValue: AnimationValues(),
                                  trigger: animate) { content, value in
                    content
                        .foregroundStyle(.red)
                        .rotationEffect(value.angle)
//                        .rotation3DEffect(
//                            value.angle,
//                            axis: (x: 0.0, y: 1.0, z: 0.0)
//                        )
                        .scaleEffect(value.scale)
                        .scaleEffect(y: value.verticalStretch)
                        .offset(y: value.verticalTranslation)
                    } keyframes: { _ in
                        KeyframeTrack(\.angle) {
                            CubicKeyframe(.zero, duration: 0.58)
                            CubicKeyframe(.degrees(16), duration: 0.125)
                            CubicKeyframe(.degrees(-16), duration: 0.125)
                            CubicKeyframe(.degrees(16), duration: 0.125)
                            CubicKeyframe(.zero, duration: 0.125)
//                            SpringKeyframe(.degrees(0), duration: 0.3)
//                            SpringKeyframe(.degrees(360*2), duration: 0.6)
//                            SpringKeyframe(.degrees(0), duration: 0.8)
                        }
 
                        KeyframeTrack(\.verticalStretch) {
                            CubicKeyframe(1.0, duration: 0.1)
                            CubicKeyframe(0.6, duration: 0.15)
                            CubicKeyframe(1.5, duration: 0.1)
                            CubicKeyframe(1.05, duration: 0.15)
                            CubicKeyframe(1.0, duration: 0.88)
                            CubicKeyframe(0.8, duration: 0.1)
                            CubicKeyframe(1.04, duration: 0.4)
                            CubicKeyframe(1.0, duration: 0.22)
                        }
                        
                        KeyframeTrack(\.scale) {
                            LinearKeyframe(1.0, duration: 0.36)
                            SpringKeyframe(1.5, duration: 0.8, spring: .bouncy)
                            SpringKeyframe(1.0, spring: .bouncy)
                        }

                        KeyframeTrack(\.verticalTranslation) {
                            LinearKeyframe(0.0, duration: 0.1)
                            SpringKeyframe(20.0, duration: 0.15, spring: .bouncy)
                            SpringKeyframe(-60.0, duration: 1.0, spring: .bouncy)
                            SpringKeyframe(0.0, spring: .bouncy)
                        }
                    }
                    .onChange(of: selectedReaction) { oldValue, newValue in
                        if let newValue, reaction == newValue {
                            animate = UUID()
                        }
                    }
        }
    }
}

#Preview {
    ReactionAnimationView()
}
