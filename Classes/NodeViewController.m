//
//  NodeViewController.m
//  TheMatrix
//
//  Created by Michael Hunger on 13.02.11.
//  Copyright 2011 jexp. All rights reserved.
//

#import "NodeViewController.h"


@implementation NodeViewController

@synthesize nodeUri,data, propertyKeys, allRelationships,titleProperties;

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSString*) titleFrom:(NSDictionary*) propertyContainer {
	NSDictionary* props=[propertyContainer objectForKey: @"data"];
	if (!props) return @"";
	for (NSString* prop in self.titleProperties) {
		id value=[props objectForKey:prop];
		if (value) return [value description];
	}
	return @"";
}
- (id) loadJsonFrom: (NSString*) uri {
	NSError *error = nil;
	NSURL* url=[NSURL URLWithString:uri];
	NSData* jsonData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error]; 
	if (error) {
		NSLog(@"Error reading url %@ \n%@",url, error);
	}
	id result=[[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
	if (error) {
		NSLog(@"Error parsing json %@ \n %@",error,[jsonData description]);
	}
	return result;
}
- (void) loadData {
	self.data = [NSMutableDictionary dictionaryWithDictionary:[self loadJsonFrom:self.nodeUri]];
	self.title=[self titleFrom:self.data];

	NSLog(@"Data %@ \n",self.data);
	self.propertyKeys = [((NSDictionary*)[self.data objectForKey:@"data"]) allKeys];
	self.propertyKeys = [self.propertyKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	self.allRelationships = [self loadJsonFrom:[self.data objectForKey:@"all_relationships"]];
	
}

- (void) setNodeUri:(NSString *) uri {
	[uri retain];
	[nodeUri release];
	nodeUri = uri;
	[self loadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Node";
		case 1:
			return @"Properties";
		case 2:
			return @"Relationships";
	}
	return nil;
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case 0:
			return 1;
		case 1:
			return [self.propertyKeys count];
		case 2:
			return [self.allRelationships count];
	}
    return 0;
}

- (BOOL) isOutgoingRelationship: (NSDictionary*) relationship {
	return [[relationship objectForKey:@"start"] isEqualToString: self.nodeUri];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [self tableView:tableView titleForHeaderInSection:indexPath.section];    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (indexPath.section==1) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		} else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
    }
    
    switch (indexPath.section) {
		case 0:
			cell.textLabel.text = self.title=[self titleFrom:self.data];
			cell.detailTextLabel.text = [self.data objectForKey:@"self"]; //self.nodeUri;
			break;
		case 1: {
			NSString* key=[self.propertyKeys objectAtIndex:indexPath.row];
			cell.textLabel.text = key;
			cell.detailTextLabel.text = [[[self.data objectForKey:@"data"] objectForKey:key] description];
			break;
		}
		case 2: {
			NSDictionary* relationship=[self.allRelationships objectAtIndex: indexPath.row];
			cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",[self titleFrom:relationship],[relationship objectForKey:@"type"]]; // todo main-prop
			if ([self isOutgoingRelationship:relationship]) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.imageView.image = [UIImage imageNamed:@"empty_left.png"];
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.imageView.image = [UIImage imageNamed:@"disclosure_left.png"];
			}
			cell.detailTextLabel.text = [relationship objectForKey:@"end"];
			break;
		}
	}
	
    return cell;
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
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section!=2) return;
	NSDictionary* relationship=[self.allRelationships objectAtIndex: indexPath.row];
	NodeViewController *detailViewController = [[NodeViewController alloc] initWithNibName:@"NodeViewController" bundle:nil];
	detailViewController.titleProperties = self.titleProperties;
	detailViewController.nodeUri = [relationship objectForKey: [self isOutgoingRelationship:relationship] ? @"end" : @"start"];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

