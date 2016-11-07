//
//  STStaticTableView.m
//  STStaticTableView
//
//  Created by Marike Jave on 15/9/9.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//
#import "STStaticTableView.h"
#import <objc/runtime.h>

const CGFloat STNormalCellHeight = 44;
const CGFloat STEditableCellHeight = 50;

@implementation STNormalCellModel

- (void)dealloc{
    [self setTitle:nil];
    [self setSubTitle:nil];
    [self setCellClass:nil];
    [self setAction:nil];
    [self setTarget:nil];
    [self setUserInfo:nil];
    [self setModelCallback:nil];
}

- (id)initWithTitle:(NSString *)title;{
    return [self initWithTitle:title subTitle:nil style:UITableViewCellStyleDefault];
}

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle;{
    return [self initWithTitle:title subTitle:subTitle style:UITableViewCellStyleSubtitle];
}

- (id)initWithTitle:(NSString *)title
         detailText:(NSString *)detailText{
    return [self initWithTitle:title subTitle:detailText style:UITableViewCellStyleValue1];
}

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
              style:(UITableViewCellStyle)style;{
    return [self initWithTitle:title subTitle:subTitle style:style modelCallback:nil];
}

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
              style:(UITableViewCellStyle)style
      modelCallback:(void (^)(STNormalCellModel* model))modelCallback;{
    self = [self init];
    if (self) {
        [self setStyle:style];
        [self setTitle:title];
        [self setSubTitle:subTitle];
        [self setModelCallback:modelCallback];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
              style:(UITableViewCellStyle)style
             target:(id)target
             action:(SEL)action;{
    self = [self init];
    if (self) {
        [self setTitle:title];
        [self setSubTitle:subTitle];
        [self setStyle:style];
        [self setTarget:target];
        [self setAction:action];
    }
    return self;
}

- (Class)cellClass{
    if (!_cellClass) {
        _cellClass = [STNormalCell class];
    }
    return _cellClass;
}

- (CGFloat)height{
    if (_height <= 0) {
        return STNormalCellHeight;
    }
    return _height;
}

- (BOOL)enableAction{
    return ([self target] && [self action]) || [self modelCallback];
}

- (void)performAction{
    if ([self enableAction]){
        if ([self target] && [[self target] respondsToSelector:[self action]]) {
            [[self target] performSelector:[self action] withObject:self];
        } else if ([self modelCallback]){
            self.modelCallback(self);
        }
    }
}

@end

@implementation STTextCellModel

- (STTableViewCellLayoutStyle)layoutStyle{
    return STTableViewCellLayoutStyleAutolayout;
}

- (Class)cellClass{
    if (!_cellClass) {
        _cellClass = [STTextCell class];
    }
    return _cellClass;
}

@end

@implementation STEditableCellModel

- (id)init{
    self = [super init];
    if (self) {
        [self setEditable:YES];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style{
    return [self initWithTitle:title subTitle:subTitle placeholder:placeholder style:style modelCallback:nil];
}

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style
             target:(id)target
             action:(SEL)action;{
    self = [super initWithTitle:title
                       subTitle:subTitle
                          style:style
                         target:target
                         action:action];
    if (self) {
        [self setPlaceholder:placeholder];
        [self setTextAlignment:NSTextAlignmentNatural];
        [self copyStyle:[UITextField appearance]];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style
      modelCallback:(void (^)(STNormalCellModel* model))modelCallback;{
    self = [super initWithTitle:title
                       subTitle:subTitle
                          style:style
                  modelCallback:modelCallback];
    if (self) {
        self.placeholder = placeholder;
        self.textAlignment = NSTextAlignmentNatural;
        [self copyStyle:[UITextField appearance]];
    }
    return self;
}

- (void)copyStyle:(UITextField<UIAppearance> *)appearance;{
    self.clearsOnBeginEditing = [appearance clearsOnBeginEditing];
    self.adjustsFontSizeToFitWidth =[appearance adjustsFontSizeToFitWidth];
    self.minimumFontSize = [appearance minimumFontSize];
    self.background = [appearance background];
    self.disabledBackground = [appearance disabledBackground];
    self.clearButtonMode = [appearance clearButtonMode];
    self.leftView = [appearance leftView];
    self.leftViewMode = [appearance leftViewMode];
    self.rightView = [appearance rightView];
    self.rightViewMode = [appearance rightViewMode];
    self.autocapitalizationType = [appearance autocapitalizationType];
    self.autocorrectionType = [appearance autocorrectionType];
    self.spellCheckingType = [appearance spellCheckingType];
    self.keyboardType = [appearance keyboardType];
    self.keyboardAppearance = [appearance keyboardAppearance];
    self.returnKeyType = [appearance returnKeyType];
}

- (CGFloat)height{
    if (_height <= 0) {
        return STEditableCellHeight;
    }
    return _height;
}

- (Class)cellClass{
    if (!_cellClass) {
        _cellClass = [STEditableCell class];
    }
    return _cellClass;
}

- (NSTextAlignment)titleAlignment{
    if ([self style] == UITableViewCellStyleValue2) {
        return NSTextAlignmentRight;
    }
    return _textAlignment;
}

@end

@interface STNormalSectionModel ()

@property(nonatomic, strong) NSMutableArray<STNormalCellModel *> *evMuatableCellModels;

@end

@implementation STNormalSectionModel

- (id)initWithCellModels:(NSArray *)cellModels;{
    self = [self init];
    if (self) {
        [self setCellModels:[cellModels copy]];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        self.footerViewHeight = 0.1;
    }
    return self;
}

- (NSMutableArray *)evMuatableCellModels{
    if (!_evMuatableCellModels) {
        _evMuatableCellModels = [NSMutableArray array];
    }
    return _evMuatableCellModels;
}

- (NSArray *)cellModels{
    return [self evMuatableCellModels];
}

- (void)setCellModels:(NSArray *)cellModels{
    [[self evMuatableCellModels] removeAllObjects];
    [[self evMuatableCellModels] addObjectsFromArray:cellModels];
}

- (Class<STNormalSectionViewInterface>)headerViewClass{
    if (!_headerViewClass) {
        _headerViewClass = [STNormalSectionView class];
    }
    return _headerViewClass;
}

- (Class<STNormalSectionViewInterface>)footerViewClass{
    if (!_footerViewClass) {
        _footerViewClass = [STNormalSectionView class];
    }
    return _footerViewClass;
}

@end


@interface STNormalSectionModel (Private)

@property(nonatomic, strong) NSMutableArray<STNormalCellModel *> *evMuatableCellModels;

@end

@implementation UITableViewCell (NormalCellModel)

+ (void)load{
    [super load];
    
    SEL originInitializeSelector = @selector(initWithStyle:reuseIdentifier:);
    SEL swizzleInitializeSelector = @selector(swizzle_initWithStyle:reuseIdentifier:);
    Method originInitializeMethod = class_getClassMethod(self, originInitializeSelector);
    Method swizzleInitializeMethod = class_getClassMethod(self, swizzleInitializeSelector);
    
    class_addMethod(self, originInitializeSelector, class_getMethodImplementation(self, originInitializeSelector), method_getTypeEncoding(originInitializeMethod));
    class_addMethod(self, swizzleInitializeSelector, class_getMethodImplementation(self, swizzleInitializeSelector), method_getTypeEncoding(swizzleInitializeMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originInitializeSelector), class_getInstanceMethod(self, swizzleInitializeSelector));
    
    SEL originSetSelectedSelector = @selector(setSelected:animated:);
    SEL swizzleSetSelectedSelector = @selector(swizzle_setSelected:animated:);
    Method originSetSelectedMethod = class_getClassMethod(self, originSetSelectedSelector);
    Method swizzleSetSelectedMethod = class_getClassMethod(self, swizzleSetSelectedSelector);
    
    class_addMethod(self, originSetSelectedSelector, class_getMethodImplementation(self, originSetSelectedSelector), method_getTypeEncoding(originSetSelectedMethod));
    class_addMethod(self, swizzleSetSelectedSelector, class_getMethodImplementation(self, swizzleSetSelectedSelector), method_getTypeEncoding(swizzleSetSelectedMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originSetSelectedSelector), class_getInstanceMethod(self, swizzleSetSelectedSelector));
}

- (instancetype)swizzle_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    UITableViewCell *cell = [self swizzle_initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [cell createSubViews];
    [cell configSubViewsDefault];
    [cell installConstraints];
    
    return cell;
}

- (void)setModel:(STNormalCellModel *)model{
    objc_setAssociatedObject(self, @selector(model), model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self configSubViews];
}

- (STNormalCellModel *)model{
    return objc_getAssociatedObject(self, @selector(model));
}

- (void)swizzle_setSelected:(BOOL)selected animated:(BOOL)animated{
    [self swizzle_setSelected:selected animated:animated];
    self.model.selected = selected;
}

- (void)configSubViews{
    
    [[self imageView] setImage:[[self model] image]];
    [[self textLabel] setText:[[self model] title]];
    [[self detailTextLabel] setText:[[self model] subTitle]];
    if ([[self model] titleColor]) {
        [[self textLabel] setTextColor:[[self model] titleColor]];
    } else {
        [[self textLabel] setTextColor:[UIColor blackColor]];
    }
    if ([[self model] titleFont]) {
        [[self textLabel] setFont:[[self model] titleFont]];
    } else {
        [[self textLabel] setFont:[UIFont systemFontOfSize:44/3.]];
    }
    if ([[self model] subTitleColor]) {
        [[self detailTextLabel] setTextColor:[[self model] subTitleColor]];
    } else {
        [[self detailTextLabel] setTextColor:[UIColor lightGrayColor]];
    }
    if ([[self model] subTitleFont]) {
        [[self detailTextLabel] setFont:[[self model] subTitleFont]];
    } else {
        [[self detailTextLabel] setFont:[UIFont systemFontOfSize:36/3.]];
    }
    [self setSelectionStyle:[[self model] selectionStyle]];
    [self setAccessoryType:[[self model] accessoryType]];
}

+ (CGFloat)tableView:(UITableView *)tableView heightWithModel:(STNormalCellModel *)model{
    return [model height];
}

@end

@interface STNormalCell ()

@end

@implementation STNormalCell

- (void)configSubViewsDefault{
    [super configSubViewsDefault];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[self textLabel] setTextColor:[UIColor blackColor]];
    [[self textLabel] setFont:[UIFont systemFontOfSize:44/3.]];
    [[self detailTextLabel] setTextColor:[UIColor lightGrayColor]];
    [[self detailTextLabel] setFont:[UIFont systemFontOfSize:36/3.]];
}

- (void)configSubViews{
    [super configSubViews];
    [[self imageView] setImage:[[self model] image]];
    [[self textLabel] setText:[[self model] title]];
    [[self detailTextLabel] setText:[[self model] subTitle]];
    [[self textLabel] setNumberOfLines:[[self model] titleNumberOfLines]];
    [[self detailTextLabel] setNumberOfLines:[[self model] subTitleNumberOfLines]];
    [[self textLabel] setTextAlignment:[[self model] titleAlignment]];
    [[self detailTextLabel] setTextAlignment:[[self model] subTitleAlignment]];
    [[self textLabel] setLineBreakMode:[[self model] titleLineBreakMode]];
    [[self detailTextLabel] setLineBreakMode:[[self model] subTitleLineBreakMode]];
    [self setSelectionStyle:[[self model] selectionStyle]];
    [self setAccessoryType:[[self model] accessoryType]];
    if ([[self model] titleColor]) {
        [[self textLabel] setTextColor:[[self model] titleColor]];
    } else {
        [[self textLabel] setTextColor:[UIColor blackColor]];
    }
    if ([[self model] titleFont]) {
        [[self textLabel] setFont:[[self model] titleFont]];
    } else {
        [[self textLabel] setFont:[UIFont systemFontOfSize:44/3.]];
    }
    if ([[self model] subTitleColor]) {
        [[self detailTextLabel] setTextColor:[[self model] subTitleColor]];
    } else {
        [[self detailTextLabel] setTextColor:[UIColor grayColor]];
    }
    if ([[self model] subTitleFont]) {
        [[self detailTextLabel] setFont:[[self model] subTitleFont]];
    } else {
        [[self detailTextLabel] setFont:[UIFont systemFontOfSize:36/3.]];
    }
    if ([[self model]  backgroundColor]) {
        [self setBackgroundColor:[[self model]  backgroundColor]];
    }
    if ([[self model] contentColor]) {
        [[self contentView] setBackgroundColor:[[self model] contentColor]];
    }
    if ([[self model] accessoryType] == UITableViewCellAccessoryDetailButton ||
        [[self model] accessoryType] == UITableViewCellAccessoryDetailDisclosureButton) {
        if ([[self model] detailAccessoryView]) {
            [self setAccessoryView:[[self model] detailAccessoryView]];
        } else if ([[self model] accessoryImage]){
            [self setAccessoryView:[[UIImageView alloc] initWithImage:[[self model] accessoryImage]]];
        }
    }
    if ([[self model] keyValues]) {
        [self setValuesForKeysWithDictionary:[[self model] keyValues]];
    }
}

@end

@interface STTextCell ()

@end

@implementation STTextCell

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize contentSize = [[self textLabel] sizeThatFits:CGSizeMake(CGRectGetWidth([self bounds]), CGFLOAT_MAX)];
    return CGSizeMake(contentSize.width, contentSize.height + 16 * 2);
}

@end

@interface STEditableCell ()

@property(nonatomic, strong) UITextField *detailTextField;

@property(nonatomic, assign) UITableViewCellStyle style;

@end

@implementation STEditableCell
@dynamic model;

- (void)dealloc{
    self.detailTextField = nil;
    self.model = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    [self setStyle:style];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self relayoutSubViews:[[self contentView] bounds]];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightWithModel:(STEditableCellModel *)model{
    return [model height];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self relayoutSubViews:[[self contentView] bounds]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self relayoutSubViews:[[self contentView] bounds]];
}

- (void)createSubViews{
    self.detailTextField = [[UITextField alloc] init];
    [[self contentView] addSubview:[self detailTextField]];
}

- (void)configSubViews{
    [super configSubViews];
    [[self detailTextField] addTarget:self action:@selector(didTextChanged:)
                     forControlEvents:UIControlEventEditingChanged];
    [[self detailTextField] setEnabled:[[self model] editable]];
    [[self detailTextField] setText:[[self model] subTitle]];
    [[self detailTextField] setPlaceholder:[[self model] placeholder]];
    [[self detailTextField] setFont:[[self model] font]];
    [[self detailTextField] setTextColor:[[self model] textColor]];
    if ([[self model] textAlignment] != NSTextAlignmentNatural) {
        [[self detailTextField] setTextAlignment:[[self model] textAlignment]];
    }
    [[self detailTextField] setClearButtonMode:[[self model] clearsOnBeginEditing]];
    [[self detailTextField] setAdjustsFontSizeToFitWidth:[[self model] adjustsFontSizeToFitWidth]];
    [[self detailTextField] setMinimumFontSize:[[self model] minimumFontSize]];
    [[self detailTextField] setBackground:[[self model] background]];
    [[self detailTextField] setDisabledBackground:[[self model] disabledBackground]];
    [[self detailTextField] setClearButtonMode:[[self model] clearButtonMode]];
    [[self detailTextField] setLeftView:[[self model] leftView]];
    [[self detailTextField] setLeftViewMode:[[self model] leftViewMode]];
    [[self detailTextField] setRightView:[[self model] rightView]];
    [[self detailTextField] setRightViewMode:[[self model] rightViewMode]];
    [[self detailTextField] setAutocapitalizationType:[[self model] autocapitalizationType]];
    [[self detailTextField] setAutocorrectionType:[[self model] autocorrectionType]];
    [[self detailTextField] setSpellCheckingType:[[self model] spellCheckingType]];
    [[self detailTextField] setKeyboardType:[[self model] keyboardType]];
    [[self detailTextField] setKeyboardAppearance:[[self model] keyboardAppearance]];
    [[self detailTextField] setReturnKeyType:[[self model] returnKeyType]];
}

- (void)configSubViewsDefault{
    [super configSubViewsDefault];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[self detailTextLabel] setAlpha:0];
    if ([self style] == UITableViewCellStyleDefault){
        [[self detailTextField] setTextAlignment:NSTextAlignmentCenter];
        [[self textLabel] setAlpha:0];
    }
    else if ([self style] == UITableViewCellStyleSubtitle || [self style] == UITableViewCellStyleValue2) {
        [[self detailTextField] setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [[self detailTextField] setTextAlignment:NSTextAlignmentRight];
    }
    [[self textLabel] setTextColor:[UIColor blackColor]];
    [[self detailTextField] setTextColor:[UIColor lightGrayColor]];
    [[self textLabel] setFont:[UIFont systemFontOfSize:44/3.]];
    [[self detailTextField] setFont:[UIFont systemFontOfSize:36/3.]];
}

- (void)relayoutSubViews:(CGRect)bounds{
    if ([self style] == UITableViewCellStyleDefault){
        [[self detailTextField] setFrame:bounds];
    }
    else if ([self style] == UITableViewCellStyleSubtitle){
        [[self detailTextField] setFrame:CGRectMake([self layoutMargins].left, CGRectGetMaxY([[self textLabel] frame]), CGRectGetWidth(bounds) - [self layoutMargins].left - [[self contentView] layoutMargins].right, CGRectGetHeight(bounds) - CGRectGetMaxY([[self textLabel] frame]))];
    }
    else if ([self style] == UITableViewCellStyleValue1){
        [[self detailTextField] setFrame:CGRectMake(CGRectGetMaxX([[self textLabel] frame]) + 8, 0, CGRectGetWidth(bounds) - CGRectGetMaxX([[self textLabel] frame]) - [[self contentView] layoutMargins].right - 8, CGRectGetHeight(bounds))];
    }
    else if ([self style] == UITableViewCellStyleValue2){
        [[self detailTextField] setFrame:CGRectMake(CGRectGetMaxX([[self textLabel] frame]) + 8, 0, CGRectGetWidth(bounds) - CGRectGetMaxX([[self textLabel] frame]) - [[self contentView] layoutMargins].right - 8, CGRectGetHeight(bounds))];
    }
}

- (IBAction)didTextChanged:(UITextField *)sender{
    [[self model] setSubTitle:[sender text]];
}

@end

@interface STNormalCell (Private)

@end

@interface STSwitchCell ()

@property(nonatomic, strong) UISwitch *evswtExchange;

@end

@implementation STSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        [self configSubViewsDefault];
    }
    return self;
}

- (void)createSubViews{
    [super createSubViews];
    [self setEvswtExchange:[[UISwitch alloc] init]];
    [self setAccessoryView:[self evswtExchange]];
}

- (void)configSubViewsDefault{
    [super configSubViewsDefault];
    [[self evswtExchange] addTarget:self action:@selector(didClickExchange:) forControlEvents:UIControlEventValueChanged];
}

- (void)configSubViews{
    [super configSubViews];
    [[self evswtExchange] setOn:[[[self model] userInfo] boolValue]];
}

#pragma mark - actions

- (IBAction)didClickExchange:(UISwitch *)sender{
    [[self model] setUserInfo:@([sender isOn])];
    [[self model] performAction];
}

@end

@implementation STNormalSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configurate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurate];
    }
    return self;
}

