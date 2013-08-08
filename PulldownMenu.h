//
//  PulldownMenu.h
//
//  Created by Bernard Gatt
//

#import <UIKit/UIKit.h>

@protocol PulldownMenuDelegate
    -(void)menuItemSelected:(NSIndexPath *)indexPath;
    -(void)pullDownAnimated:(BOOL)open;
@end

@interface PulldownMenu : UIView<UITableViewDataSource, UITableViewDelegate> {
    UITableView *menuList;
    NSMutableArray *menuItems;
    
    UIView *handle;
    UIPanGestureRecognizer *navigationDragGestureRecognizer;
    UIPanGestureRecognizer *handleDragGestureRecognizer;
    UINavigationController *masterNavigationController;
    UIDeviceOrientation currentOrientation;
    
    float navigationBarHeight;
    float tableHeight;
    
    BOOL fullyOpen;
}

@property (nonatomic, retain) UITableView *menuList;
@property (nonatomic, retain) UIView *handle;
@property (nonatomic) float rowHeight;
@property (nonatomic) float handleHeight;
@property (nonatomic) float animationDuration;
@property (nonatomic, assign) id<PulldownMenuDelegate> delegate;

- (id)initWithNavigationController:(UINavigationController *)navigationController;
- (void)insertButton:(NSString *)title;
- (void)loadMenu;
- (void)animateDropDown;

@end
