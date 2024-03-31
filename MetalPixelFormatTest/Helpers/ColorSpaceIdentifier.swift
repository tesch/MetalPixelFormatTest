//
// ColorSpaceIdentifier.swift
//
// Created by Marcel Tesch on 2024-03-31.
// Think different.
//

import QuartzCore

enum ColorSpaceIdentifier {

    case sRGB
    case sRGBLinear

    case displayP3
    case displayP3Linear

    case noColorMatching

}

extension ColorSpaceIdentifier {

    private var colorSpaceName: CFString? {
        switch self {
        case .sRGB: CGColorSpace.sRGB
        case .sRGBLinear: CGColorSpace.linearSRGB
        case .displayP3: CGColorSpace.displayP3
        case .displayP3Linear: CGColorSpace.linearDisplayP3
        case .noColorMatching: nil
        }
    }

    var colorSpace: CGColorSpace? {
        colorSpaceName.flatMap(CGColorSpace.init(name:))
    }

}
