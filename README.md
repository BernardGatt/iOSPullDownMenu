iOSPullDownMenu
===============

A pulldown menu for all iOS devices.

The pulldown menu supports both navigation controllers and views, users can either pull it down or by tapping a button.

<p align="center" >
    <img src="http://www.bernardgatt.com/github/iospulldownmenu.png" style="margin-right:10px" alt="iOSPullDownMenu" title="iOSPullDownMenu">
    <img src="http://www.bernardgatt.com/github/iospulldownmenu-button.png" alt="iOSPullDownMenu Button" title="iOSPullDownMenu Button">
</p>

### To connect the pulldown menu to the navigation controller

.h

```objective-c
#import "PulldownMenu.h"

@interface MasterNavigationController : UINavigationController<PulldownMenuDelegate> {
    PulldownMenu *pulldownMenu;
}

@property (nonatomic, retain) PulldownMenu *pulldownMenu;

@end
```

.m

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

### Or connect the pulldown menu to a view instead of the navigation controller.

.h

```objective-c
#import "PulldownMenu.h"

@interface MainViewController : UIViewController<PulldownMenuDelegate, UIScrollViewDelegate> {
    PulldownMenu *pulldownMenu;
}
```

.m

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    pulldownMenu = [[PulldownMenu alloc] initWithView:self.view];
    [self.view addSubview:pulldownMenu];

    [pulldownMenu insertButton:@"Menu Item 1"];
    [pulldownMenu insertButton:@"Menu Item 2"];
    [pulldownMenu insertButton:@"Menu Item 3"];

    pulldownMenu.delegate = self;
    
    [pulldownMenu loadMenu];
}

- (IBAction)menuTap:(id)sender {
    [pulldownMenu animateDropDown];
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

From a view inside a navigation controller:

```objective-c
    [((MasterNavigationController *)self.navigationController).pulldownMenu animateDropDown];
```

From a view

```objective-c
    [pulldownMenu animateDropDown];
```

### Styles
Apart from having both table view and handle exposed, a number of styling properties are available out of the box.

```objective-c
    cellHeight = 60;
    handleHeight = 15;
    animationDuration = 0.3f;
    topMarginPortrait = 0;
    topMarginLandscape = 0;
    cellColor = [UIColor grayColor];
    cellSelectedColor = [UIColor blackColor];
    cellFont = [UIFont fontWithName:@"GillSans-Bold" size:19.0f];
    cellTextColor = [UIColor whiteColor];
    cellSelectionStyle = UITableViewCellSelectionStyleDefault;
```