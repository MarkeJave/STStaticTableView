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
    self.title = nil;
    self.subtitle = nil;
    self.cellClass = nil;
    self.action = nil;
    self.target = nil;
    self.userInfo = nil;
    self.handler = nil;
}

- (id)initWithTitle:(NSString *)title;{
    return [self initWithTitle:title subtitle:nil style:UITableViewCellStyleDefault];
}

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle;{
    return [self initWithTitle:title subtitle:subtitle style:UITableViewCellStyleSubtitle];
}

- (id)initWithTitle:(NSString *)title
         detailText:(NSString *)detailText{
    return [self initWithTitle:title subtitle:detailText style:UITableViewCellStyleValue1];
}

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              style:(UITableViewCellStyle)style;{
    return [self initWithTitle:title subtitle:subtitle style:style handler:nil];
}

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              style:(UITableViewCellStyle)style
            handler:(void (^)(STNormalCellModel* model))handler;{
    self = [self init];
    if (self) {
        self.style = style;
        self.title = title;
        self.subtitle = subtitle;
        self.handler = handler;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              style:(UITableViewCellStyle)style
             target:(id)target
             action:(SEL)action;{
    self = [self init];
    if (self) {
        self.style = style;
        self.title = title;
        self.subtitle = subtitle;
        self.target = target;
        self.action = action;
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
    return ([self target] && [self action]) || [self handler];
}

- (void)performAction{
    if ([self enableAction]){
        if ([self target] && [[self target] respondsToSelector:[self action]]) {
            [[self target] performSelector:[self action] withObject:self];
        } else if ([self handler]){
            self.handler(self);
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
        self.editable = YES;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style{
    return [self initWithTitle:title subtitle:subtitle placeholder:placeholder style:style handler:nil];
}

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style
             target:(id)target
             action:(SEL)action;{
    self = [super initWithTitle:title
                       subtitle:subtitle
                          style:style
                         target:target
                         action:action];
    if (self) {
        self.placeholder = placeholder;
        self.textAlignment = NSTextAlignmentNatural;
        [self copyStyle:[UITextField appearance]];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style
            handler:(void (^)(STNormalCellModel* model))handler;{
    self = [super initWithTitle:title
                       subtitle:subtitle
                          style:style
                        handler:handler];
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

@property(nonatomic, strong) NSMutableArray<STNormalCellModel *> *muatableCellModels;

@end

@implementation STNormalSectionModel

- (id)initWithCellModels:(NSArray *)cellModels;{
    self = [self init];
    if (self) {
        self.cellModels = [cellModels copy];
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

- (NSMutableArray *)muatableCellModels{
    if (!_muatableCellModels) {
        _muatableCellModels = [NSMutableArray array];
    }
    return _muatableCellModels;
}

- (NSArray *)cellModels{
    return [[self muatableCellModels] copy];
}

- (void)setCellModels:(NSArray *)cellModels{
    [[self muatableCellModels] removeAllObjects];
    [[self muatableCellModels] addObjectsFromArray:cellModels];
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

@property(nonatomic, strong) NSMutableArray<STNormalCellModel *> *muatableCellModels;

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

- (void)createSubViews;{
    
}

- (void)installConstraints;{
    
}

- (void)configSubViewsDefault;{
    
}

- (void)configSubViews{
    
    self.imageView.image = [[self model] image];
    self.textLabel.text = [[self model] title];
    self.detailTextLabel.text = [[self model] subtitle];
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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.textColor = [UIColor lightGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
}

- (void)configSubViews{
    [super configSubViews];
    
    self.textLabel.textColor = [[self model] titleColor] ?: [UIColor blackColor];
    self.textLabel.font = [[self model] titleFont] ?: [UIFont systemFontOfSize:14];
    self.textLabel.textAlignment = [[self model] titleAlignment];
    self.textLabel.numberOfLines = [[self model] titleNumberOfLines];
    self.textLabel.lineBreakMode = [[self model] titleLineBreakMode];
    
    self.detailTextLabel.textColor = [[self model] subtitleColor] ?: [UIColor lightGrayColor];
    self.detailTextLabel.font = [[self model] subtitleFont] ?: [UIFont systemFontOfSize:12];
    self.detailTextLabel.textAlignment = [[self model] subtitleAlignment];
    self.detailTextLabel.numberOfLines = [[self model] subtitleNumberOfLines];
    self.detailTextLabel.lineBreakMode = [[self model] subtitleLineBreakMode];
    
    self.selectionStyle = [[self model] selectionStyle];
    self.accessoryType = [[self model] accessoryType];
    
    if ([[self model]  backgroundColor]) {
        self.backgroundColor = [[self model]  backgroundColor];
    }
    if ([[self model] contentColor]) {
        self.contentView.backgroundColor = [[self model] contentColor];
    }
    if ([[self model] accessoryType] == UITableViewCellAccessoryDetailButton ||
        [[self model] accessoryType] == UITableViewCellAccessoryDetailDisclosureButton) {
        if ([[self model] detailAccessoryView]) {
            self.accessoryView = [[self model] detailAccessoryView];
        } else if ([[self model] accessoryImage]){
            self.accessoryView = [[UIImageView alloc] initWithImage:[[self model] accessoryImage]];
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
    self.style = style;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self relayoutSubViews:[[self contentView] bounds]];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightWithModel:(STEditableCellModel *)model{
    return [model height];
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
    
    self.detailTextField.enabled = [[self model] editable];
    self.detailTextField.text = [[self model] subtitle];
    self.detailTextField.placeholder = [[self model] placeholder];
    self.detailTextField.font = [[self model] font];
    self.detailTextField.textColor = [[self model] textColor];
    if ([[self model] textAlignment] != NSTextAlignmentNatural) {
        self.detailTextField.textAlignment = [[self model] textAlignment];
    }
    self.detailTextField.clearsOnBeginEditing = [[self model] clearsOnBeginEditing];
    self.detailTextField.adjustsFontSizeToFitWidth = [[self model] adjustsFontSizeToFitWidth];
    self.detailTextField.minimumFontSize = [[self model] minimumFontSize];
    self.detailTextField.background = [[self model] background];
    self.detailTextField.disabledBackground = [[self model] disabledBackground];
    self.detailTextField.clearButtonMode = [[self model] clearButtonMode];
    self.detailTextField.leftView = [[self model] leftView];
    self.detailTextField.leftViewMode = [[self model] leftViewMode];
    self.detailTextField.rightView = [[self model] rightView];
    self.detailTextField.rightViewMode = [[self model] rightViewMode];
    self.detailTextField.autocapitalizationType = [[self model] autocapitalizationType];
    self.detailTextField.autocorrectionType = [[self model] autocorrectionType];
    self.detailTextField.spellCheckingType = [[self model] spellCheckingType];
    self.detailTextField.keyboardType = [[self model] keyboardType];
    self.detailTextField.keyboardAppearance = [[self model] keyboardAppearance];
    self.detailTextField.returnKeyType = [[self model] returnKeyType];
    
    [[self detailTextField] addTarget:self action:@selector(didTextChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)configSubViewsDefault{
    [super configSubViewsDefault];
    self.detailTextLabel.alpha = 0.f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self style] == UITableViewCellStyleDefault){
        self.textLabel.alpha = 0.f;
        self.detailTextField.textAlignment = NSTextAlignmentCenter;
    } else if ([self style] == UITableViewCellStyleSubtitle || [self style] == UITableViewCellStyleValue2) {
        self.detailTextField.textAlignment = NSTextAlignmentLeft;
    } else {
        self.detailTextField.textAlignment = NSTextAlignmentRight;
    }
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextField.textColor = [UIColor lightGrayColor];
    self.detailTextField.font = [UIFont systemFontOfSize:12];
}

- (void)relayoutSubViews:(CGRect)bounds{
    if ([self style] == UITableViewCellStyleDefault){
        self.detailTextField.frame = bounds;
    }
    else if ([self style] == UITableViewCellStyleSubtitle){
        self.detailTextField.frame = CGRectMake([self layoutMargins].left, CGRectGetMaxY([[self textLabel] frame]), CGRectGetWidth(bounds) - [self layoutMargins].left - [[self contentView] layoutMargins].right, CGRectGetHeight(bounds) - CGRectGetMaxY([[self textLabel] frame]));
    }
    else if ([self style] == UITableViewCellStyleValue1){
        self.detailTextField.frame = CGRectMake(CGRectGetMaxX([[self textLabel] frame]) + 8, 0, CGRectGetWidth(bounds) - CGRectGetMaxX([[self textLabel] frame]) - [[self contentView] layoutMargins].right - 8, CGRectGetHeight(bounds));
    }
    else if ([self style] == UITableViewCellStyleValue2){
        self.detailTextField.frame = CGRectMake(CGRectGetMaxX([[self textLabel] frame]) + 8, 0, CGRectGetWidth(bounds) - CGRectGetMaxX([[self textLabel] frame]) - [[self contentView] layoutMargins].right - 8, CGRectGetHeight(bounds));
    }
}

- (IBAction)didTextChanged:(UITextField *)sender{
    self.model.subtitle = [sender text];
}

@end

@interface STNormalCell (Private)

@end

@interface STSwitchCell ()

@property(nonatomic, strong) UISwitch *exchangeSwitch;

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
    self.exchangeSwitch = [[UISwitch alloc] init];
    self.accessoryView = [self exchangeSwitch];
}

- (void)configSubViewsDefault{
    [super configSubViewsDefault];
    [[self exchangeSwitch] addTarget:self action:@selector(didClickExchange:) forControlEvents:UIControlEventValueChanged];
}

- (void)configSubViews{
    [super configSubViews];
    self.exchangeSwitch.on = [[[self model] userInfo] boolValue];
}

#pragma mark - actions

- (IBAction)didClickExchange:(UISwitch *)sender{
    self.model.userInfo = @([sender isOn]);
    
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
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
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
        self.style = style;
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self tableView] registerClass:[STTextCell class] forCellReuseIdentifier:NSStringFromClass([STTextCell class])];
}

- (void)installConstraints{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *mutableConstraints = [NSMutableArray array];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[self tableView]
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1
                                                                   constant:0];
    [mutableConstraints addObject:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:[self tableView]
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1
                                               constant:0];
    [mutableConstraints addObject:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:[self tableView]
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1
                                               constant:0];
    [mutableConstraints addObject:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:[self tableView]
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1
                                               constant:0];
    [mutableConstraints addObject:constraint];
    [self addConstraints:mutableConstraints];
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
- (STNormalSectionModel *)addSectionWithTitle:(NSString *)title;{
    STNormalSectionModel *normalCellSectionModel = [[STNormalSectionModel alloc] init];
    normalCellSectionModel.headerTitle = title;
    [self addSectionWithModel:normalCellSectionModel];
    return normalCellSectionModel;
}
- (STNormalSectionModel *)insertSectionWithTitle:(NSString *)title section:(NSUInteger)section;{
    STNormalSectionModel *normalCellSectionModel = [[STNormalSectionModel alloc] init];
    normalCellSectionModel.headerTitle = title;
    [self insertSectionWithModel:normalCellSectionModel section:section];
    return normalCellSectionModel;
}

- (STNormalCellModel *)addCellWithTitle:(NSString *)title section:(NSUInteger)section;{
    STNormalCellModel *normalCellModel = [[STNormalCellModel alloc] init];
    normalCellModel.title = title;
    [self addCellWithModel:normalCellModel section:section];
    return normalCellModel;
}
- (STNormalCellModel *)addCellWithTitle:(NSString *)title detailText:(NSString *)detailText image:(UIImage *)image style:(UITableViewCellStyle)style section:(NSUInteger)section;{
    STNormalCellModel *normalCellModel = [[STNormalCellModel alloc] initWithTitle:title subtitle:detailText style:style target:nil action:nil];
    normalCellModel.image = image;
    [self addCellWithModel:normalCellModel section:section];
    return normalCellModel;
}

- (STNormalCellModel *)insertCellWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath;{
    STNormalCellModel *normalCellModel = [[STNormalCellModel alloc] init];
    normalCellModel.title = title;
    [self insertCellWithModel:normalCellModel indexPath:indexPath];
    return normalCellModel;
}
- (STNormalCellModel *)insertCellWithTitle:(NSString *)title detailText:(NSString *)detailText image:(UIImage *)image style:(UITableViewCellStyle)style indexPath:(NSIndexPath *)indexPath;{
    STNormalCellModel *normalCellModel = [[STNormalCellModel alloc] initWithTitle:title subtitle:detailText style:style target:nil action:nil];
    normalCellModel.image = image;
    [self insertCellWithModel:normalCellModel indexPath:indexPath];
    return normalCellModel;
}

- (void)addSectionWithModel:(STNormalSectionModel *)sectionModel;{
    NSInteger insertSection = [[self mutableCellSectionModels] count];
    [self insertSectionWithModel:sectionModel section:insertSection];
}

- (void)insertSectionWithModel:(STNormalSectionModel *)sectionModel section:(NSUInteger)section;{
    [[self mutableCellSectionModels] addObject:sectionModel];
    [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:section]
                    withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)deleteSectionWithModel:(STNormalSectionModel *)sectionModel;{
    NSInteger deleteSection = [[self mutableCellSectionModels] indexOfObject:sectionModel];
    [self deleteSection:deleteSection];
}

- (void)deleteSection:(NSUInteger)section;{
    if (section < [[self mutableCellSectionModels] count]) {
        [[self mutableCellSectionModels] removeObjectAtIndex:section];
        [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:section]
                        withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)addCellWithModel:(STNormalCellModel *)cellModel section:(NSUInteger)section;{
    if (cellModel && section < [[self mutableCellSectionModels] count]) {
        STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
        NSInteger rowInSection = [[sectionModel cellModels] count];
        [[sectionModel muatableCellModels] addObject:cellModel];
        [[self tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowInSection inSection:section]]
                                withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)insertCellWithModel:(STNormalCellModel *)cellModel indexPath:(NSIndexPath *)indexPath;{
    if (cellModel && [indexPath section] >=0 && [indexPath section] < [[self mutableCellSectionModels] count]) {
        STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[indexPath section]];
        if ([indexPath row] >=0 && [indexPath row] <= [[sectionModel cellModels] count]) {
            [[sectionModel muatableCellModels] insertObject:cellModel atIndex:[indexPath row]];
            [[self tableView] insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (void)deleteCellWithModel:(STNormalCellModel *)cellModel;{
    if (cellModel) {
        [[self mutableCellSectionModels] enumerateObjectsUsingBlock:^(STNormalSectionModel *sectionModel, NSUInteger section, BOOL *stop) {
            if ([[sectionModel cellModels] containsObject:cellModel]) {
                NSInteger rowInSection = [[sectionModel cellModels] indexOfObject:cellModel];
                [[sectionModel muatableCellModels] removeObjectAtIndex:rowInSection];
                [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowInSection inSection:section]] withRowAnimation:UITableViewRowAnimationTop];
                *stop = YES;
            }
        }];
    }
}

- (void)deleteCellWithModel:(STNormalCellModel *)cellModel section:(NSUInteger)section;{
    if (cellModel && section < [[self mutableCellSectionModels] count]) {
        STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
        if ([[sectionModel cellModels] containsObject:cellModel]) {
            NSInteger rowInSection = [[sectionModel cellModels] indexOfObject:cellModel];
            [[sectionModel muatableCellModels] removeObjectAtIndex:rowInSection];
            [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowInSection inSection:section]]
                                    withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath;{
    if ([indexPath section] >=0 && [indexPath section] < [[self mutableCellSectionModels] count]) {
        STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:[indexPath section]];
        if ([indexPath row] >=0 && [indexPath row] < [[sectionModel muatableCellModels] count]) {
            
            [[sectionModel muatableCellModels] removeObjectAtIndex:[indexPath row]];
            
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                    withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (void)reloadCellAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;{
    [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadSectionAtSections:(NSIndexSet *)sections;{
    [[self tableView] reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
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
        ((UITableViewHeaderFooterView *)header).contentView.backgroundColor = [sectionModel headerBackgroundColor];
    } else {
        header.backgroundColor = [sectionModel headerBackgroundColor];
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    STNormalSectionModel *sectionModel = [[self mutableCellSectionModels] objectAtIndex:section];
    UIView<STNormalSectionViewInterface> *footer = [[[sectionModel footerViewClass] alloc] initWithFrame:CGRectMake(0, 0, 0, MAX([sectionModel footerViewHeight], 0.1))];
    footer.sectionModel = sectionModel;
    if ([sectionModel footerBackgroundColor] && [footer isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)footer).contentView.backgroundColor = [sectionModel footerBackgroundColor];
    } else {
        footer.backgroundColor = [sectionModel footerBackgroundColor];
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
