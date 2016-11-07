//
//  ViewController.m
//  STStaticTableViewDemo
//
//  Created by xulinfeng on 2016/11/7.
//  Copyright © 2016年 markejave. All rights reserved.
//

#import "ViewController.h"
#import "STStaticTableView.h"
#import "STNormalSelectableCell.h"

@interface ViewController ()

@property (nonatomic, strong) STStaticTableView *staticTableView;

@end

@implementation ViewController

- (void)loadView{
    [super loadView];
    [[self view] addSubview:[self staticTableView]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[[self staticTableView] tableView] setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    
    [self reloadTableViewData];
}

#pragma mark - accessory

- (STStaticTableView *)staticTableView{
    if (!_staticTableView) {
        _staticTableView = [[STStaticTableView alloc] initWithStyle:UITableViewStyleGrouped];
        _staticTableView.frame = [[self view] bounds];
    }
    return _staticTableView;
}

#pragma mark - private

- (void)reloadTableViewData{
    
    NSMutableArray *sectionModels = [NSMutableArray array];
    NSMutableArray *cellModels = [NSMutableArray array];
    STEditableCellModel *cellModel = [[STEditableCellModel alloc] initWithTitle:@"收货人：" subTitle:nil
                                                                    placeholder:@"请输入姓名" style:UITableViewCellStyleValue2
                                                                         target:self action:@selector(didReceiverChanged:)];
    [cellModel setHeight:45];
    [cellModel setTextColor:[UIColor grayColor]];
    [cellModel setFont:[UIFont systemFontOfSize:14]];
    [cellModel setKeyValues:@{@"accessoryType":@(UITableViewCellAccessoryDisclosureIndicator)}];
    [cellModels addObject:cellModel];
    
    cellModel = [[STEditableCellModel alloc] initWithTitle:@"手机号码：" subTitle:nil
                                               placeholder:@"请输入手机号码" style:UITableViewCellStyleValue2
                                                    target:self action:@selector(didTelephoneChanged:)];
    [cellModel setHeight:45];
    [cellModel setTextColor:[UIColor grayColor]];
    [cellModel setFont:[UIFont systemFontOfSize:14]];
    [cellModel setKeyboardType:UIKeyboardTypeNumberPad];
    [cellModels addObject:cellModel];
    
    cellModel = [[STEditableCellModel alloc] initWithTitle:@"所在地区：" subTitle:nil
                                               placeholder:@"" style:UITableViewCellStyleValue2
                                                    target:self action:@selector(didClickDistrict:)];
    [cellModel setHeight:45];
    [cellModel setEditable:NO];
    [cellModel setStyle:UITableViewCellStyleValue2];
    [cellModel setTextColor:[UIColor grayColor]];
    [cellModel setFont:[UIFont systemFontOfSize:14]];
    [cellModel setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cellModels addObject:cellModel];
    
    cellModel = [[STEditableCellModel alloc] initWithTitle:@"详细地址：" subTitle:nil
                                               placeholder:@"请输入详细地址" style:UITableViewCellStyleValue2
                                                    target:self action:@selector(didDetailAddresssChanged:)];
    [cellModel setHeight:45];
    [cellModel setTextColor:[UIColor grayColor]];
    [cellModel setFont:[UIFont systemFontOfSize:14]];
    [cellModels addObject:cellModel];
    
    STNormalSectionModel *sectionModel = [[STNormalSectionModel alloc] initWithCellModels:cellModels];
    [sectionModel setHeaderViewHeight:10];
    [sectionModels addObject:sectionModel];
    
    cellModels = [NSMutableArray array];
    STNormalSelectableCellModel *selectableCellModel = [[STNormalSelectableCellModel alloc] initWithTitle:@"支付宝："
                                                                                                 subTitle:nil
                                                                                                    style:UITableViewCellStyleDefault
                                                                                                   target:self
                                                                                                   action:@selector(didSelectedAlipay:)];
    [selectableCellModel setHeight:45];
    [selectableCellModel setSelected:YES];
    [selectableCellModel setImage:[UIImage imageNamed:@"i_checkbx_off"]];
    [selectableCellModel setSelectedImage:[UIImage imageNamed:@"i_checkbx_on"]];
    [cellModels addObject:selectableCellModel];
    
    selectableCellModel = [[STNormalSelectableCellModel alloc] initWithTitle:@"微信："
                                                                    subTitle:nil
                                                                       style:UITableViewCellStyleDefault
                                                                      target:self
                                                                      action:@selector(didSelectedWechat:)];
    [selectableCellModel setHeight:45];
    [selectableCellModel setImage:[UIImage imageNamed:@"i_checkbx_off"]];
    [selectableCellModel setSelectedImage:[UIImage imageNamed:@"i_checkbx_on"]];
    [cellModels addObject:selectableCellModel];
    
    sectionModel = [[STNormalSectionModel alloc] initWithCellModels:cellModels];
    [sectionModel setHeaderTitle:@"选择支付方式"];
    [sectionModel setHeaderViewHeight:40];
    [sectionModels addObject:sectionModel];
    
    [[self staticTableView] setCellSectionModels:sectionModels];
}

#pragma mark - static tableview callback

- (IBAction)didReceiverChanged:(STNormalCellModel *)model{}

- (IBAction)didTelephoneChanged:(STNormalCellModel *)model{}

- (IBAction)didClickDistrict:(STNormalCellModel *)model{}

- (IBAction)didDetailAddresssChanged:(STNormalCellModel *)model{}

- (IBAction)didSelectedAlipay:(STNormalCellModel *)model{}

- (IBAction)didSelectedWechat:(STNormalCellModel *)model{}

@end
