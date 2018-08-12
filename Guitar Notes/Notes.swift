//
//  Notes.swift
//  Guitar Notes
//
//  Created by Braulio De La Torre on 5/24/18.
//  Copyright © 2018 Braulio. All rights reserved.
//

import Foundation

enum Accidental: String {
    case Sharp = "♯"
    case Flat  = "♭"
}

enum Note: CustomStringConvertible{
    case c(_: Accidental?)
    case d(_: Accidental?)
    case e(_: Accidental?)
    case f(_: Accidental?)
    case g(_: Accidental?)
    case a(_: Accidental?)
    case b(_: Accidental?)
    
    static let all: [Note] = [
        c(nil), c(.Sharp),
        d(nil), d(.Sharp),
        e(nil),
        f(nil), f(.Sharp),
        g(nil), g(.Sharp),
        a(nil), a(.Sharp),
        b(nil)
    
    ]
    
    var description: String{
        
        let concat = { (letter: String, accidental: Accidental?) in
            return letter + (accidental != nil ? accidental!.rawValue : "")
        }
        
        switch self{
            
            case let .c(a): return concat("C", a)
            case let .d(a): return concat("D", a)
            case let .e(a): return concat("E", a)
            case let .f(a): return concat("F", a)
            case let .g(a): return concat("G", a)
            case let .a(a): return concat("A", a)
            case let .b(a): return concat("B", a)
            
        }
        
    }
}
