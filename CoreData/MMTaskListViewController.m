//
//  MMTaskListViewController.m
//  CoreData
//
//  Created by Thiruppathi Gandhi on 2/9/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMTaskListViewController.h"
#import "MMTask.h"
#import "MMTaskList.h"
#import "AppDelegate.h"
#import "MMTaskIdListViewController.h"

@interface MMTaskListViewController ()
    
 
@property (nonatomic,strong) NSArray *lists;
@property (nonatomic,readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction) addTaskList:(id)sender;

@end

@implementation MMTaskListViewController

@synthesize lists =_lists;
@synthesize managedObjectContext=_managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: load the data
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MMTaskList"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]];
    
    self.lists = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.lists.count;
}

#pragma mark IB Actions

- (IBAction) addTaskList:(id)sender{
    
    //TODO
    
    MMTaskList *newList = [NSEntityDescription insertNewObjectForEntityForName:@"MMTaskList" inManagedObjectContext:self.managedObjectContext];
    
    newList.created = [NSDate date];
    newList.title = [NSString stringWithFormat:@"Task List %lu",(unsigned long)self.lists.count];
    
    [self.managedObjectContext save:nil];
    
    self.lists = [self.lists arrayByAddingObject:newList];
    
    [self.tableView reloadData];
    
}

#pragma mark Managed Object Context

- (NSManagedObjectContext*)  managedObjectContext{
    
    return [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    MMTaskList * currentList = [self.lists objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentList.title;
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
        [self.managedObjectContext deleteObject:[self.lists objectAtIndex:indexPath.row]];
        [self.managedObjectContext save:nil];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MMTaskList"];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]];
        
        self.lists = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
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
    
    if([segue.identifier isEqualToString:@"TaskIdSeque"] == YES){
        
        MMTaskIdListViewController * nextView = segue.destinationViewController;
        nextView.lists = [self.lists objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
    }
    
    
}

@end
