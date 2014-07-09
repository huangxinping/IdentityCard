//
//  MainWindow.m
//  IdentityCard
//
//  Created by hxp on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainWindow.h"
#import "BaseCodeMgr.h"
#import "IdentityCardFactory.h"

@implementation MainWindow
@synthesize window = _window;
@synthesize cardTabelView = _cardTabelView;
@synthesize yearsComboBox = _yearsComboBox;
@synthesize monthsComboBox = _monthsComboBox;
@synthesize daysComboBox = _daysComboBox;
@synthesize provinceComboBox = _provinceComboBox;
@synthesize cityComboBox = _cityComboBox;
@synthesize countyComboBox = _countyComboBox;
@synthesize sexRadioBox = _sexRadioBox;
@synthesize numberTextField = _numberTextField;

- (void)oneByOneSet:(NSComboBox *)cb {
	[cb setUsesDataSource:YES];
	cb.dataSource = self;
	cb.delegate = self;
	[cb setEditable:NO];
	[cb selectItemAtIndex:0];
}

- (NSArray *)removeWhite:(NSArray *)input {
	NSMutableArray *bufferArray = [NSMutableArray array];
	for (NSString *obj in input) {
		obj = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[bufferArray addObject:obj];
	}
	return bufferArray;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		NSString *yearsString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/years.txt", [[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
		yearsArray = [[NSMutableArray alloc] initWithArray:[yearsString componentsSeparatedByString:@"\n"]];
		NSArray *array = [self removeWhite:yearsArray];
		[yearsArray removeAllObjects];
		[yearsArray addObjectsFromArray:array];

		NSString *monthsString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/months.txt", [[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
		monthsArray = [[NSMutableArray alloc] initWithArray:[monthsString componentsSeparatedByString:@"\n"]];
		array = [self removeWhite:monthsArray];
		[monthsArray removeAllObjects];
		[monthsArray addObjectsFromArray:array];

		NSString *daysString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/days.txt", [[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
		daysArray = [[NSMutableArray alloc] initWithArray:[daysString componentsSeparatedByString:@"\n"]];
		array = [self removeWhite:daysArray];
		[daysArray removeAllObjects];
		[daysArray addObjectsFromArray:array];

		NSString *bjxString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/bjx.txt", [[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
		NSMutableArray *singleBJXArray = [[NSMutableArray alloc] initWithArray:[bjxString componentsSeparatedByString:@"\n"]];
		bjxArray = [[NSMutableArray alloc] init];
		for (NSString *single in singleBJXArray) {
			NSArray *array = [single componentsSeparatedByString:@" "];
			[bjxArray addObjectsFromArray:array];
		}

		NSString *commonString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/common.txt", [[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:nil];
		NSMutableArray *singleCommonArray = [[NSMutableArray alloc] initWithArray:[commonString componentsSeparatedByString:@"\n"]];
		commonArray = [[NSMutableArray alloc] init];
		for (NSString *single in singleCommonArray) {
			for (NSInteger i = 0; i < [single length] - 1; i++) {
				[commonArray addObject:[single substringWithRange:NSMakeRange(i, 1)]];
			}
		}
	}
	return self;
}

- (void)dealloc {
	[commonArray release];
	[bjxArray release];
	[userfulID release];
	[yearsArray release];
	[monthsArray release];
	[daysArray release];
	[super dealloc];
}

