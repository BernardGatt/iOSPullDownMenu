iOSPullDownMenu
===============

A pulldown menu for all iOS devices.

It plugs onto the navigation controller and can be configured/styled in numerous ways.

<p align="center" >
  <img src="http://www.bernardgatt.com/github/iospulldownmenu.png" alt="iOSPullDownMenu" title="iOSPullDownMenu">
</p>

### Start by including PulldownMenu inside your main navigation controller

```objective-c
#import "PulldownMenu.h"

@interface MasterNavigationController : UINavigationController<PulldownMenuDelegate> {
    PulldownMenu *pulldownMenu;
}

@property (nonatomic, retain) PulldownMenu *pulldownMenu;

@end
```

### On load initialise pulldownMenu

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pulldownMenu = [[PulldownMenu alloc] initWithNavigationController:self];
    [self.view insertSubview:pulldownMenu belowSubview:self.navigationBar];
    
    [pulldownMenu insertButton:@"Menu Item 1"];
    [pulldownMenu insertButton:@"Menu Item 2"];
    [pulldownMenu insertButton:@"Menu Item 3"];

    pulldownMenu.delegate = self;
    
    [pulldownMenu loadMenu];
}
```

### Events fired by the Pulldown Menu
The component fires 2 events, #1 when a menu item is selected and #2 when the pull down is fully animated.

```objective-c
-(void)menuItemSelected:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.item);
}

-(void)pullDownAnimated:(BOOL)open
{
    if (open)
    {
        NSLog(@"Pull down menu open!");
    }
    else
    {
        NSLog(@"Pull down menu closed!");
    }
}
```

### Open / Close on demand
The pull down/up animation can be called on demand

```objective-c
    [((MasterNavigationController *)self.navigationController).pulldownMenu animateDropDown];
```