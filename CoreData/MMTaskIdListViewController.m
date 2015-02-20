//
//  MMTaskIdListViewController.m
//  CoreData
//
//  Created by Thiruppathi Gandhi on 2/9/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMTaskIdListViewController.h"
#import "MMTaskList.h"
#import "MMTask.h"
#import "AppDelegate.h"
#import "MMTaskList+MMTaskList_Customization.h"
#import "MMTaskDescViewController.h"

@interface MMTaskIdListViewController ()

@property (nonatomic,readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction) addTask:(id)sender;

@end

@implementation MMTaskIdListViewController

@synthesize lists =_lists;
@synthesize managedObjectContext=_managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IB Actions

- (IBAction) addTask:(id)sender{
    
    ///TODO
    MMTask *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"MMTask" inManagedObjectContext:self.managedObjectContext];
    
    newTask.created = [NSDate date];
    newTask.details = [NSString stringWithFormat:@"Task Id %lu",(unsigned long)self.lists.tasks.count];
    
    newTask.list = self.lists;
    
    [self.managedObjectContext save:nil];
    
    [self.tableView reloadData];
}

#pragma mark CoreData

-(NSManagedObjectContext*) managedObjectContext{
    
    return [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.lists.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    // Configure the cell...
    MMTask * currentTask = [[self.lists sortedTask] objectAtIndex:indexPath.row];
    cell.textLabel.text = currentTask.details;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [self.managedObjectContext deleteObject:[self.lists.sortedTask objectAtIndex:indexPath.row]];
        [self.managedObjectContext save:nil];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"TaskDescSegue"]){
        
        MMTaskDescViewController *nextView = segue.destinationViewController;
        nextView.task = [self.lists.sortedTask objectAtIndex: self.tableView.indexPathForSelectedRow.row];
    }
}

@end
