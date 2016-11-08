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
    STEditableCellModel *cellModel = [[STEditableCellModel alloc] initWithTitle:@"收货人：" subtitle:nil
                                                                    placeholder:@"请输入姓名" style:UITableViewCellStyleValue2
                                                                         target:self action:@selector(didReceiverChanged:)];
    cellModel.height = 45;
    cellModel.textColor = [UIColor grayColor];
    cellModel.font = [UIFont systemFontOfSize:14];
    cellModel.keyValues = @{@"accessoryType":@(UITableViewCellAccessoryDisclosureIndicator)};
    [cellModels addObject:cellModel];
    
    cellModel = [[STEditableCellModel alloc] initWithTitle:@"手机号码：" subtitle:nil
                                               placeholder:@"请输入手机号码" style:UITableViewCellStyleValue2
                                                    target:self action:@selector(didTelephoneChanged:)];
    cellModel.height = 45;
    cellModel.textColor = [UIColor grayColor];
    cellModel.font = [UIFont systemFontOfSize:14];
    cellModel.keyboardType = UIKeyboardTypeNumberPad;
    [cellModels addObject:cellModel];
    
    cellModel = [[STEditableCellModel alloc] initWithTitle:@"所在地区：" subtitle:nil
                                               placeholder:@"" style:UITableViewCellStyleValue2
                                                    target:self action:@selector(didClickDistrict:)];
    cellModel.height = 45;
    cellModel.editable = NO;
    cellModel.textColor = [UIColor grayColor];
    cellModel.style = UITableViewCellStyleValue2;
    cellModel.font = [UIFont systemFontOfSize:14];
    cellModel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cellModels addObject:cellModel];
    
    cellModel = [[STEditableCellModel alloc] initWithTitle:@"详细地址：" subtitle:nil
                                               placeholder:@"请输入详细地址" style:UITableViewCellStyleValue2
                                                    target:self action:@selector(didDetailAddresssChanged:)];
    cellModel.height = 45;
    cellModel.textColor = [UIColor grayColor];
    cellModel.font = [UIFont systemFontOfSize:14];
    [cellModels addObject:cellModel];
    
    STNormalSectionModel *sectionModel = [[STNormalSectionModel alloc] initWithCellModels:cellModels];
    sectionModel.headerViewHeight = 20;
    [sectionModels addObject:sectionModel];
    
    cellModels = [NSMutableArray array];
    STNormalSelectableCellModel *selectableCellModel = [[STNormalSelectableCellModel alloc] initWithTitle:@"支付宝："
                                                                                                 subtitle:nil
                                                                                                    style:UITableViewCellStyleDefault
                                                                                                   target:self
                                                                                                   action:@selector(didSelectedAlipay:)];
    selectableCellModel.height = 45;
    selectableCellModel.selected = YES;
    selectableCellModel.image = [UIImage imageNamed:@"i_checkbx_off"];
    selectableCellModel.selectedImage = [UIImage imageNamed:@"i_checkbx_on"];
    [cellModels addObject:selectableCellModel];
    
    selectableCellModel = [[STNormalSelectableCellModel alloc] initWithTitle:@"微信："
                                                                    subtitle:nil
                                                                       style:UITableViewCellStyleDefault
                                                                      target:self
                                                                      action:@selector(didSelectedWechat:)];
    selectableCellModel.height = 45;
    selectableCellModel.image = [UIImage imageNamed:@"i_checkbx_off"];
    selectableCellModel.selectedImage = [UIImage imageNamed:@"i_checkbx_on"];
    
    [cellModels addObject:selectableCellModel];
    
    sectionModel = [[STNormalSectionModel alloc] initWithCellModels:cellModels];
    sectionModel.headerTitle = @"选择支付方式";
    sectionModel.headerViewHeight = 40;
    
    [sectionModels addObject:sectionModel];
    
    self.staticTableView.cellSectionModels = sectionModels;
}

#pragma mark - static tableview callback

- (IBAction)didReceiverChanged:(STNormalCellModel *)model{}

- (IBAction)didTelephoneChanged:(STNormalCellModel *)model{}

- (IBAction)didClickDistrict:(STNormalCellModel *)model{}

- (IBAction)didDetailAddresssChanged:(STNormalCellModel *)model{}

- (IBAction)didSelectedAlipay:(STNormalCellModel *)model{}

- (IBAction)didSelectedWechat:(STNormalCellModel *)model{}

@end
