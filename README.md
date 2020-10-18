# SwiftUISceneKitDemo

On June 22, 2020 during the WWDC20 State of the Union, Apple announced that SwiftUI had been updated to include, among a great many other 
additions, SceneKit support. Specifically, SceneView was added as a View type, similar to SCNView. 

Unfortunately, there were no WWDC20 sessions on SceneKit or SceneView. This meant that those of us slower than most (I'm raising my hand here) 
experienced the very unpleasant experience of trying to figure out how to make SceneView work in all but the most rudementary of code. 
For example, how to implement changing a scene view's pointOfView? Or creating a gesture recognizer for pinch-to-zoom and dragging? How about a 
double-tap to reset the orientation of the scene view's scen model? What about turning lights on and off within the scene? 

When Xcode 12 was released, no project template existed for implementing SceneKit in SwiftUI. I can only assume that Apple's SceneKit team and 
most other Apple developers thought it so trivial to implement SceneView that a SwiftUI implementation of SceneView was thought unnecessary. For 
those of us, like I, for whom this is not the case, this demo app hopes to partly solve that. This app is modeled after the Xcode UIKit SceneKit 
template app using SwiftUI 2's SceneView.
