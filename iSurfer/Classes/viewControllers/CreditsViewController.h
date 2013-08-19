//
//  creditsViewController.h
//  iSurfer
//
//  Created by Cristian Prieto on 15/06/13.
//
//

#import "BaseViewController.h"
#import <Foundation/Foundation.h>

@interface CreditsViewController : BaseViewController<UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UILabel* creditsLabel;
    IBOutlet UIWebView* creditsTable;
    IBOutlet UIScrollView* scrollView;
}

@property(nonatomic, retain)	IBOutlet UILabel* creditsLabel;
@property(nonatomic, retain)    IBOutlet UIWebView* creditsTable;
@property(nonatomic, retain)    IBOutlet UIScrollView* scrollView;

@end
