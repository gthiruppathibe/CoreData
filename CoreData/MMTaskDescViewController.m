//
//  MMTaskDescViewController.m
//  CoreData
//
//  Created by Thiruppathi Gandhi on 2/9/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMTaskDescViewController.h"
#import "AppDelegate.h"
#import "MMTask.h"


@interface MMTaskDescViewController ()
- (IBAction)SaveTask:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *details;

@property (nonatomic,readonly) NSManagedObjectContext *managedObjectContext;


@end

@implementation MMTaskDescViewController

@synthesize  task = _task;
@synthesize  managedObjectContext =_managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.details.text = self.task.details;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CoreData

-(NSManagedObjectContext*) managedObjectContext{
    
    return [(AppDelegate*) [[UIApplication sharedApplication] delegate] managedObjectContext];
    
}


- (IBAction) save:(id)sender{
    
    //TODO
    //self.task.details = self.detailsField.text;
    [self.managedObjectContext save:nil];
}


- (IBAction)SaveTask:(id)sender {
    self.task.details = self.details.text;
    [self.managedObjectContext save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
