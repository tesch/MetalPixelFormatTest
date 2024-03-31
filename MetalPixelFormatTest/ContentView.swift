//
// ContentView.swift
//
// Created by Marcel Tesch on 2024-03-30.
// Think different.
//

import SwiftUI

struct ContentView: View {

    @State private var colorSpaceIdentifier: ColorSpaceIdentifier = .sRGBLinear

    var body: some View {
        VStack(spacing: 20) {
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
            .frame(width: 250)

            SideBySideComparisonView(colorSpaceIdentifier: colorSpaceIdentifier)
        }
    }

}

private struct SideBySideComparisonView: View {

    let colorSpaceIdentifier: ColorSpaceIdentifier

    var body: some View {
        HStack(spacing: 20) {
            // Looks correct.
            SwatchView(colorSpaceIdentifier: colorSpaceIdentifier, pixelFormat: .bgra8Unorm)

            // Unequally distributed rounding errors.
            SwatchView(colorSpaceIdentifier: colorSpaceIdentifier, pixelFormat: .rgba16Float)
        }
    }

}

private struct SwatchView: View {

    let colorSpaceIdentifier: ColorSpaceIdentifier
    let pixelFormat: MTLPixelFormat

    var body: some View {
        VStack {
            RenderTestView(colorSpaceIdentifier: colorSpaceIdentifier, pixelFormat: pixelFormat)
                .frame(width: 200, height: 200)

            Text(pixelFormat.description)
                .monospaced()
        }
    }

}
