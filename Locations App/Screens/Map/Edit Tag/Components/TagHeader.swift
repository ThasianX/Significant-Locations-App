import SwiftUI

struct TagHeader: View {
    @ObservedObject var tagState: TagCoreState

    let normalTagColor: Color
    var onSelect: ((Tag) -> Void)? = nil

    var body: some View {
        HStack {
            editTagHeaderView
            Spacer()
            editTagHeaderButtons
        }
        .padding(.horizontal)
    }

    private var editTagHeaderView: some View {
        HStack {
            tagImage

            ZStack(alignment: .leading) {
                headerText("TAGS")
                    .fade(if: tagState.isShowingAddOrEdit)
                headerText("MAKE TAG")
                    .fade(if: !tagState.operation.add)
                headerText("EDIT TAG")
                    .fade(if: !tagState.operation.edit)
            }
        }
        .animation(.easeInOut)
    }

    private var tagImage: some View {
        Image(systemName: "tag.fill")
            .foregroundColor(.white)
            .colorMultiply(tagState.isShowingAddOrEdit ? tagState.operation.selectedColor.color : normalTagColor)
    }

    private func headerText(_ text: String) -> some View {
        Text(text)
            .tracking(5)
            .font(.system(size: 20))
            .bold()
            .foregroundColor(.white)
    }

    private var editTagHeaderButtons: some View {
        ZStack {
            addButton
                .fade(if: tagState.isShowingAddOrEdit)
            HStack(spacing: 16) {
                xButton
                checkmarkButton
            }
            .fade(if: tagState.isntShowingAddNorEdit)
        }
        .animation(.easeInOut)
    }

    private var addButton: some View {
        BImage(perform: tagState.operation.beginAdd, image: Image(systemName: "plus"))
            .foregroundColor(.white)
    }

    private var xButton: some View {
        BImage(perform: onExit, image: Image(systemName: "xmark.circle.fill"))
            .foregroundColor(.red)
    }

    private func onExit() {
        if tagState.operation.add {
            tagState.operation.resetAdd()
        } else {
            tagState.operation.resetEdit()
        }
    }

    private var checkmarkButton: some View {
        BImage(perform: onCommit, image: Image(systemName: "checkmark.circle.fill"))
            .foregroundColor(.white)
            .colorMultiply(tagState.operation.selectedColor.color)
    }

    private func onCommit() {
        if tagState.operation.add {
            if let tagState = tagState as? AddNewTagState {
                tagState.addNewTag(onAdd: onSelect!)
            } else {
                tagState.addNewTag()
            }
        } else {
            tagState.editTag()
        }
    }
}

struct TagHeader_Previews: PreviewProvider {
    static var previews: some View {
        TagHeader(tagState: .init(), normalTagColor: .red, onSelect: {_ in})
    }
}
