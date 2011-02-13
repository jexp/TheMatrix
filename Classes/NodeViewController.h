//
//  NodeViewController.h
//  TheMatrix
//
//  Created by Michael Hunger on 13.02.11.
//  Copyright 2011 jexp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"

@interface NodeViewController : UITableViewController {

}

@property (nonatomic,retain) NSString* nodeUri;
@property (nonatomic,retain) NSMutableDictionary* data;
@property (nonatomic,retain) NSArray* propertyKeys;
@property (nonatomic,retain) NSArray* allRelationships;
@property (nonatomic,retain) NSSet*  titleProperties;
@end
