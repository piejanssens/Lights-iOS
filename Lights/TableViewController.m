//
//  TableViewController.m
//  Lights
//
//  Created by Pieter Janssens on 15/12/13.
//  Copyright (c) 2013 Pieter Janssens. All rights reserved.
//

#import "TableViewController.h"
#import "SwitchDetailViewController.h"

@interface TableViewController () {
    NSMutableArray* buttons;
}

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    buttons = [[[NSUserDefaults standardUserDefaults] objectForKey:@"buttons"] mutableCopy];
    if (!buttons) {
        buttons = [@[@[@{@"switch":@"1", @"label": @"Switch 1"}], @[@{@"switch":@"2", @"label": @"Switch 2"}], @[@{@"switch":@"3",@"label": @"Switch 3"}], @[@{@"switch":@"4",@"label":@"Switch 4"}]] mutableCopy];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.label) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableArray *fromGroupSwitches = [[NSMutableArray arrayWithArray:[buttons objectAtIndex:indexPath.section]] mutableCopy];
        NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithDictionary:[fromGroupSwitches objectAtIndex:indexPath.row]] mutableCopy];
        [dic setValue:self.label forKey:@"label"];
        [fromGroupSwitches setObject:[dic copy] atIndexedSubscript:indexPath.row];
        [buttons setObject:fromGroupSwitches atIndexedSubscript:indexPath.section];
        [self.tableView reloadData];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        [self saveSetup];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [self saveSetup];
}

- (void)saveSetup {
    [[NSUserDefaults standardUserDefaults] setObject:buttons forKey:@"buttons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return buttons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [NSArray arrayWithArray:[buttons objectAtIndex:section]].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *groupSwitches = [NSArray arrayWithArray:[buttons objectAtIndex:section]];
    if (groupSwitches.count==0) {
        return [NSString stringWithFormat:@"Group %ld", (long)section+1];
    }
    else {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[groupSwitches objectAtIndex:0]];
        return [dic valueForKey:@"label"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *groupSwitches = [NSArray arrayWithArray:[buttons objectAtIndex:indexPath.section]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[groupSwitches objectAtIndex:indexPath.row]];
    cell.textLabel.text = [dic valueForKey:@"label"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Switch %@", [dic valueForKey:@"switch"]];
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *fromGroupSwitches = [[buttons objectAtIndex:fromIndexPath.section] mutableCopy];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[fromGroupSwitches objectAtIndex:fromIndexPath.row]];
    [fromGroupSwitches removeObjectAtIndex:fromIndexPath.row];
    [buttons setObject:fromGroupSwitches atIndexedSubscript:fromIndexPath.section];

    NSMutableArray *toGroupSwitches = [[buttons objectAtIndex:toIndexPath.section] mutableCopy];
    [toGroupSwitches insertObject:dic atIndex:toIndexPath.row];
    [buttons setObject:toGroupSwitches atIndexedSubscript:toIndexPath.section];
    
    NSArray *tempButtons = [buttons copy];
    NSInteger i = 0;
    for (NSArray *array in tempButtons) {
        if (array.count == 0) {
            [buttons removeObjectAtIndex:i];
            [buttons setObject:array atIndexedSubscript:buttons.count];
        }
        i++;
    }
    
    [tableView reloadData];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SwitchDetailViewController *vc = segue.destinationViewController;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    self.label = cell.textLabel.text;
    vc.label = self.label;
}

@end
