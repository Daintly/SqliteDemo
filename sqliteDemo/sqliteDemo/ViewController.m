//
//  ViewController.m
//  sqliteDemo
//
//  Created by renwen on 2018/7/31.
//  Copyright © 2018年 renwen. All rights reserved.
//

#import "ViewController.h"
#import "DataModel.h"
#import "DBOperation.h"

#import "DBManager.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITextField *textfield;
}
@property (nonatomic, strong) UITableView *talbleView;

@property (nonatomic ,copy) NSMutableArray *arr;
@property (nonatomic, strong)DBOperation *dbOperation ;

@end

@implementation ViewController
    


- (IBAction)add:(UIButton *)sender {
    [textfield resignFirstResponder];
    
    DataModel *model = [DataModel new];
    model.userid = [NSString stringWithFormat:@"%d",arc4random() % 9 + 1000];
    model.content = textfield.text;
    model.date = [NSDate date];
    
    model.minindex = arc4random() % 9;
    model.isNumber = arc4random() % 2;
  
    [_dbOperation addData:model];
    [_arr removeAllObjects];
    
    [_arr addObjectsFromArray:[_dbOperation selectall]];
    [self.talbleView reloadData];
  
}
- (IBAction)delete:(id)sender {
//    DataModel * model = [DataModel new];
//    model.userid = @"1001";
//    [_dbOperation deleteData:model];

}
- (IBAction)update:(id)sender {
}
- (IBAction)query:(id)sender {
       [textfield resignFirstResponder];
    
    [_arr removeAllObjects];
    [_arr addObject:[_dbOperation getdbdataByuserid:textfield.text]];

    [self.talbleView reloadData];
}
//清除数据库
- (void)deletTable{
    [_dbOperation dropBaseTable];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"清除数据库" style:UIBarButtonItemStyleDone target:self action:@selector(deletTable)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"view" owner:nil options:nil]firstObject];
    _arr = [NSMutableArray new];
    headerView.frame = CGRectMake(0, 64,self.view.bounds.size.width, 40);
    headerView.backgroundColor = [UIColor whiteColor];
    
   
    
    [self.view addSubview:headerView];
 textfield = [[UITextField alloc] init];
    
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.placeholder = @"添加数据";
    
    textfield.frame = CGRectMake(0, 104, self.view.bounds.size.width, 40);
    self.talbleView.tableHeaderView = textfield;
    self.dbOperation = [DBOperation dataBaseManager];
    [_arr addObjectsFromArray:[_dbOperation selectall]];
    [self.talbleView reloadData];

}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    DataModel *model = _arr[indexPath.row];
    cell.textLabel.text = model.userid;
    cell.detailTextLabel.text = model.content;
    return cell;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld == %ld",indexPath.row, indexPath.section);
    __weak typeof(self) weakSelf = self;

    UITableViewRowAction *loseAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        DataModel * model = weakSelf.arr[indexPath.row];
        model.userid = model.userid;
   
        [weakSelf.dbOperation deleteData:model];
        [weakSelf.arr removeObject:model];
        [weakSelf.talbleView reloadData];
    }];
    loseAction.backgroundColor = [UIColor redColor];
    return @[loseAction];
}

- (UITableView *)talbleView{
    if (!_talbleView) {
        _talbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height - 104)];
        self.talbleView.delegate = self;
        self.talbleView.dataSource = self;
        [self.view addSubview:_talbleView];
        _talbleView.tableFooterView = [UIView new];
        _talbleView.rowHeight = 40;
    }return _talbleView;
}
@end
