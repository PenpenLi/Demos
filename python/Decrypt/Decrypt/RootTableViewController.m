//
//  RootTableViewController.m
//  Decrypt
//
//  Created by Xiaobin Li on 6/10/15.
//  Copyright (c) 2015 Xiaobin Li. All rights reserved.
//

#import "RootTableViewController.h"

#import <Foundation/Foundation.h>

#import "DecryptViewController.h"

@interface RootTableViewController ()

- (NSDictionary *)generateAppInfo:(NSString *)appName;

@end

@implementation RootTableViewController
{
    NSArray *_appNames;
    NSDictionary *_appInfo;
    NSString *_selectedApp;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _appNames = @[
                      @"SoccerStars"
                      ];
        
        _selectedApp = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *testPngPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
    NSData *pngData = [NSData dataWithContentsOfFile:testPngPath];
    
//    CGDataProviderRef dataRef = CGDataProviderCreateWithData(0, pngData.bytes, width*height*4, 0);
//    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
//    CGImageRef imgRef = CGImageCreate(width, height, 8, 32, width*4, colorRef, 3, dataRef, 0, 0, 0);
//    CFRelease(dataRef);
//    CFRelease(colorRef);
//    img = [UIImage imageWithCGImage:imgRef];
//    CFRelease(imgRef);
//    [UIImagePNGRepresentation(img) writeToFile:outFile atomically:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _appNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppInfoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = _appNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedApp = _appNames[indexPath.row];
    [self performSegueWithIdentifier:@"RootToDecrypt" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"RootToDecrypt"]) {
        DecryptViewController *ctrl = segue.destinationViewController;
        ctrl.appInfo = [self generateAppInfo:_selectedApp];
    }
}


#pragma mark - private
- (NSDictionary *)generateAppInfo:(NSString *)appName {
    if ([appName isEqualToString:@"SoccerStars"]) {
        return @{
                 @"name"        : appName,
                 @"bundle"      : @"",
                 @"path"        : @"SoccerStars",
                 @"exe"         : @"SoccerStars.v7",
                 @"decrypt"     : @[@".png"]
                 };
    }
    return @{};
}

@end
