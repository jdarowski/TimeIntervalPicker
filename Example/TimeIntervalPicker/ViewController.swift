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
        valueLabel.text = formatter.stringFromTimeInterval(picker.countDownDuration)
    }
}

