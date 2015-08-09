import UIKit
import TimeIntervalPicker

internal class ViewController: UIViewController {
    
    @IBOutlet internal weak var defaultPicker: TimeIntervalPicker!
    @IBOutlet internal weak var defaultPickerValueLabel: UILabel!
    @IBOutlet internal weak var customPicker: TimeIntervalPicker!
    @IBOutlet internal weak var customPickerValueLabel: UILabel!
    
    private let formatter = NSDateComponentsFormatter()
    
    internal override func viewDidLoad() {
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Short
        
        defaultPicker.addTarget(self, action: Selector("defaultPickerValueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        defaultPickerValueChanged()
        
        customPicker.addTarget(self, action: Selector("customPickerValueChanged"), forControlEvents: UIControlEvents.ValueChanged)
        customPickerValueChanged()
        
        customPicker.minutesHoursLabelFont = UIFont(name: "AmericanTypewriter", size: 20)!
        customPicker.digitsLabelFont = UIFont(name: "AmericanTypewriter", size: 20)!
        customPicker.digitsLabelTextColor = UIColor.orangeColor()
        customPicker.minutesHoursLabelTextColor = UIColor.grayColor()
    }
    
    internal func defaultPickerValueChanged() {
        defaultPickerValueLabel.text = formatter.stringFromTimeInterval(defaultPicker.countDownDuration)
    }
    
    internal func customPickerValueChanged() {
        customPickerValueLabel.text = formatter.stringFromTimeInterval(customPicker.countDownDuration)
    }
}

