//
//  SliderConfiguration.swift
//  Sliction
//
//  Created by Awwad on 20.11.21.
//

import Foundation
import UIKit

public class SliderConfiguration {

    /** Describes the slide's background appearance */
    public var backgroundColor: UIColor = .white

    /** Describes the slide's and slider view's corner radius */
    public var radius: CGFloat = 24

    /** Describes the slide's label font */
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 16)

    /** Describes the slide's label text */
    public var title: String = ""

    /** Describes the slide's label text apperance*/
    public var textColor: UIColor = .black

    /** Describes the slide's label text alignment*/
    public var textAlignment: NSTextAlignment = .center

    /** Describes the slider's background appearance */
    public var slideBackgroundColor: UIColor = .black

    /** Describes the slider's border width around the slider view */
    public var slideBorderWidth: CGFloat = 1

    /** Describes the slider's border color around the slider view */
    public var slideBorderColor: CGColor = UIColor.white.cgColor

    /** Describes the slider's image */
    public var icon: String = "arrow"

    /** Init with default configurations */
    public init() {}
}
