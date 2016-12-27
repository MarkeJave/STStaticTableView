//
//  STStaticTableView.h
//  STStaticTableView
//
//  Created by Marike Jave on 15/9/9.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, STTableViewCellLayoutStyle) {
    
    STTableViewCellLayoutStyleDefault,
    STTableViewCellLayoutStyleAutolayout,
};

@interface STNormalCellModel : NSObject{
    
@protected
    CGFloat _height;
    Class __unsafe_unretained _cellClass;
}

@property(nonatomic, assign) STTableViewCellLayoutStyle layoutStyle;

@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) BOOL editStyle;
@property(nonatomic, assign) BOOL selectable;
@property(nonatomic, assign) BOOL selected;

@property(nonatomic, copy  ) NSString *title;
@property(nonatomic, copy  ) UIFont *titleFont;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, assign) NSTextAlignment titleAlignment;
@property(nonatomic, assign) NSUInteger titleNumberOfLines;
@property(nonatomic, assign) NSLineBreakMode titleLineBreakMode;

@property(nonatomic, copy  ) NSString *subtitle;
@property(nonatomic, copy  ) UIFont *subtitleFont;
@property(nonatomic, strong) UIColor *subtitleColor;
@property(nonatomic, assign) NSTextAlignment subtitleAlignment;
@property(nonatomic, assign) NSUInteger subtitleNumberOfLines;
@property(nonatomic, assign) NSLineBreakMode subtitleLineBreakMode;

