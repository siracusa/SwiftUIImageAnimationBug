import SwiftUI
import PlaygroundSupport

let bugExplanation = """
The “Animate” button above makes the middle item appear \
and disappear by applying an animation to a state change \
that sets the .frame() width and height of an Image() to \
0 or 100. The “Toggle” button changes the image from a \
heart to a computer.

When the image is Image(systemName: …) it works as expected, \
scaling the heart up and down in size without moving the \
center of the image.

In macOS 14.0 Beta (23A5257q), when the image is \
Image(nsImage: …), the arrival animation is correct, \
scaling up from zero to full size. But the departure animation \
shows TWO separate animations running at the same time: a \
fade out and scale down, and a fade out and move to the right.

In macOS 13.4 (22F66), when the image is \
Image(nsImage: …), the arrival animation shows a fade in, \
with no scaling, and the departure animation shows a fade \
out, with no scaling.

The bugs, as I see them:

1. On both macOS 13.4 (22F66) and macOS 14.0 Beta (23A5257q), \
Image(systemName: …) and Image(nsImage: …) are animated \
differently when everything else surrounding them is \
exactly the same. (I believe the animation of the \
Image(systemName: …) heart shows the correct, expected
behavior when animating a .frame() change to and from zero.)

2. On macOS 14.0 Beta (23A5257q), two different animations
appear when an Image(nsImage: …) is departing.

3. The animation of the Image(nsImage: …) is different in \
macOS 13.4 (22F66) and macOS 14.0 Beta (23A5257q).
"""

struct ContentView: View {
    @State var hidden = false
    @State var heart = true

    let image = NSImage(named: NSImage.computerName)!
    
    var body : some View {
        VStack(alignment: .center, spacing: 10) {
            Button("Toggle Image") {
                heart.toggle()
            }

            Button("Animate") {
                let scaleAnimation = Animation.easeInOut(duration: 2)
                
                withAnimation(scaleAnimation) {
                    hidden.toggle()
                }
            }

            ItemView(image: image, hidden: false, heart: heart)
            ItemView(image: image, hidden: hidden, heart: heart)
            ItemView(image: image, hidden: false, heart: heart)
        }
        .frame(
            width: 120,
            height: (120 * 3) + 40,
            alignment: .top
        )
        .padding(15)
        
        Text(bugExplanation)
            .font(.system(size: 14))
            .frame(width: 400)
    }
}
      
struct ItemView : View {
    let image : NSImage
    let hidden : Bool
    let heart : Bool
    
    var body : some View {
        let imageView = heart ?
            Image(systemName: "heart.fill") :
            Image(nsImage: image)

        return
            imageView
                .resizable()
                // Removing this opacity() modifier fixes the bug!
                // That seems strange to me because it's being passed
                // a constant value!
                .opacity(1.0)
                .frame(width: hidden ? 0 : 100 , height: hidden ? 0 : 100)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
