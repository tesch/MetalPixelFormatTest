//
// MTLPixelFormat+CustomStringConvertible.swift
//
// Created by Marcel Tesch on 2024-03-31.
// Think different.
//

import Metal

extension MTLPixelFormat: CustomStringConvertible {

    public var description: String {
        switch self {
        case .bgra8Unorm: "bgra8Unorm"
        case .rgba16Float: "rgba16Float"
        default: "other"
        }
    }

}