@property(nonatomic, assign) UITableViewCellStyle style;
@property(nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property(nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property(nonatomic, strong) UIColor *backgroundColor;
@property(nonatomic, strong) UIColor *contentColor;

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *accessoryImage;
@property(nonatomic, strong) UIView *detailAccessoryView;
@property(nonatomic, unsafe_unretained) Class cellClass;
@property(nonatomic, assign) SEL action;
@property(nonatomic, assign) id target;
@property(nonatomic, strong) id userInfo;
@property(nonatomic, strong) NSDictionary<NSString *, id> *keyValues;

@property(nonatomic, copy  ) void (^handler)(STNormalCellModel* model);

@property(nonatomic, assign, readonly) BOOL enableAction;

- (void)performAction;

- (id)initWithTitle:(NSString *)title;

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle;

- (id)initWithTitle:(NSString *)title
         detailText:(NSString *)detailText;

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              style:(UITableViewCellStyle)style;

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              style:(UITableViewCellStyle)style
            handler:(void (^)(STNormalCellModel* model))handler;

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              style:(UITableViewCellStyle)style
             target:(id)target
             action:(SEL)action;

@end

@interface STTextCellModel : STNormalCellModel

@end

@interface STEditableCellModel : STNormalCellModel

@property(nonatomic)        BOOL                   editable;
@property(nonatomic,copy)   NSAttributedString     *attributedText;
@property(nonatomic,retain) UIColor                *textColor;
@property(nonatomic,retain) UIFont                 *font;
@property(nonatomic)        NSTextAlignment         textAlignment;
@property(nonatomic)        UITextBorderStyle       borderStyle;
@property(nonatomic,copy)   NSString               *placeholder;
@property(nonatomic,copy)   NSAttributedString     *attributedPlaceholder;
@property(nonatomic)        BOOL                    clearsOnBeginEditing;
@property(nonatomic)        BOOL                    adjustsFontSizeToFitWidth;
@property(nonatomic)        CGFloat                 minimumFontSize;
@property(nonatomic,retain) UIImage                *background;
@property(nonatomic,retain) UIImage                *disabledBackground;
@property(nonatomic)        UITextFieldViewMode  clearButtonMode;
@property(nonatomic,retain) UIView              *leftView;
@property(nonatomic)        UITextFieldViewMode  leftViewMode;
@property(nonatomic,retain) UIView              *rightView;
@property(nonatomic)        UITextFieldViewMode  rightViewMode;
@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) UITextSpellCheckingType spellCheckingType;
@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UIKeyboardAppearance keyboardAppearance;
@property(nonatomic) UIReturnKeyType returnKeyType;

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style;

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style
             target:(id)target
             action:(SEL)action;

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style
            handler:(void (^)(STNormalCellModel* model))handler;


@end

@class STNormalSectionModel;

@protocol STNormalSectionViewInterface <NSObject>

+ (id)alloc;
- (id)initWithFrame:(CGRect)frame;

@property(nonatomic, strong) STNormalSectionModel *sectionModel;

@end

@interface STNormalSectionModel : NSObject

@property(nonatomic, strong) NSArray<STNormalCellModel *> *cellModels;

@property(nonatomic, copy  ) NSString *headerTitle;
@property(nonatomic, copy  ) NSString *headerSubTitle;
@property(nonatomic, strong) UIColor *headerBackgroundColor;

@property(nonatomic, copy  ) NSString *footerTitle;
@property(nonatomic, copy  ) NSString *footerSubTitle;
@property(nonatomic, strong) UIColor *footerBackgroundColor;

@property(nonatomic, strong) Class<STNormalSectionViewInterface> headerViewClass;

@property(nonatomic, strong) Class<STNormalSectionViewInterface> footerViewClass;

@property(nonatomic, assign) CGFloat headerViewHeight;

@property(nonatomic, assign) CGFloat footerViewHeight;

@property(nonatomic, assign) id userInfo;

- (id)initWithCellModels:(NSArray *)cellModels;

@end

@interface UITableViewCell (NormalCellModel)

@property(nonatomic, strong) STNormalCellModel *model;

- (void)createSubViews;
- (void)installConstraints;
- (void)configSubViewsDefault;
- (void)configSubViews;

@end


@interface STNormalCell : UITableViewCell
@end

@interface STTextCell : STNormalCell

@end

@interface STEditableCell : STNormalCell

@property(nonatomic, strong, readonly) UITextField *detailTextField;

@property(nonatomic, assign, readonly) UITableViewCellStyle style;

@property(nonatomic, strong) STEditableCellModel *model;

@end

@interface STSwitchCell : STNormalCell

@end

@interface STNormalSectionView : UITableViewHeaderFooterView<STNormalSectionViewInterface>

@property(nonatomic, strong) STNormalSectionModel *sectionModel;

@end

@interface STStaticTableView : UIView

@property(nonatomic, assign) id<UITableViewDelegate, UITableViewDataSource> delegate;

@property(nonatomic, strong, readonly) UITableView *tableView;

@property(nonatomic, strong) NSArray<STNormalSectionModel *> *cellSectionModels;

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (instancetype)initWithStyle:(UITableViewStyle)style defaultCellModels:(NSArray<STNormalCellModel *> *)defaultCellModels;

- (instancetype)initWithStyle:(UITableViewStyle)style defaultCellSections:(NSArray<STNormalSectionModel *> *)defaultCellSections;

- (void)reloadData;

- (void)removeAll;

- (STNormalSectionModel *)addSectionWithTitle:(NSString *)title;
- (STNormalSectionModel *)insertSectionWithTitle:(NSString *)title section:(NSUInteger)section;

- (STNormalCellModel *)addCellWithTitle:(NSString *)title section:(NSUInteger)section;
- (STNormalCellModel *)addCellWithTitle:(NSString *)title detailText:(NSString *)detailText image:(UIImage *)image style:(UITableViewCellStyle)style section:(NSUInteger)section;
- (STNormalCellModel *)insertCellWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath;
- (STNormalCellModel *)insertCellWithTitle:(NSString *)title detailText:(NSString *)detailText image:(UIImage *)image style:(UITableViewCellStyle)style indexPath:(NSIndexPath *)indexPath;

- (void)addSectionWithModel:(STNormalSectionModel *)sectionModel;
- (void)insertSectionWithModel:(STNormalSectionModel *)sectionModel section:(NSUInteger)section;
- (void)deleteSectionWithModel:(STNormalSectionModel *)sectionModel;
- (void)deleteSection:(NSUInteger)section;

- (void)addCellWithModel:(STNormalCellModel *)cellModel section:(NSUInteger)section;
- (void)insertCellWithModel:(STNormalCellModel *)cellModel indexPath:(NSIndexPath *)indexPath;
- (void)deleteCellWithModel:(STNormalCellModel *)cellModel;
- (void)deleteCellWithModel:(STNormalCellModel *)cellModel section:(NSUInteger)section;
- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadCellAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)reloadSectionAtSections:(NSIndexSet *)sections;

@end
