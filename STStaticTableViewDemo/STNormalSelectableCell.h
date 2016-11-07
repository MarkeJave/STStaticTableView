//
//  STNormalSelectableCell.h
//  ThaiynMall
//
//  Created by Marke Jave on 16/3/31.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "STStaticTableView.h"

@interface STNormalSelectableCellModel : STNormalCellModel

@property (nonatomic, copy  ) NSString *selectedTitle;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, copy  ) NSString *selectedSubTitle;
@property (nonatomic, strong) UIColor *selectedSubTitleColor;

@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *selectedContentColor;

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *selectedAccessoryImage;
@property (nonatomic, strong) UIView *selectedDetailAccessoryView;

@end

@interface STNormalSelectableCell : STNormalCell

@property (nonatomic, strong) STNormalSelectableCellModel *model;

@end
