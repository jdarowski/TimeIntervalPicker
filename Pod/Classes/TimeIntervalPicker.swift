import UIKit

private let secondsInMinute = 60
private let minutesInHour = 60
private let secondsInHour = minutesInHour * secondsInMinute
private let hoursInDay = 24

internal class DigitsLabel: UIView {
    internal var text: String = "" { didSet { label.text = text } }
    
    private let textAlignment = NSTextAlignment.Right
    private var label: UILabel!
    
    internal init(width: CGFloat, height: CGFloat, labelWidth: CGFloat, font: UIFont) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        createLabel(width: labelWidth, height: height, font: font)
    }
    
    internal required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel(#width: CGFloat, height: CGFloat, font: UIFont) {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        addSubview(label)
        label.textAlignment = textAlignment
        label.adjustsFontSizeToFitWidth = false
        label.font = font
    }
    
}

public class TimeIntervalPicker: UIControl, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Value access
    
    /// Value indicated by the picker in seconds
    public var countDownDuration: NSTimeInterval {
        get {
            let secondsFromHoursComponent = pickerView.selectedRowInComponent(Components.Hour.rawValue) * secondsInHour
            let secondsFromMinutesComponent = pickerView.selectedRowInComponent(Components.Minute.rawValue) % minutesInHour * secondsInMinute
            return NSTimeInterval(secondsFromHoursComponent + secondsFromMinutesComponent)
        }
        set(value) {
            let hours = Int(value) / secondsInHour
            let minutes = (Int(value) - hours * secondsInHour) / secondsInMinute
            
            pickerView.selectRow(hours % hoursInDay, inComponent: Components.Hour.rawValue, animated: false)
            pickerView.selectRow(minuteRowsCount / 2 + minutes, inComponent: Components.Minute.rawValue, animated: false)
        }
    }
    
    public var date: NSDate {
        get {
            let components = NSDateComponents()
            components.second = Int(countDownDuration)
            return NSCalendar.currentCalendar().dateFromComponents(components)!
        }
        set(newDate) {
            let components = NSCalendar.currentCalendar().components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: newDate)
            countDownDuration = NSTimeInterval(components.hour * 3600 + components.minute * 60 + components.second)
        }
    }
    
    public func setDate(newDate: NSDate, animated: Bool) {
        // TODO: implement animation
        date = newDate
    }
    
    public func setDatePickerMode(mode: UIDatePickerMode) {
        assert(mode == .CountDownTimer)
    }
    
    // MARK: Layout and geometry
    // The defaults values aim to resemble the look of UIDataPicker
    
    /// Width of a picker component
    public let componentWidth: CGFloat = 102
    
    /// Size of a label that shows hours/minutes digits within a component
    public let digitsLabelSize = CGSize(width: 26, height: 30)
    
    /// Font of a labels that show hours/minutes digits within a component
    public let digitsLabelFont = UIFont.systemFontOfSize(23.5)

    /// Font for "hours" and "min" labels
    public let minHoursFloatingLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 17) ??
        UIFont.systemFontOfSize(17)
    
    // MARK: Private details
    
    private let componentsNumber = 2
    
    private enum Components: Int {
        case Hour = 0
        case Minute = 1
    }
    
    private let minuteRowsCount = minutesInHour * 1000
    private var pickerView: UIPickerView!
    private var hoursFloatingLabel: UILabel!
    private var minutesFloatingLabel: UILabel!
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createPickerView()
        createFloatingLabels()
        autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        // Creates an illusion of an infinitly-looped minute: selector
        let middleMinutesRow = minuteRowsCount / 2
        pickerView.selectRow(middleMinutesRow, inComponent: Components.Minute.rawValue, animated: false)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createPickerView()
        createFloatingLabels()
        autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        // Creates an illusion of an infinitly-looped minute: selector
        let middleMinutesRow = minuteRowsCount / 2
        pickerView.selectRow(middleMinutesRow, inComponent: Components.Minute.rawValue, animated: false)
    }
    
    private func createPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(pickerView)
        
        // Fill the whole container:
        var width = NSLayoutConstraint(
            item: pickerView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant: 0)
        
        var height = NSLayoutConstraint(
            item: pickerView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0)
        
        var top = NSLayoutConstraint(
            item: pickerView,
            attribute:NSLayoutAttribute.Top,
            relatedBy:NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0)
        
        var leading = NSLayoutConstraint(
            item: pickerView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1.0,
            constant: 0)
        
        addConstraint(width)
        addConstraint(height)
        addConstraint(top)
        addConstraint(leading)
    }
    
    private func createFloatingLabels() {
        func createLabel(text: String) -> UILabel {
            var label = UILabel()
            label.font = self.minHoursFloatingLabelFont
            label.text = text
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            label.userInteractionEnabled = false
            label.adjustsFontSizeToFitWidth = false
            label.sizeToFit()
            return label
        }
        
        hoursFloatingLabel = createLabel("hours")
        minutesFloatingLabel = createLabel("min")
        
        addSubview(hoursFloatingLabel)
        addSubview(minutesFloatingLabel)
    }
    
    override public func layoutSubviews() {
        func alignToBaselineOfSelectedRow(label: UILabel) {
            let rowBaseline = self.pickerView.frame.origin.y + (self.pickerView.frame.height / 2) - self.digitsLabelFont.descender
            label.frame.origin.y = rowBaseline - label.frame.size.height - label.font.descender
        }
        
        super.layoutSubviews()
        alignToBaselineOfSelectedRow(hoursFloatingLabel)
        alignToBaselineOfSelectedRow(minutesFloatingLabel)
        
        let componentViewLabelMargin: CGFloat = 4
        let componentSpace: CGFloat = 5
        
        let componentsSeparatorX = pickerView.frame.origin.x + (pickerView.frame.size.width / 2)
        let hoursComponentX = componentsSeparatorX - componentWidth
        hoursFloatingLabel.frame.origin.x = hoursComponentX + digitsLabelSize.width + componentViewLabelMargin
        
        let minutesComponentX = componentsSeparatorX + componentSpace
        minutesFloatingLabel.frame.origin.x = minutesComponentX + digitsLabelSize.width + componentViewLabelMargin
    }
    
    // MARK: UIPickerViewDataSource methods
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        assert(pickerView == self.pickerView)
        return componentsNumber
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        assert(pickerView == self.pickerView)
        switch Components(rawValue: component)! {
        case Components.Hour:
            return hoursInDay
        case Components.Minute:
            return minuteRowsCount // a high number to create an illusion of an infinitly-looped selector
        }
    }
    
    // MARK: UIPickerViewDelegate methods
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assert(pickerView == self.pickerView)
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    public func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return componentWidth;
    }
    
    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var x = DigitsLabel(width: componentWidth, height: digitsLabelSize.height, labelWidth: digitsLabelSize.width, font: digitsLabelFont)
        
        var label: DigitsLabel = view is DigitsLabel ? view as! DigitsLabel : DigitsLabel(width: componentWidth, height: digitsLabelSize.height, labelWidth: digitsLabelSize.width, font: digitsLabelFont)
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        assert(pickerView == self.pickerView)
        switch Components(rawValue: component)! {
        case Components.Hour:
            return row.description
        case Components.Minute:
            return (row % minutesInHour).description
        }
    }
}
