//
//  MainWindow.h
//  IdentityCard
//
//  Created by hxp on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindow : NSWindow<NSWindowDelegate,NSComboBoxDataSource,NSComboBoxDelegate,NSTableViewDataSource,NSTableViewDelegate>
{
    NSMutableArray *yearsArray;
    NSMutableArray *monthsArray;
    NSMutableArray *daysArray; 
    
    NSMutableArray *bjxArray;
    NSMutableArray *commonArray;
    
    NSMutableArray *userfulID;
}
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTableView *cardTabelView;
@property (assign) IBOutlet NSComboBox *yearsComboBox;
@property (assign) IBOutlet NSComboBox *monthsComboBox;
@property (assign) IBOutlet NSComboBox *daysComboBox;
@property (assign) IBOutlet NSComboBox *provinceComboBox;
@property (assign) IBOutlet NSComboBox *cityComboBox;
@property (assign) IBOutlet NSComboBox *countyComboBox;
@property (assign) IBOutlet NSMatrix *sexRadioBox;
@property (assign) IBOutlet NSTextField *numberTextField;
- (IBAction)createSwatch:(id)sender;
@end
