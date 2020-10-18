//
//  ContentView.swift
//  SwiftUISceneKitDemo
//
//  Created by James Hillhouse IV on 10/17/20.
//

import SwiftUI
import SceneKit




struct ContentView: View {
    @State private var sunlightSwitch       = true
    @State private var cameraSwitch         = true
    @State private var povName              = "distantCamera"
    @State private var magnification        = CGFloat(1.0)
    @State private var isDragging           = false
    @State private var totalChangePivot     = SCNMatrix4Identity

    private var aircraftScene               = SCNScene(named: "art.scnassets/ship.scn")!

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.isDragging = true

                changeOrientation(of: aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!, with: value.translation)
            }
            .onEnded { value in
                self.isDragging = false

                updateOrientation(of: aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!)
            }
    }

    var magnify: some Gesture {
        MagnificationGesture()
            .onChanged{ (value) in
                print("magnify = \(self.magnification)")

                self.magnification = value

                changeCameraFOV(of: (self.aircraftScene.rootNode.childNode(withName: povName, recursively: true)?.camera)!,
                                value: self.magnification)
            }
            .onEnded{ value in
                print("Ended pinch with value \(value)\n\n")
            }
    }

    var exclusiveGesture: some Gesture {
        ExclusiveGesture(drag, magnify)
    }



    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            SceneView (
                scene: aircraftScene,
                pointOfView: aircraftScene.rootNode.childNode(withName: povName, recursively: true)
            )
            .gesture(exclusiveGesture)
            .onTapGesture(count: 2, perform: {
                resetOrientation(of: aircraftScene.rootNode.childNode(withName: "shipNode", recursively: true)!)
            })

            VStack() {
                Text("Hello, SwiftUI!").multilineTextAlignment(.leading).padding()
                    .foregroundColor(Color.gray)

                    .font(.largeTitle)

                Text("And SceneView too")
                    .foregroundColor(Color.gray)
                    .font(.title3)

                Spacer(minLength: 300)

                HStack (spacing: 5) {

                    Button( action: {
                        withAnimation{
                            self.sunlightSwitch.toggle()
                        }
                        let sunlight = self.aircraftScene.rootNode.childNode(withName: "sunlightNode", recursively: true)?.light

                        if self.sunlightSwitch == true {
                            sunlight!.intensity = 2000.0
                        } else {
                            sunlight!.intensity = 0.0
                        }
                    }) {
                        Image(systemName: sunlightSwitch ? "lightbulb.fill" : "lightbulb")
                            .imageScale(.large)
                            .accessibility(label: Text("Light Switch"))
                            .padding()
                    }

                    Button( action: {
                        withAnimation {
                            self.cameraSwitch.toggle()
                        }
                        if self.cameraSwitch == false {
                            povName = "shipCamera"
                        }
                        if self.cameraSwitch == true {
                            povName = "distantCamera"
                        }
                        print("\(povName)")
                    }) {
                        Image(systemName: cameraSwitch ? "video.fill" : "video")
                            .imageScale(.large)
                            .accessibility(label: Text("Camera Switch"))
                            .padding()
                    }
                }
            }
        }
        .statusBar(hidden: true)
    }



    private func changeOrientation(of node: SCNNode, with translation: CGSize) {
        let x = Float(translation.width)
        let y = Float(-translation.height)

        let anglePan = sqrt(pow(x,2)+pow(y,2)) * (Float)(Double.pi) / 180.0

        var rotationVector = node.rotation // SCNVector4()

        rotationVector.x = -y
        rotationVector.y = x
        rotationVector.z = 0
        rotationVector.w = anglePan

        node.rotation = rotationVector
    }



    private func updateOrientation(of node: SCNNode) {
        let currentPivot = node.pivot

        let changePivot = SCNMatrix4Invert(node.transform)

        totalChangePivot = SCNMatrix4Mult(changePivot, currentPivot)

        node.pivot = SCNMatrix4Mult(changePivot, currentPivot)

        node.transform = SCNMatrix4Identity
    }



    private func resetOrientation(of node: SCNNode) {
        let currentPivot    = node.pivot
        //print("currentPivot: \(currentPivot)")

        let changePivot     = SCNMatrix4Invert( totalChangePivot )
        //print("changePivot = \(changePivot)")

        node.pivot = SCNMatrix4Mult(changePivot, currentPivot)

        totalChangePivot    = SCNMatrix4Identity
    }



    private func changeCameraFOV(of camera: SCNCamera, value: CGFloat) {
        if self.magnification >= 1.025 {
            self.magnification = 1.025
        }
        if self.magnification <= 0.97 {
            self.magnification = 0.97
        }

        let maximumFOV: CGFloat = 25 // Zoom-in.
        let minimumFOV: CGFloat = 90 // Zoom-out.

        camera.fieldOfView /= magnification

        if camera.fieldOfView <= maximumFOV {
            camera.fieldOfView = maximumFOV
            self.magnification        = 1.0
        }
        if camera.fieldOfView >= minimumFOV {
            camera.fieldOfView = minimumFOV
            self.magnification        = 1.0
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