- (void)awakeFromNib {
	[super awakeFromNib];

	self.delegate = self;

	userfulID = [[NSMutableArray alloc] init];

	[self oneByOneSet:self.yearsComboBox];
	[self oneByOneSet:self.monthsComboBox];
	[self oneByOneSet:self.daysComboBox];
	[self oneByOneSet:self.provinceComboBox];
	[self oneByOneSet:self.cityComboBox];
	[self oneByOneSet:self.countyComboBox];

	self.cardTabelView.delegate = self;
	self.cardTabelView.dataSource = self;
	[self.cardTabelView setDoubleAction:@selector(handleTableDoubleAction:)];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	if (aComboBox == self.yearsComboBox) {
		return [yearsArray count];
	}
	else if (aComboBox == self.monthsComboBox) {
		return [monthsArray count];
	}
	else if (aComboBox == self.daysComboBox) {
		// 看2月
		if ([self.monthsComboBox.stringValue isEqualToString:@"2"]) {
			NSInteger year = [self.yearsComboBox.stringValue integerValue];
			if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
				return 29;
			}
			return 28;
		}
		else {
			NSInteger month = [self.monthsComboBox.stringValue integerValue];
			if (month <= 7) {
				if (month % 2 == 0) { // 看小月
					return [daysArray count] - 1;
				}
				else { // 看大月
					return [daysArray count];
				}
			}
			else {
				if (month % 2 != 0) { // 看小月
					return [daysArray count] - 1;
				}
				else { // 看大月
					return [daysArray count];
				}
			}
		}
		return [daysArray count];
	}
	else if (aComboBox == self.provinceComboBox) {
		return [[BaseCodeMgr sharedBaseCodeMgr].baseCodeArray count];
	}
	else if (aComboBox == self.cityComboBox) {
		NSInteger provinceIndex = self.provinceComboBox.indexOfSelectedItem;
		BaseCodeP *bcp = [[BaseCodeMgr sharedBaseCodeMgr].baseCodeArray objectAtIndex:provinceIndex];
		return [bcp.cityArray count];
	}
	else if (aComboBox == self.countyComboBox) {
		NSInteger provinceIndex = self.provinceComboBox.indexOfSelectedItem;
		NSInteger cityIndex = self.cityComboBox.indexOfSelectedItem;
		BaseCodeP *bcp = [[BaseCodeMgr sharedBaseCodeMgr].baseCodeArray objectAtIndex:provinceIndex];
		BaseCodeC *bcc = [bcp.cityArray objectAtIndex:cityIndex];
		return [bcc.countyArray count];
	}
	return 5;
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	if (aComboBox == self.yearsComboBox) {
		return [yearsArray objectAtIndex:index];
	}
	else if (aComboBox == self.monthsComboBox) {
		return [monthsArray objectAtIndex:index];
	}
	else if (aComboBox == self.daysComboBox) {
		return [daysArray objectAtIndex:index];
	}
	else if (aComboBox == self.provinceComboBox) {
		BaseCodeP *bcp = [[BaseCodeMgr sharedBaseCodeMgr].baseCodeArray objectAtIndex:index];
		return bcp.name;
	}
	else if (aComboBox == self.cityComboBox) {
		int provinceIndex = self.provinceComboBox.indexOfSelectedItem;
		if (provinceIndex == -1) {
			return aComboBox.stringValue;
		}
		BaseCodeP *bcp = [[BaseCodeMgr sharedBaseCodeMgr].baseCodeArray objectAtIndex:provinceIndex];
		BaseCodeC *bcc = [bcp.cityArray objectAtIndex:index];
		return bcc.name;
	}
	else if (aComboBox == self.countyComboBox) {
		int provinceIndex = self.provinceComboBox.indexOfSelectedItem;
		int cityIndex = self.cityComboBox.indexOfSelectedItem;
		if (cityIndex == -1) {
			return aComboBox.stringValue;
		}
		BaseCodeP *bcp = [[BaseCodeMgr sharedBaseCodeMgr].baseCodeArray objectAtIndex:provinceIndex];
		BaseCodeC *bcc = [bcp.cityArray objectAtIndex:cityIndex];
		BaseCodeCY *bcy = [bcc.countyArray objectAtIndex:index];
		return bcy.name;
	}
	return @"-";
}

- (void)comboBoxWillDismiss:(NSNotification *)notification {
	static id oldObject = nil;
	if ([self.provinceComboBox numberOfItems] <= 0 ||
	    [self.cityComboBox numberOfItems] <= 0 ||
	    [self.countyComboBox numberOfItems] <= 0) {
		return;
	}
	id obj = [notification object];
	if (obj == oldObject) {
		return;
	}
	if (obj == self.countyComboBox) {
		return;
	}
	if (obj == self.provinceComboBox) {
		[self.cityComboBox selectItemAtIndex:0];
		[self.countyComboBox selectItemAtIndex:0];
	}
	else if (obj == self.cityComboBox) {
		[self.countyComboBox selectItemAtIndex:0];
	}
	obj = oldObject;
}

