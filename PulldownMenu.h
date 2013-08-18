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
    UIView *masterView;
    UIPanGestureRecognizer *navigationDragGestureRecognizer;
    UIPanGestureRecognizer *handleDragGestureRecognizer;
    UINavigationController *masterNavigationController;
    UIDeviceOrientation currentOrientation;
    
    float topMargin;
    float tableHeight;
}

@property (nonatomic, assign) id<PulldownMenuDelegate> delegate;
@property (nonatomic, retain) UITableView *menuList;
@property (nonatomic, retain) UIView *handle;

/* Appearance Properties */
@property (nonatomic) float handleHeight;
@property (nonatomic) float animationDuration;
@property (nonatomic) float topMarginPortrait;
@property (nonatomic) float topMarginLandscape;
@property (nonatomic) UIColor *cellColor;
@property (nonatomic) UIColor *cellSelectedColor;
@property (nonatomic) UIColor *cellTextColor;
@property (nonatomic) UITableViewCellSelectionStyle cellSelectionStyle;
@property (nonatomic) UIFont *cellFont;
@property (nonatomic) float cellHeight;
@property (nonatomic) BOOL fullyOpen;

- (id)initWithNavigationController:(UINavigationController *)navigationController;
- (id)initWithView:(UIView *)view;
- (void)insertButton:(NSString *)title;
- (void)loadMenu;
- (void)animateDropDown;

@end
