//
//  DropdownMenuItem.swift
//  DropdownMenu-Sample
//
//  Created by Thought Chimp on 30/05/16.
//  Copyright © 2016 ThoughtChimp. All rights reserved.
//

import UIKit

public class DropdownMenuItem {
    public var title: String?
    public var completion: CompletionHandler?

    init() {}
    
    public convenience init(title: String, completion: CompletionHandler) {
        self.init()
        self.title = title
        self.completion = completion
    }
}