- (IBAction)createSwatch:(id)sender {
	if ([self.numberTextField.stringValue integerValue] > 500) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"警告" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"生成数量溢出"];
		[alert runModal];
		return;
	}
	NSInteger provinceIndex = self.provinceComboBox.indexOfSelectedItem;
	NSInteger cityIndex = self.cityComboBox.indexOfSelectedItem;
	NSInteger countyIndex = self.countyComboBox.indexOfSelectedItem;
	BaseCodeP *bcp = [[BaseCodeMgr sharedBaseCodeMgr].baseCodeArray objectAtIndex:provinceIndex];
	BaseCodeC *bcc = [bcp.cityArray objectAtIndex:cityIndex];
	BaseCodeCY *bcy = [bcc.countyArray objectAtIndex:countyIndex];

	NSInteger sex = self.sexRadioBox.selectedColumn;
	NSString *code = bcy.code;
	NSString *year = self.yearsComboBox.stringValue;
	NSString *month = self.monthsComboBox.stringValue;
	NSString *day = self.daysComboBox.stringValue;
	NSInteger number = [self.numberTextField.stringValue integerValue];

	NSString *idBuffer = [NSString stringWithFormat:@"%@%@%.2d%.2d", code, year, [month intValue], [day intValue]];
	NSString *ratio = [NSString stringWithString:@"7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2"];
	NSString *verify = [NSString stringWithString:@"1 0 X 9 8 7 6 5 4 3 2"];
	NSArray *ratioArray = [ratio componentsSeparatedByString:@" "];
	NSArray *verifyArray = [verify componentsSeparatedByString:@" "];

	NSMutableArray *usefulMaleID = [NSMutableArray array];
	NSMutableArray *usefulFemaleID = [NSMutableArray array];
	for (NSInteger i = 0; i < 1000; i++) {
		int sum = 0;
		NSString *buffer = [idBuffer stringByAppendingFormat:@"%.3d", i]; // 生成前17位
		for (NSInteger j = 0; j < 17; j++) { // 将前17位与系数相乘
			int flag = [[NSString stringWithFormat:@"%c", [buffer characterAtIndex:j]] intValue];
			sum += flag *[[ratioArray objectAtIndex:j] intValue];
		}
		sum = sum % 11; // 结果对11取余
		buffer = [buffer stringByAppendingFormat:@"%@", [verifyArray objectAtIndex:sum]]; // 从余数和校验码觉得第18位

		int seventeenValue = [[NSString stringWithFormat:@"%c", [buffer characterAtIndex:16]] intValue];
		if (seventeenValue % 2 == 0) { // 偶数配给女生
			[usefulFemaleID addObject:buffer];
		}
		else { // 奇数配给男生
			[usefulMaleID addObject:buffer];
		}
	}

	[userfulID removeAllObjects];
	if (sex == 0) {
		while (true) {
			if ([userfulID count] >= number) {
				break;
			}
			NSInteger index = arc4random() % [usefulMaleID count];
			[userfulID addObject:[usefulMaleID objectAtIndex:index]];
			[usefulMaleID removeObjectAtIndex:index];
		}
	}
	else if (sex == 1) {
		while (true) {
			if ([userfulID count] >= number) {
				break;
			}
			NSInteger index = arc4random() % [usefulFemaleID count];
			[userfulID addObject:[usefulFemaleID objectAtIndex:index]];
			[usefulFemaleID removeObjectAtIndex:index];
		}
	}

	// 创建图像
	for (NSString *card in userfulID) {
		IdentityCardFactory *icf = [[IdentityCardFactory alloc] init];
		icf.number = card;
		NSString *cityMask = self.cityComboBox.stringValue;
		if ([cityMask isEqualToString:@"市辖区"] ||
		    [cityMask isEqualToString:@"县"]) {
			cityMask = [NSString stringWithFormat:@""];
		}
		NSInteger mountySize = arc4random() % 3 + 2;
		NSMutableString *mountyMask = [NSMutableString string];
		for (NSInteger i = 0; i <= mountySize; i++) {
			[mountyMask appendString:[commonArray objectAtIndex:arc4random() % [commonArray count]]];
		}
		icf.addr = [NSString stringWithFormat:@"%@%@%@%@村%d号", self.provinceComboBox.stringValue, cityMask, self.countyComboBox.stringValue, mountyMask, arc4random() % 100];
		NSInteger familyNameIndex = arc4random() % [bjxArray count]; // 姓
		BOOL doubleName = arc4random() % 2;
		NSInteger name1Index = arc4random() % [commonArray count]; // 名第1个
		NSInteger name2Index = arc4random() % [commonArray count]; // 名第2个
		if (doubleName) {
			icf.name = [NSString stringWithFormat:@"%@  %@  %@", [bjxArray objectAtIndex:familyNameIndex], [commonArray objectAtIndex:name1Index], [commonArray objectAtIndex:name2Index]];
		}
		else {
			icf.name = [NSString stringWithFormat:@"%@  %@", [bjxArray objectAtIndex:familyNameIndex], [commonArray objectAtIndex:name1Index]];
		}
		icf.year = self.yearsComboBox.stringValue;
		icf.month = self.monthsComboBox.stringValue;
		icf.day = self.daysComboBox.stringValue;
		[icf createIdentityCard];
		[icf release];
	}

	// 更新视图
	[self.cardTabelView reloadData];
}

- (void)handleTableDoubleAction:(NSTableView *)sender {
	NSInteger selectedRow = sender.selectedRow;
	NSString *cardID = [userfulID objectAtIndex:selectedRow];
	//[[NSWorkspace sharedWorkspace] selectFile:[NSString stringWithFormat:@"%@/Downloads/ICBox/%@.tiff",NSHomeDirectory(),cardID] inFileViewerRootedAtPath:@""];
	[[NSWorkspace sharedWorkspace] openFile:[NSString stringWithFormat:@"%@/Downloads/ICBox/%@.jpg", NSHomeDirectory(), cardID]];
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return NO;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [userfulID count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return [userfulID objectAtIndex:row];
}

- (BOOL)windowShouldClose:(id)sender {
	[NSApp terminate:self];
	return YES;
}

@end
