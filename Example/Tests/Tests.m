#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <TimeIntervalPicker/TimeIntervalPicker-Swift.h>

@interface DPTSnapshotTest : FBSnapshotTestCase

@end

const NSInteger KSecondsInMinute = 60;
const NSInteger KMinutesInHour = 60;

@implementation DPTSnapshotTest

- (void)setUp {
    [super setUp];
}

- (void)testThatInitialTimeIntervalIsZero {
    TimeIntervalPicker *picker = [[TimeIntervalPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    XCTAssertEqual(0, picker.timeInterval);
}

- (void)testThatReturnedTimeIntervalIsSameAsSetWhenMultipleOfMinute {
    TimeIntervalPicker *picker = [[TimeIntervalPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    picker.timeInterval = 0;
    XCTAssertEqual(0, picker.timeInterval);
    
    picker.timeInterval = 2 * KSecondsInMinute;
    XCTAssertEqual(2 * KSecondsInMinute, picker.timeInterval);
    
    picker.timeInterval = 60 * KSecondsInMinute;
    XCTAssertEqual(60 * KSecondsInMinute, picker.timeInterval);
    
    picker.timeInterval = 62 * KSecondsInMinute;
    XCTAssertEqual(62 * KSecondsInMinute, picker.timeInterval);
}

- (void)testThatReturnedTimeIntervalIsRoundedToClosestMinuteOnLowSide {
    TimeIntervalPicker *picker = [[TimeIntervalPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    picker.timeInterval = 2 * KSecondsInMinute + 1;
    XCTAssertEqual(2 * KSecondsInMinute, picker.timeInterval);
}

- (void)testThatReturnedTimeIntervalIsReducedToTwentyFourHoursWhenGreater {
    TimeIntervalPicker *picker = [[TimeIntervalPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    picker.timeInterval = 25 * KMinutesInHour * KSecondsInMinute + 10 * KSecondsInMinute;
    XCTAssertEqual(1 * KMinutesInHour * KSecondsInMinute + 10 * KSecondsInMinute, picker.timeInterval);
}

- (void)testInitialView {
    TimeIntervalPicker *picker = [[TimeIntervalPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    FBSnapshotVerifyView(picker, @"picker");
}

- (void)testViewShowingTwoHours {
    TimeIntervalPicker *picker = [[TimeIntervalPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    picker.timeInterval = 2 * KMinutesInHour * KSecondsInMinute;
    FBSnapshotVerifyView(picker, @"picker");
}

- (void)testViewShowingThirtySixMinutes {
    TimeIntervalPicker *picker = [[TimeIntervalPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    picker.timeInterval = 36 * KSecondsInMinute;
    FBSnapshotVerifyView(picker, @"picker");
}

- (void)testViewShowingMaximalValue {
    TimeIntervalPicker *picker = [[TimeIntervalPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    picker.timeInterval = 23 * KMinutesInHour * KSecondsInMinute + 59 * KMinutesInHour;
    FBSnapshotVerifyView(picker, @"picker");
}

@end
