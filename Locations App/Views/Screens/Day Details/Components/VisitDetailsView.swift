import SwiftUI

struct VisitDetailsView: View {
    @State private var mapFull = false
    @Binding var selectedIndex: Int
    let index: Int
    let visit: Visit
    
    var body: some View {
        ZStack(alignment: .top) {
            ScreenColor(.brown)
            VStack {
                locationNameText
                visitDurationText
                locationTagView
                visitNotesText
            }
            .background(Color(UIColor.salmon))
            .frame(width: isSelected.when(true: screen.bounds.width, false: screen.bounds.width - 100))
            .padding(.init(top: 10, leading: 40, bottom: 4, trailing: 40))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
        .onTapGesture(perform: setSelectedVisitIndex)
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
    }
}

// MARK: - Helper Functions
private extension VisitDetailsView {
    private func setSelectedVisitIndex() {
        withAnimation {
            self.selectedIndex = index
        }
    }
}

// MARK: - Content
private extension VisitDetailsView {
    private var locationNameText: some View {
        Text(visit.location.name)
            .font(nameFont)
            .fontWeight(nameWeight)
    }
    
    private var visitDurationText: some View {
        Text(visit.visitDuration)
            .font(visitDurationFont)
    }
    
    private var locationTagView: some View {
        TagView(tag: visit.location.tag, displayName: isSelected)
            .padding(.init(top: 6, leading: 0, bottom: 4, trailing: 0))
    }
    
    private var visitNotesText: some View {
        Text(visit.notes)
            .font(.caption)
            .multilineTextAlignment(.center)
            .lineLimit(3)
    }
    
    var header: some View {
        HStack {
            BImage(perform: unselectRow, image: .init(systemName: "arrow.left"))
            Spacer()
            BImage(perform: favorite, image: visit.isFavorite ? .init(systemName: "star.fill") : .init(systemName: "star"))
                .foregroundColor(.yellow)
        }
    }
    
    var map: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 20) {
                //                StaticMapView(coordinate: visit.location.coordinate, name: visit.location.name, color: color)
                //                    .frame(width: mapFull ? screen.bounds.width : screen.bounds.width / 2.5, height: mapFull ? screen.bounds.height * 3 / 4 : screen.bounds.width / 2.5)
                //                    .cornerRadius(mapFull ? 0 : screen.bounds.width / 5)
                //                    .onTapGesture {
                //                        withAnimation {
                //                            self.mapFull.toggle()
                //                        }
                //                    }
                //                    .animation(.spring())
                Text(visit.location.address.uppercased())
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 60, height: 3)
                    .opacity(mapFull ? 0 : 1)
                notes
                    .opacity(mapFull ? 0 : 1)
            }
            
            BImage(condition: $mapFull, image: .init(systemName: "arrow.left.circle.fill"))
                .scaleEffect(2.5)
                .opacity(mapFull ? 1 : 0)
                .allowsHitTesting(mapFull)
                .offset(x: 40, y: screen.bounds.height / 15)
                .animation(nil)
                .transition(.identity)
        }
    }
    
    var notes: some View {
        VStack(spacing: 2) {
            Text("NOTES")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .tracking(2)
            if visit.notes.isEmpty {
                Text("TAP TO ADD")
                    .font(.caption)
            }
        }
    }
}

// MARK: - Computed Properties and Helper Functions
extension VisitDetailsView {
    private var isSelected: Bool {
        selectedIndex == index
    }
    
    private var nameFont: Font {
        isSelected ? .system(size: 22) : .headline
    }
    
    private var nameWeight: Font.Weight {
        isSelected ? .bold : .regular
    }
    
    private var visitDurationFont: Font {
        isSelected ? .system(size: 18) : .system(size: 10)
    }
    
    private func unselectRow() {
        self.selectedIndex = -1
    }
    
    private func favorite() {
        visit.favorite()
    }
}

struct VisitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VisitDetailsView(selectedIndex: .constant(1), index: -1, visit: .preview).previewLayout(.sizeThatFits)
            
            VisitDetailsView(selectedIndex: .constant(1), index: 1, visit: .preview)
        }
        
    }
}
