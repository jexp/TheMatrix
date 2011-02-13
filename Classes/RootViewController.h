//
//  RootViewController.h
//  TheMatrix
//
//  Created by Michael Hunger on 13.02.11.
//  Copyright 2011 jexp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NodeViewController.h"

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
