//
//  ResultViewController.m
//  WheelOfEats
//
//  Created by Admin on 6/1/17.
//  Copyright © 2017 roxana. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultTableViewCell.h"
@import Firebase;



@interface ResultViewController ()

@end

NSMutableArray *resultTitle;
NSMutableArray *resultDate;
FIRDatabaseReference *resultRef;
NSMutableDictionary *resultData;

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    resultTitle = [[NSMutableArray alloc] init];
    resultDate = [[NSMutableArray alloc] init];

    resultRef = [[[[FIRDatabase database] reference] child:[FIRAuth auth].currentUser.uid] child:@"spinResult"];
    
    [resultRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if ([snapshot exists]) {
            
            [resultTitle removeAllObjects];
            [resultDate removeAllObjects];
            
            resultData = snapshot.value;
            NSLog(@"==== %@", resultData);
            NSString *key;
            for (key in resultData) {
                [resultDate addObject:key];
                NSLog(@"====key: %@", key);
                NSMutableDictionary *resultItem = resultData[key];
                NSLog(@"====title: %@", resultItem[@"title"]);
                [resultTitle addObject:resultItem[@"title"]];
            }
            
            [self.resultTableView reloadData];
        }
        else {
            
        }
        
    }];
    
    self.resultTableView.dataSource = self;
    self.resultTableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultTitle.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    [self.resultTableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"itemCell"];
    }
    
    cell.textLabel.text = [resultTitle objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [resultDate objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[resultRef child:resultDate[indexPath.row]] removeValue];
        [resultTitle removeObjectAtIndex:indexPath.row];
        [resultDate removeObjectAtIndex:indexPath.row];
        [self.resultTableView reloadData];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
