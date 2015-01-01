//
//  Copyright (c) 2015 Dawid Drechny
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import TimeIntervalPicker

internal class ViewController: UIViewController {

    @IBOutlet internal weak var picker: TimeIntervalPicker!
    @IBOutlet internal weak var valueLabel: UILabel!
    private let formatter = NSDateComponentsFormatter()
    
    internal override func viewDidLoad() {
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Short
        picker.addTarget(self, action: Selector("pickerValueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        pickerValueChanged()
    }
    
    internal func pickerValueChanged() {
        valueLabel.text = formatter.stringFromTimeInterval(picker.timeInterval)
    }
}

