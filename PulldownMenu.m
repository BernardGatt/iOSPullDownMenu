//
//  PulldownMenu.m
//
//  Created by Bernard Gatt
//

#import "PulldownMenu.h"

@implementation PulldownMenu

@synthesize menuList, handle, rowHeight, handleHeight, animationDuration, delegate;

- (id)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(deviceOrientationDidChange:)
                                                     name: UIDeviceOrientationDidChangeNotification
                                                   object: nil];
        
        masterNavigationController = navigationController;
        
        navigationDragGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMenu:)];
        navigationDragGestureRecognizer.minimumNumberOfTouches = 1;
        navigationDragGestureRecognizer.maximumNumberOfTouches = 1;
        
        handleDragGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMenu:)];
        handleDragGestureRecognizer.minimumNumberOfTouches = 1;
        handleDragGestureRecognizer.maximumNumberOfTouches = 1;
        
        [masterNavigationController.navigationBar addGestureRecognizer:navigationDragGestureRecognizer];
        
        menuItems = [[NSMutableArray alloc] init];
        
        rowHeight = 60;
        handleHeight = 15;
        animationDuration = 0.3;
    }
    return self;
}

- (void)loadMenu
{
    tableHeight = ([menuItems count] * rowHeight);
    
    [self updateValues];
    
    [self setFrame:CGRectMake(0, 0, 0, tableHeight+handleHeight)];
    
    fullyOpen = NO;
    
    menuList = [[UITableView alloc] init];
    [menuList setRowHeight:rowHeight];
    [menuList setDataSource:self];
    [menuList setDelegate:self];
    [self addSubview:menuList];
    
    handle = [[UIView alloc] init];
    handle.backgroundColor = [UIColor grayColor];
    [self addSubview:handle];
    [handle addGestureRecognizer:handleDragGestureRecognizer];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [handle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [menuList setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self createConstraints];
}

- (void)insertButton:(NSString *)title
{
    [menuItems addObject:title];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate menuItemSelected:indexPath];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuListCell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"menuListCell"];
    }
    
    [cell.textLabel setText:[menuItems objectAtIndex:indexPath.item]];
    
    return cell;
}

- (void)dragMenu:(UIPanGestureRecognizer *)sender
{
    if ([sender state] == UIGestureRecognizerStateChanged)
    {
        CGPoint gesturePosition = [sender translationInView:masterNavigationController.navigationBar];
        CGPoint newPosition = gesturePosition;
        
        newPosition.x = self.frame.size.width / 2;

        if (fullyOpen)
        {
            if (newPosition.y < 0)
            {
                newPosition.y += ((self.frame.size.height / 2) + navigationBarHeight);
                
                [self setCenter:newPosition];
            }
        }
        else
        {
            newPosition.y += -((self.frame.size.height / 2) - navigationBarHeight);
            
            if (newPosition.y <= ((self.frame.size.height / 2) + navigationBarHeight))
            {
                [self setCenter:newPosition];
            }
        }
    }
    else if ([sender state] == UIGestureRecognizerStateEnded)
    {
        [self animateDropDown];
    }
}

- (void)animateDropDown
{
    [UIView animateWithDuration: animationDuration
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if (fullyOpen)
                         {
                             
                             self.center = CGPointMake(self.frame.size.width / 2, -((self.frame.size.height / 2) + navigationBarHeight));
                             fullyOpen = NO;
                         }
                         else
                         {
                             self.center = CGPointMake(self.frame.size.width / 2, ((self.frame.size.height / 2) + navigationBarHeight));
                             fullyOpen = YES;
                         }
                     }
                     completion:^(BOOL finished){
                         [delegate pullDownAnimated:fullyOpen];
                     }];
}

