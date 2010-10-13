#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>
#import <SpringBoard/SpringBoard.h>

@interface SBAlertWindow (OS40)
- (BOOL)_isSupportedInterfaceOrientation:(UIInterfaceOrientation)orientation;
@end

@interface SBIconController (OS40)
- (UIView *)dock;
- (UIView *)dockContainerView;
@end

static NSInteger fakeWildcat;

CHDeclareClass(UIDevice);

CHOptimizedMethod(0, self, BOOL, UIDevice, isWildcat)
{
	if (fakeWildcat) {
		CHSuper(0, UIDevice, isWildcat);
		return YES;
	}
	return CHSuper(0, UIDevice, isWildcat);
}

CHDeclareClass(SBAccelerometerInterface);

CHOptimizedMethod(0, self, void, SBAccelerometerInterface, updateSettings)
{
	fakeWildcat++;
	CHSuper(0, SBAccelerometerInterface, updateSettings);
	fakeWildcat--;
}

CHDeclareClass(SBAwayController);

CHOptimizedMethod(0, self, void, SBAwayController, _undimScreen)
{
	CHSuper(0, SBAwayController, _undimScreen);
	[(id)CHSharedInstance(SBAccelerometerInterface) setSpringBoardWantsEvents:YES];
}

CHDeclareClass(SpringBoard);

CHOptimizedMethod(1, self, void, SpringBoard, applicationDidFinishLaunching, UIApplication *, application)
{
	CHSuper(1, SpringBoard, applicationDidFinishLaunching, application);
	[(id)CHSharedInstance(SBAccelerometerInterface) setSpringBoardWantsEvents:YES];
}

CHDeclareClass(SBUIController);

CHOptimizedMethod(0, self, id, SBUIController, init)
{
	if ((self = CHSuper(0, SBUIController, init))) {
		[CHIvar(self, _window, UIWindow *) setDelegate:self];
		[CHIvar(self, _window, UIWindow *) setAutorotates:YES];
		[CHIvar(self, _contentView, UIView *) setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	}
	return self;
}

CHOptimizedMethod(2, self, BOOL, SBUIController, window, UIWindow *, window, shouldAutorotateToInterfaceOrientation, UIInterfaceOrientation, orientation)
{
	return YES;
}

CHDeclareClass(SBAlertWindow);

CHOptimizedMethod(2, self, BOOL, SBAlertWindow, window, UIWindow *, window, shouldAutorotateToInterfaceOrientation, UIInterfaceOrientation, orientation)
{
	return [self _isSupportedInterfaceOrientation:orientation];
}

CHOptimizedMethod(1, self, BOOL, SBAlertWindow, _isSupportedInterfaceOrientation, UIInterfaceOrientation, orientation)
{
	return YES;
}

CHOptimizedMethod(1, self, UIView *, SBAlertWindow, rotatingContentViewForWindow, UIWindow *, window)
{
	return CHIvar(self, _contentLayer, UIView *);
}

CHOptimizedMethod(1, self, BOOL, SBAlertWindow, shouldWindowUseOnePartInterfaceRotationAnimation, UIWindow *, window)
{
	return YES;
}

CHOptimizedMethod(1, self, id, SBAlertWindow, initWithContentRect, CGRect, contentRect)
{
	if ((self = CHSuper(1, SBAlertWindow, initWithContentRect, contentRect))) {
		[self setAutorotates:YES];
	}
	return self;
}

CHDeclareClass(SBIconController);

CHOptimizedMethod(2, self, void, SBIconController, willAnimateRotationToInterfaceOrientation, UIInterfaceOrientation, orientation, duration, NSTimeInterval, duration)
{
	CHSuper(2, SBIconController, willAnimateRotationToInterfaceOrientation, orientation, duration, duration);
	UIView *dock = [self dock];
	CGRect frame = dock.frame;
	frame.origin.x = 0.0f;
	frame.size.width = [self dockContainerView].bounds.size.width;
	dock.frame = frame;
}

CHConstructor
{
	CHLoadLateClass(UIDevice);
	CHHook(0, UIDevice, isWildcat);
	CHLoadLateClass(SBAccelerometerInterface);
	CHHook(0, SBAccelerometerInterface, updateSettings);
	CHLoadLateClass(SBAwayController);
	CHHook(0, SBAwayController, _undimScreen);
	CHLoadLateClass(SpringBoard);
	CHHook(1, SpringBoard, applicationDidFinishLaunching);
	CHLoadLateClass(SBUIController);
	CHHook(0, SBUIController, init);
	CHHook(2, SBUIController, window, shouldAutorotateToInterfaceOrientation);
	CHLoadLateClass(SBAlertWindow);
	CHHook(2, SBAlertWindow, window, shouldAutorotateToInterfaceOrientation);
	CHHook(1, SBAlertWindow, _isSupportedInterfaceOrientation);
	CHHook(1, SBAlertWindow, rotatingContentViewForWindow);
	CHHook(1, SBAlertWindow, shouldWindowUseOnePartInterfaceRotationAnimation);
	CHHook(1, SBAlertWindow, initWithContentRect);
	CHLoadLateClass(SBIconController);
	CHHook(2, SBIconController, willAnimateRotationToInterfaceOrientation, duration);
}
