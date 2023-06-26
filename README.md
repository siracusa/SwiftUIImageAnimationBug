# FB12265182 SwiftUI Image Animation Bug

The Xcode Playground in this repository demonstrates a SwiftUI animation bug.
The bug has been filed with Apple as FB12265182.

<p align="center">
<img src="https://raw.githubusercontent.com/siracusa/SwiftUIImageAnimationBug/main/playground-screenshot.png" alt="Playground screenshot">
</p>

The “Animate” button makes the middle item appear and disappear by applying an
animation to a state change that sets the .frame() width and height of an
Image() to 0 or 100. The “Toggle” button changes the image from a heart to a
computer.

When the image is Image(systemName: …) it works as expected, scaling the heart
up and down in size without moving the center of the image.

In macOS 14.0 Beta (23A5257q), when the image is Image(nsImage: …), the arrival
animation is correct, scaling up from zero to full size. But the departure
animation shows TWO separate animations running at the same time: a fade out and
scale down, and a fade out and move to the right.

In macOS 13.4 (22F66), when the image is Image(nsImage: …), the arrival
animation shows a fade in, with no scaling, and the departure animation shows a
fade out, with no scaling.

The bugs, as I see them:

1. On both macOS 13.4 (22F66) and macOS 14.0 Beta (23A5257q), Image(systemName:
…) and Image(nsImage: …) are animated differently when everything else
surrounding them is exactly the same. (I believe the animation of the
Image(systemName: …) heart shows the correct, expected behavior when animating a
.frame() change to and from zero.)

2. On macOS 14.0 Beta (23A5257q), two different animations appear when an
Image(nsImage: …) is departing.

3. The animation of the Image(nsImage: …) is different in macOS 13.4 (22F66) and
macOS 14.0 Beta (23A5257q).

Removing the .opacity(1.0) modifier on the Image(…) corrects the behavior. This
is quite strange, since the modifier is being passed a constant value! I'm not
sure why this causes the animation problems, but it does.

In my actual app where I have this problem, removing every opacity() modifier
still does not avoid the bug, so the true cause must be a bit more complicated.

