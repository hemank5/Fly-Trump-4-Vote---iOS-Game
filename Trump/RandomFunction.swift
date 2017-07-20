//
//  RandomFunction.swift
//  Trump
//
//  Created by Hemank Narula on 3/15/16.
//  Copyright © 2016 Hemank Narula. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    public static func random() -> CGFloat
    {
    
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF) // creating a random number
    
    }
    
    //text which will be displayed
    public static func random(min : CGFloat, max : CGFloat) -> CGFloat
        {
        return CGFloat.random() * (max - min) + min
        }
                        }
