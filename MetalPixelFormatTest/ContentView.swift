//
// ContentView.swift
//
// Created by Marcel Tesch on 2024-03-30.
// Think different.
//

import SwiftUI

struct ContentView: View {

    @State private var value: CGFloat = 0.5
    @State private var colorSpaceIdentifier: ColorSpaceIdentifier = .sRGBLinear

    var body: some View {
        VStack(spacing: 20) {
            ConfigView(value: $value, colorSpaceIdentifier: $colorSpaceIdentifier)
            SideBySideComparisonView(value: value, colorSpaceIdentifier: colorSpaceIdentifier)
        }
        .padding(40)
    }

}

private struct ConfigView: View {

    @Binding var value: CGFloat
    @Binding var colorSpaceIdentifier: ColorSpaceIdentifier

    var body: some View {
        VStack(spacing: 10) {
            ValueConfigView(value: $value).disabled(true)
            ColorSpaceConfigView(colorSpaceIdentifier: $colorSpaceIdentifier)
        }
        .frame(width: 300)
    }

}

private struct ValueConfigView: View {

    @Binding var value: CGFloat

    var body: some View {
        HStack {
            Slider(value: $value, in: 0 ... 1) {
                Text("Value:")
            }

            let string = String(format: "%.2f", value)

            Text(string).monospacedDigit()
            Stepper(value: $value, in: 0 ... 1, step: 0.01) {  }
        }
    }

}

private struct ColorSpaceConfigView: View {

    @Binding var colorSpaceIdentifier: ColorSpaceIdentifier

    var body: some View {
        Picker(selection: $colorSpaceIdentifier) {
            Text("sRGB").tag(ColorSpaceIdentifier.sRGB)
            Text("Linear sRGB").tag(ColorSpaceIdentifier.sRGBLinear)

            Divider()

            Text("P3").tag(ColorSpaceIdentifier.displayP3)
            Text("Linear P3").tag(ColorSpaceIdentifier.displayP3Linear)

            Divider()

            Text("No Color Matching").tag(ColorSpaceIdentifier.noColorMatching)
        } label: {
            Text("Color space:")
        }
    }

}

private struct SideBySideComparisonView: View {

    let value: CGFloat
    let colorSpaceIdentifier: ColorSpaceIdentifier

    var body: some View {
        HStack(spacing: 20) {
            // Looks correct.
            SwatchView(value: value, colorSpaceIdentifier: colorSpaceIdentifier, pixelFormat: .bgra8Unorm)

            // Unequally distributed rounding errors.
//            SwatchView(value: value, colorSpaceIdentifier: colorSpaceIdentifier, pixelFormat: .rgba16Float)
        }
    }

}

private struct SwatchView: View {

    let value: CGFloat
    let colorSpaceIdentifier: ColorSpaceIdentifier
    let pixelFormat: MTLPixelFormat

    var body: some View {
        VStack {
            RenderTestView(value: value, colorSpaceIdentifier: colorSpaceIdentifier, pixelFormat: pixelFormat)
                .frame(width: 200, height: 200)

            Text(pixelFormat.description)
                .monospaced()
        }
    }

}
