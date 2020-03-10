import Mapbox
import SwiftUI

struct VisitsForDayView: View {
    @State private var activeVisitIndex: Int = -1
    @State var activeTranslation = CGSize.zero

    @Binding var currentDayComponent: DateComponents

    let visits: [Visit]
    let onBack: () -> Void
    let setActiveVisitLocationAndDisplayMap: (Visit) -> Void
    let setActiveRouteCoordinates: ([CLLocationCoordinate2D]) -> Void

    private var isShowingVisit: Bool {
        activeVisitIndex != -1
    }

    var body: some View {
        ZStack(alignment: .top) {
            header
            visitsForDayList
                .offset(y: !isShowingVisit ? 100 : 0)
        }
    }
}

private extension VisitsForDayView {
    private var header: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
                routeButton
            }
            dayLabel
        }
        .padding(30)
    }

    private var backButton: some View {
        BImage(perform: onBack, image: Image(systemName: "arrow.left"))
    }

    private var dayLabel: some View {
        DayLabel(date: currentDayComponent.date)
    }

    private var routeButton: some View {
        Button(action: convertAndSetActiveRouteCoordinates) {
            Image("route")
                .renderingMode(.template)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private func convertAndSetActiveRouteCoordinates() {
        setActiveRouteCoordinates(visits.map { $0.location.coordinate })
    }
}

private extension VisitsForDayView {
    private var visitsForDayList: some View {
        VScroll {
            makeVisitsStack
                .frame(width: screen.width)
                .padding(.bottom, 600)
                .animation(.spring())
        }
    }

    private var makeVisitsStack: some View {
        VStack(spacing: 2) {
            ForEach(0..<visits.count, id: \.self) { i in
                self.dynamicVisitRow(index: i)
                    .frame(height: VisitCellConstants.height)
                    .frame(maxWidth: VisitCellConstants.maxWidth(if: self.isShowingVisit))
            }
        }
    }

    private func dynamicVisitRow(index: Int) -> some View {
        GeometryReader { geometry in
            self.makeVisitDetailsView(index: index, visit: self.visits[index])
                .fade(if: self.isNotActiveVisit(at: index))
                .scaleEffect(self.isNotActiveVisit(at: index) ? 0.5 : 1)
                .offset(y: self.isShowingVisit ? self.topOfScreen(for: geometry) : 0)
        }
    }

    private func makeVisitDetailsView(index: Int, visit: Visit) -> some View {
        VisitDetailsView(
            selectedIndex: $activeVisitIndex,
            index: index,
            visit: visit,
            setActiveVisitLocationAndDisplayMap: setActiveVisitLocationAndDisplayMap
        )
        .id(visit.tagName)
        .id(visit.tagColor)
    }

    private func isNotActiveVisit(at index: Int) -> Bool {
        isShowingVisit && !isActiveVisitIndex(index: index)
    }

    private func isActiveVisitIndex(index: Int) -> Bool {
        index == activeVisitIndex
    }

    private func topOfScreen(for proxy: GeometryProxy) -> CGFloat {
        -proxy.frame(in: .global).minY
    }
}

struct VisitsForDayView_Previews: PreviewProvider {
    static var previews: some View {
        VisitsForDayView(currentDayComponent: .constant(Date().dateComponents), visits: Visit.previewVisitDetails, onBack: { },  setActiveVisitLocationAndDisplayMap: { _ in }, setActiveRouteCoordinates: { _ in })
            .environment(\.appTheme, .violetGum)
    }
}

