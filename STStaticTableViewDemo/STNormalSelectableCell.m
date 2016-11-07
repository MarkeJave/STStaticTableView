//
//  STNormalSelectableCell.m
//  ThaiynMall
//
//  Created by Marke Jave on 16/3/31.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "STNormalSelectableCell.h"

@implementation STNormalSelectableCellModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setSelectable:YES];
    }
    return self;
}

- (Class)cellClass{
    if (!_cellClass) {
        _cellClass = [STNormalSelectableCell class];
    }
    return _cellClass;
}

@end;

@interface STNormalCell (Private)

- (void)configSubViews;

@end

@implementation STNormalSelectableCell
@dynamic model;

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];

    [self configSubViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    [self configSubViews];
}

- (void)configSubViews{
    [super configSubViews];
    if ([[self model] selected]) {
        if ([[self model] selectedImage]) {
            [[self imageView] setImage:[[self model] selectedImage]];
        }
        if ([[self model] selectedTitle]) {
            [[self textLabel] setText:[[self model] selectedTitle]];
        }
        if ([[self model] selectedSubTitle]) {
            [[self detailTextLabel] setText:[[self model] selectedSubTitle]];
        }
        if ([[self model] selectedTitleColor]) {
            [[self textLabel] setTextColor:[[self model] selectedTitleColor]];
        }
        if ([[self model] selectedSubTitleColor]) {
            [[self detailTextLabel] setTextColor:[[self model] selectedSubTitleColor]];
        }
        if ([[self model] selectedBackgroundColor]) {
            [self setBackgroundColor:[[self model] selectedBackgroundColor]];
        }
        if ([[self model] selectedContentColor]) {
            [[self contentView] setBackgroundColor:[[self model] selectedContentColor]];
        }
        if ([[self model] accessoryType] == UITableViewCellAccessoryDetailButton ||
            [[self model] accessoryType] == UITableViewCellAccessoryDetailDisclosureButton) {
            
            if ([[self model] selectedDetailAccessoryView]) {
                [self setAccessoryView:[[self model] selectedDetailAccessoryView]];
            }
            else if ([[self model] selectedAccessoryImage]){
                [self setAccessoryView:[[UIImageView alloc] initWithImage:[[self model] selectedAccessoryImage]]];
            }
        }
    }
}

@end
