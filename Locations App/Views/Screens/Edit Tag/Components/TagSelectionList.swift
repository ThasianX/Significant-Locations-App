import SwiftUI

struct TagSelectionList: View {
    let tags: [Tag]
    let location: Location?
    let onTap: (Tag) -> Void
    let onEdit: (Tag) -> Void
    let onDelete: (Tag) -> Void
    
    var body: some View {
        VScroll {
            VStack {
                ForEach(tags) { tag in
                    ColoredTextRow(text: tag.name, color: tag.uiColor, selected: self.location?.tag == tag)
                        .background(Color.clear)
                        .padding(8)
                        .onTapGesture {
                            self.onTap(tag)
                        }
                        .contextMenu {
                            self.contextMenu(for: tag)
                    }
                }
            }
        }
    }
    
}

private extension TagSelectionList {
    private func contextMenu(for tag: Tag) -> TagContextMenu {
        TagContextMenu(tag: tag, onEdit: onEdit, onDelete: onDelete)
    }
}

struct TagSelectionList_Previews: PreviewProvider {
    static var previews: some View {
        TagSelectionList(tags: [.preview], location: .preview, onTap: { _ in }, onEdit: { _ in }, onDelete: { _ in })
    }
}