- (void)configurate{
    [[self contentView] setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundView:nil];
}

@end

@interface STStaticTableView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray<STNormalSectionModel *> *mutableCellSectionModels;

@property(nonatomic, strong) NSArray *defaultCellSectionModels;

@property(nonatomic, assign) UITableViewStyle style;

@end

@implementation STStaticTableView

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [self initWithStyle:style defaultCellSections:nil];
}

- (instancetype)initWithStyle:(UITableViewStyle)style defaultCellModels:(NSArray *)defaultCellModels;{
    return [self initWithStyle:style defaultCellSections:@[[[STNormalSectionModel alloc] initWithCellModels:defaultCellModels]]];
}

- (instancetype)initWithStyle:(UITableViewStyle)style defaultCellSections:(NSArray *)defaultCellSections;{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setStyle:style];
        if (defaultCellSections) {
            self.defaultCellSectionModels = [defaultCellSections copy];
        }
        [self createSubViews];
        [self configSubViewsDefault];
        [self installConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        [self configSubViewsDefault];
        [self installConstraints];
    }
    return self;
}

#pragma mark - accessory

- (NSMutableArray<STNormalSectionModel *> *)mutableCellSectionModels{
    if (!_mutableCellSectionModels) {
        _mutableCellSectionModels = [NSMutableArray<STNormalSectionModel *> array];
    }
    return _mutableCellSectionModels;
}

