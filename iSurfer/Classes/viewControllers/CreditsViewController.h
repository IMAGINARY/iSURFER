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
}

@property(nonatomic, retain)	IBOutlet UILabel* creditsLabel;

@end
