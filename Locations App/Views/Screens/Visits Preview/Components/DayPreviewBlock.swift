import SwiftUI

struct DayPreviewBlock: View {
    @State private var visitIndex = 0
    @State private var timer: Timer?
    @Binding var currentDayComponent: DateComponents
    @Binding var isPreviewActive: Bool
    let visits: [Visit]
    let isFilled: Bool
    let dayComponent: DateComponents
    
    private var range: Range<Int> {
        return visitIndex ..< ((visitIndex + 3 > visits.count) ? visits.count : visitIndex + 3)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
            visitsPreviewList
        }
        .onAppear(perform: determineAndSetAppropriateTimerState)
        .onTapGesture(perform: setCurrentDayComponentAndPreviewInactive)
    }
}

// MARK: - Helper Functions
private extension DayPreviewBlock {
    private func setCurrentDayComponentAndPreviewInactive() {
        setPreviewInactive()
        setCurrentDayComponent()
    }
    
    private func setCurrentDayComponent() {
        currentDayComponent = dayComponent
    }
    
    private func setPreviewInactive() {
        isPreviewActive = false
    }
}

// MARK: - Timer
private extension DayPreviewBlock {
    private func determineAndSetAppropriateTimerState() {
        if isPreviewActive {
            setTimerForVisitsSlideshow()
        } else {
            invalidateTimerForVisitsSlideshow()
        }
    }
    
    private func invalidateTimerForVisitsSlideshow() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setTimerForVisitsSlideshow() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            withAnimation {
                self.onTimerFire()
            }
        }
    }
    
    private func onTimerFire() {
        adjustDisplayedVisitsInPreview()
    }
    
    private func adjustDisplayedVisitsInPreview() {
        shiftPreviewVisitIndex()
    }
    
    private func shiftPreviewVisitIndex() {
        let visitIndexExists = self.visitIndex < self.visits.count-3
        if visitIndexExists {
            self.visitIndex += 3
        } else {
            self.visitIndex = 0
        }
    }
}

// MARK: - Content
private extension DayPreviewBlock {
    private var backgroundColor: some View {
        Color("salmon").saturation(isFilled ? 2 : 1)
    }
    
    private var visitsPreviewList: some View {
        V0Stack {
            ForEach(visits[range]) { visit in
                VisitPreviewCell(visit: visit)
            }
        }
        .animation(.easeInOut)
    }
}

struct DayPreviewBlock_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayPreviewBlock(currentDayComponent: .constant(DateComponents()), isPreviewActive: .constant(true), visits: [], isFilled: false, dayComponent: DateComponents())
        }
    }
}