- (NSArray *)cellSectionModels{
    return [[self mutableCellSectionModels] copy];
}

- (void)setCellSectionModels:(NSArray *)cellSectionModels{
    [[self mutableCellSectionModels] removeAllObjects];
    [[self mutableCellSectionModels] addObjectsFromArray:cellSectionModels];
    [self reloadData];
}

#pragma mark - construct

- (void)createSubViews{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self style]];
    self.mutableCellSectionModels = [NSMutableArray arrayWithArray:[self defaultCellSectionModels]];
    
    [self addSubview:[self tableView]];
}

- (void)configSubViewsDefault{
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    [[self tableView] registerClass:[STTextCell class] forCellReuseIdentifier:NSStringFromClass([STTextCell class])];
}

- (void)installConstraints{
    [[self tableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *etMutableConstraints = [NSMutableArray array];
    NSLayoutConstraint *etConstraint = [NSLayoutConstraint constraintWithItem:[self tableView]
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1
                                                                     constant:0];
    [etMutableConstraints addObject:etConstraint];
    etConstraint = [NSLayoutConstraint constraintWithItem:[self tableView]
                                                attribute:NSLayoutAttributeRight
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                attribute:NSLayoutAttributeRight
                                               multiplier:1
                                                 constant:0];
    [etMutableConstraints addObject:etConstraint];
    etConstraint = [NSLayoutConstraint constraintWithItem:[self tableView]
                                                attribute:NSLayoutAttributeTop
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                attribute:NSLayoutAttributeTop
                                               multiplier:1
                                                 constant:0];
    [etMutableConstraints addObject:etConstraint];
    etConstraint = [NSLayoutConstraint constraintWithItem:[self tableView]
                                                attribute:NSLayoutAttributeBottom
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                attribute:NSLayoutAttributeBottom
                                               multiplier:1
                                                 constant:0];
    [etMutableConstraints addObject:etConstraint];
    [self addConstraints:etMutableConstraints];
}

#pragma mark - public

- (void)reloadData;{
    [[self tableView] reloadData];
    [[self mutableCellSectionModels] enumerateObjectsUsingBlock:^(STNormalSectionModel * sectionModel, NSUInteger section, BOOL *stop) {
        [[sectionModel cellModels] enumerateObjectsUsingBlock:^(STNormalCellModel *cellModel, NSUInteger row, BOOL *stop) {
            if ([cellModel selectable] && [cellModel selected]) {
                [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }];
    }];
}

- (void)removeAll;{
    [[self mutableCellSectionModels] removeAllObjects];
    [[self tableView] reloadData];
}

- (STNormalSectionModel *)addTitleSection:(NSString *)sectionTitle;{
    STNormalSectionModel *normalCellSectionModel = [[STNormalSectionModel alloc] init];
    normalCellSectionModel.headerTitle = sectionTitle;
    [self addSection:normalCellSectionModel];
    return normalCellSectionModel;
}

- (STNormalSectionModel *)insertTitleSection:(NSString *)sectionTitle atSectionIndex:(NSInteger)atSectionIndex;{
    STNormalSectionModel *normalCellSectionModel = [[STNormalSectionModel alloc] init];
    normalCellSectionModel.headerTitle = sectionTitle;
    [self insertSection:normalCellSectionModel atSectionIndex:atSectionIndex];
    return normalCellSectionModel;
}

- (STNormalCellModel *)addCellWithTitle:(NSString *)title inSection:(NSInteger)inSection;{
    STNormalCellModel *normalCellModel = [[STNormalCellModel alloc] init];
    [normalCellModel setTitle:title];
    [self addCell:normalCellModel inSection:inSection];
    return normalCellModel;
}

- (STNormalCellModel *)addCellWithTitle:(NSString *)title detailText:(NSString *)detailText image:(UIImage *)image style:(UITableViewCellStyle)style inSection:(NSInteger)inSection;{
    STNormalCellModel *normalCellModel = [[STNormalCellModel alloc] initWithTitle:title subTitle:detailText style:style target:nil action:nil];
    normalCellModel.image = image;
    [self addCell:normalCellModel inSection:inSection];
    return normalCellModel;
}

- (STNormalCellModel *)insertCellWithTitle:(NSString *)title atIndexPath:(NSIndexPath *)atIndexPath;{
    STNormalCellModel *normalCellModel = [[STNormalCellModel alloc] init];
    [normalCellModel setTitle:title];
    [self insertCell:normalCellModel atIndexPath:atIndexPath];
    return normalCellModel;
}

- (STNormalCellModel *)insertCellWithTitle:(NSString *)title detailText:(NSString *)detailText image:(UIImage *)image style:(UITableViewCellStyle)style atIndexPath:(NSIndexPath *)atIndexPath;{
    STNormalCellModel *normalCellModel = [[STNormalCellModel alloc] initWithTitle:title subTitle:detailText style:style target:nil action:nil];
    normalCellModel.image = image;
    [self insertCell:normalCellModel atIndexPath:atIndexPath];
    return normalCellModel;
}

- (void)addSection:(STNormalSectionModel *)sectionModel;{
    NSInteger etInsertSection = [[self mutableCellSectionModels] count];
    [self insertSection:sectionModel atSectionIndex:etInsertSection];
}

- (void)insertSection:(STNormalSectionModel *)sectionModel atSectionIndex:(NSInteger)atSectionIndex;{
    [[self mutableCellSectionModels] addObject:sectionModel];
    [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:atSectionIndex]
                    withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)deleteSection:(STNormalSectionModel *)sectionModel;{
    NSInteger etDeleteSection = [[self mutableCellSectionModels] indexOfObject:sectionModel];
    [self deleteSectionAtIndex:etDeleteSection];
}

- (void)deleteSectionAtIndex:(NSInteger)atSectionIndex;{
    if (atSectionIndex >=0 && atSectionIndex < [[self mutableCellSectionModels] count]) {
        [[self mutableCellSectionModels] removeObjectAtIndex:atSectionIndex];
        [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:atSectionIndex]
                        withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)addCell:(STNormalCellModel *)cellModel inSection:(NSInteger)inSection;{
    if (cellModel && inSection >=0 && inSection < [[self mutableCellSectionModels] count]) {
        STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:inSection];
        NSInteger rowInSection = [[sectionModel cellModels] count];
        [[sectionModel evMuatableCellModels] addObject:cellModel];
        [[self tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowInSection inSection:inSection]]
                                withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)insertCell:(STNormalCellModel *)cellModel atIndexPath:(NSIndexPath *)atIndexPath;{
    if (cellModel && [atIndexPath section] >=0 && [atIndexPath section] < [[self mutableCellSectionModels] count]) {
        STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[atIndexPath section]];
        if ([atIndexPath row] >=0 && [atIndexPath row] <= [[sectionModel cellModels] count]) {
            [[sectionModel evMuatableCellModels] insertObject:cellModel atIndex:[atIndexPath row]];
            [[self tableView] insertRowsAtIndexPaths:@[atIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (void)deleteCell:(STNormalCellModel *)cellModel;{
    if (cellModel) {
        [[self mutableCellSectionModels] enumerateObjectsUsingBlock:^(STNormalSectionModel *sectionModel, NSUInteger section, BOOL *stop) {
            if ([[sectionModel cellModels] containsObject:cellModel]) {
                NSInteger rowInSection = [[sectionModel cellModels] indexOfObject:cellModel];
                [[sectionModel evMuatableCellModels] removeObjectAtIndex:rowInSection];
                [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowInSection inSection:section]] withRowAnimation:UITableViewRowAnimationTop];
                *stop = YES;
            }
        }];
    }
}

- (void)deleteCell:(STNormalCellModel *)cellModel inSection:(NSInteger)inSection;{
    if (cellModel && inSection >=0 && inSection < [[self mutableCellSectionModels] count]) {
        STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:inSection];
        if ([[sectionModel cellModels] containsObject:cellModel]) {
            NSInteger rowInSection = [[sectionModel cellModels] indexOfObject:cellModel];
            [[sectionModel evMuatableCellModels] removeObjectAtIndex:rowInSection];
            [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowInSection inSection:inSection]]
                                    withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (void)deleteCellAtIndexPath:(NSIndexPath *)atIndexPath;{
    if ([atIndexPath section] >=0 && [atIndexPath section] < [[self mutableCellSectionModels] count]) {
        STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[atIndexPath section]];
        if ([atIndexPath row] >=0 && [atIndexPath row] < [[sectionModel evMuatableCellModels] count]) {
            
            [[sectionModel evMuatableCellModels] removeObjectAtIndex:[atIndexPath row]];
            
            [[self tableView] deleteRowsAtIndexPaths:@[atIndexPath]
                                    withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (void)reloadCellAtIndexPaths:(NSArray *)atIndexPaths;{
    [[self tableView] reloadRowsAtIndexPaths:atIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadSectionAtSections:(NSIndexSet *)atSections;{
    [[self tableView] reloadSections:atSections withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self mutableCellSectionModels] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
    return [[sectionModel cellModels] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
    return [sectionModel headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
    return [sectionModel footerViewHeight];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
    return [sectionModel headerTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
    return [sectionModel footerTitle];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
    UIView<STNormalSectionViewInterface> *header = [[[sectionModel headerViewClass] alloc] initWithFrame:CGRectMake(0, 0, 0, MAX([sectionModel headerViewHeight], 0))];
    header.sectionModel = sectionModel;
    if ([sectionModel headerBackgroundColor] && [header isKindOfClass:[UITableViewHeaderFooterView class]]) {
        [[(UITableViewHeaderFooterView *)header contentView] setBackgroundColor:[sectionModel headerBackgroundColor]];
    } else {
        [header setBackgroundColor:[sectionModel headerBackgroundColor]];
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
    UIView<STNormalSectionViewInterface> *footer = [[[sectionModel footerViewClass] alloc] initWithFrame:CGRectMake(0, 0, 0, MAX([sectionModel footerViewHeight], 0.1))];
    footer.sectionModel = sectionModel;
    if ([sectionModel footerBackgroundColor] && [footer isKindOfClass:[UITableViewHeaderFooterView class]]) {
        [[(UITableViewHeaderFooterView *)footer contentView] setBackgroundColor:[sectionModel headerBackgroundColor]];
    } else {
        [footer setBackgroundColor:[sectionModel footerBackgroundColor]];
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[indexPath section]];
    STNormalCellModel *model = [[sectionModel cellModels] objectAtIndex:[indexPath row]];
    if (![model layoutStyle] && [[model cellClass] respondsToSelector:@selector(tableView:heightWithModel:)]) {
        return [[model cellClass] tableView:tableView heightWithModel:model];
    }
    STNormalCell *cell = [[[model cellClass] alloc] initWithStyle:[model style] reuseIdentifier:NSStringFromClass([model cellClass])];
    cell.model = model;
    
    return [cell systemLayoutSizeFittingSize:CGSizeMake(CGRectGetWidth([tableView bounds]), CGFLOAT_MAX)].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[indexPath section]];
    STNormalCellModel *model = [[sectionModel cellModels] objectAtIndex:[indexPath row]];
    STNormalCell *cell = [[[model cellClass] alloc] initWithStyle:[model style] reuseIdentifier:NSStringFromClass([model cellClass])];
    cell.model = model;
    return cell;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[indexPath section]];
    STNormalCellModel *model = [[sectionModel cellModels] objectAtIndex:[indexPath row]];
    if ([model selectable]) {
        return indexPath;
    } else {
        [model performAction];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[indexPath section]];
    STNormalCellModel *model = [[sectionModel cellModels] objectAtIndex:[indexPath row]];
    [model performAction];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [[self delegate] tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [[self delegate] tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [[self delegate] tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [[self delegate] tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        [[self delegate] tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [[self delegate] tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [[self delegate] tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[indexPath section]];
    STNormalCellModel *model = [[sectionModel cellModels] objectAtIndex:[indexPath row]];
    return [model editStyle];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [[self delegate] tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [[self delegate] tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [[self delegate] tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

@end
