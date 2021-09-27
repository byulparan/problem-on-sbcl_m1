#import <Cocoa/Cocoa.h>

void(*gCallback)(void);

@interface LispObject : NSObject<NSApplicationDelegate> {
  
}
@end

@implementation LispObject
-(IBAction) lisp_callback:(id) sender {
  gCallback();
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}
@end


void run_event_loop(void(*callback)(void)) {

  gCallback = callback;

  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

  NSApp = [NSApplication sharedApplication];


  [NSApp setActivationPolicy: NSApplicationActivationPolicyRegular];
  
  NSMenu* menubar = [[NSMenu alloc] initWithTitle: @"MainMenu"];
  [NSApp setMainMenu: [menubar autorelease]];
  
  NSMenuItem* appMenuItem = [[NSMenuItem new] autorelease];
  [menubar addItem: appMenuItem];

  NSMenu* appMenu = [[NSMenu new] autorelease];
  NSMenuItem* quitMenuItem = [[NSMenuItem alloc] initWithTitle: @"Quit"
							action: @selector(terminate:)
						 keyEquivalent: @"q"];

  [appMenu addItem: [quitMenuItem autorelease]];
  [appMenuItem setSubmenu: appMenu];

  NSMenuItem* editMenuItem = [[NSMenuItem new] autorelease];
  [menubar addItem: editMenuItem];

  NSMenu* editmenu = [[NSMenu alloc] initWithTitle: @"Edit"];
  [editMenuItem setSubmenu: editmenu];
  

  
  NSWindow* window = [[NSWindow alloc] initWithContentRect: NSMakeRect(10,800,400,200)
						 styleMask:  NSWindowStyleMaskTitled | NSWindowStyleMaskClosable
						   backing:  NSBackingStoreBuffered
						     defer:  NO];


  LispObject* lisp = [[LispObject alloc] init];
  [NSApp setDelegate: lisp];
  NSButton* button = [[NSButton alloc] initWithFrame: NSMakeRect(10,10,300,180)];

  [button setTitle: @"Lisp Room"];
  [button setTarget: lisp];
  [button setAction: @selector(lisp_callback:)];
  [[window contentView] addSubview: [button autorelease]];
  
  [window orderFront: nil];
  
  
  [NSApp run];
  [pool release];
  
}