- (void)createConstraints
{
    NSLayoutConstraint *pullDownTopPositionConstraint = [NSLayoutConstraint
                                                             constraintWithItem:self
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                             toItem:masterNavigationController.view
                                                             attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                             constant:-self.frame.size.height];
    
    NSLayoutConstraint *pullDownCenterXPositionConstraint = [NSLayoutConstraint
                                                             constraintWithItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:0
                                                             toItem:masterNavigationController.view
                                                             attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                             constant:0];
    
    NSLayoutConstraint *pullDownWidthConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:masterNavigationController.view
                                                       attribute:NSLayoutAttributeWidth
                                                       multiplier:1.0
                                                       constant:0];

    NSLayoutConstraint *pullDownHeightMaxConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationLessThanOrEqual
                                                           toItem:masterNavigationController.view
                                                           attribute:NSLayoutAttributeHeight
                                                           multiplier:0.5
                                                           constant:0];
    
    pullDownHeightMaxConstraint.priority = 1000;
    
    NSLayoutConstraint *pullDownHeightConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:0
                                                        toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                        constant:tableHeight+handleHeight];

    pullDownHeightConstraint.priority = 900;
    
    NSLayoutConstraint *pullHandleWidthConstraint = [NSLayoutConstraint
                                                        constraintWithItem:handle
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                        toItem:masterNavigationController.view
                                                        attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                        constant:0];
    
    NSLayoutConstraint *pullHandleHeightConstraint = [NSLayoutConstraint
                                                         constraintWithItem:handle
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:0
                                                         toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                         constant:handleHeight];

    NSLayoutConstraint *pullHandleBottomPositionConstraint = [NSLayoutConstraint
                                                                constraintWithItem:handle
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                constant:0];
    
    NSLayoutConstraint *pullHandleCenterPositionConstraint = [NSLayoutConstraint
                                                                constraintWithItem:handle
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:0
                                                                toItem:self
                                                                attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                constant:0];
    
    NSLayoutConstraint *menuListHeightMaxConstraint = [NSLayoutConstraint
                                                        constraintWithItem:menuList
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:masterNavigationController.view
                                                        attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                        constant:-navigationBarHeight];
    
    NSLayoutConstraint *menuListHeightConstraint = [NSLayoutConstraint
                                                    constraintWithItem:menuList
                                                    attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:self
                                                    attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                    constant:-handleHeight];

    NSLayoutConstraint *menuListWidthConstraint = [NSLayoutConstraint
                                                       constraintWithItem:menuList
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeWidth
                                                       multiplier:1.0
                                                       constant:0];
    
    NSLayoutConstraint *menuListCenterXPositionConstraint = [NSLayoutConstraint
                                                                constraintWithItem:menuList
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:0
                                                                toItem:self
                                                                attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                constant:0];
    
    NSLayoutConstraint *menuListTopPositionConstraint = [NSLayoutConstraint
                                                                constraintWithItem:menuList
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:0
                                                                toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                constant:0];
    
    [masterNavigationController.view addConstraint: pullDownTopPositionConstraint];
    [masterNavigationController.view addConstraint: pullDownCenterXPositionConstraint];
    [masterNavigationController.view addConstraint: pullDownWidthConstraint];
    [masterNavigationController.view addConstraint: pullDownHeightConstraint];
    [masterNavigationController.view addConstraint: pullDownHeightMaxConstraint];

    [masterNavigationController.view addConstraint: pullHandleHeightConstraint];
    [masterNavigationController.view addConstraint: pullHandleWidthConstraint];
    [masterNavigationController.view addConstraint: pullHandleBottomPositionConstraint];
    [masterNavigationController.view addConstraint: pullHandleCenterPositionConstraint];
    
    [masterNavigationController.view addConstraint: menuListHeightMaxConstraint];
    [masterNavigationController.view addConstraint: menuListHeightConstraint];
    [masterNavigationController.view addConstraint: menuListWidthConstraint];
    [masterNavigationController.view addConstraint: menuListCenterXPositionConstraint];
    [masterNavigationController.view addConstraint: menuListTopPositionConstraint];
    
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation) {
        return;
    }
    
    currentOrientation = orientation;
    
    [self performSelector:@selector(orientationChanged) withObject:nil afterDelay:0];
}

- (void)orientationChanged
{
    [self updateValues];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if ((UIDeviceOrientationIsPortrait(currentOrientation) && UIDeviceOrientationIsPortrait(orientation)) ||
        (UIDeviceOrientationIsLandscape(currentOrientation) && UIDeviceOrientationIsLandscape(orientation))) {
        
        currentOrientation = orientation;
        
        if (fullyOpen)
        {
            [self animateDropDown];
        }
        
        return;
    }
}

- (void)updateValues
{
    navigationBarHeight = 0;
    
    if (![[UIApplication sharedApplication] isStatusBarHidden])
    {
        if (UIInterfaceOrientationIsLandscape(self.window.rootViewController.interfaceOrientation)) {
            navigationBarHeight = [UIApplication.sharedApplication statusBarFrame].size.width;
        }
        else
        {
            navigationBarHeight = [UIApplication.sharedApplication statusBarFrame].size.height;
        }
    }
    
    navigationBarHeight += masterNavigationController.navigationBar.frame.size.height;
}

@end
