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
@property(nonatomic, assign) NSInteger titleNumberOfLines;
@property(nonatomic, assign) NSLineBreakMode titleLineBreakMode;

@property(nonatomic, copy  ) NSString *subTitle;
@property(nonatomic, copy  ) UIFont *subTitleFont;
@property(nonatomic, strong) UIColor *subTitleColor;
@property(nonatomic, assign) NSTextAlignment subTitleAlignment;
@property(nonatomic, assign) NSInteger subTitleNumberOfLines;
@property(nonatomic, assign) NSLineBreakMode subTitleLineBreakMode;

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

@property(nonatomic, copy  ) void (^modelCallback)(STNormalCellModel* model);

@property(nonatomic, assign, readonly) BOOL enableAction;

- (void)performAction;

- (id)initWithTitle:(NSString *)title;

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle;

- (id)initWithTitle:(NSString *)title
         detailText:(NSString *)detailText;

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
              style:(UITableViewCellStyle)style;

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
              style:(UITableViewCellStyle)style
      modelCallback:(void (^)(STNormalCellModel* model))modelCallback;

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
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
           subTitle:(NSString *)subTitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style;

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style
             target:(id)target
             action:(SEL)action;

- (id)initWithTitle:(NSString *)title
           subTitle:(NSString *)subTitle
        placeholder:(NSString *)placeholder
              style:(UITableViewCellStyle)style
      modelCallback:(void (^)(STNormalCellModel* model))modelCallback;


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

@property(nonatomic, strong) id<UITableViewDelegate, UITableViewDataSource> delegate;

@property(nonatomic, strong, readonly) UITableView *tableView;

@property(nonatomic, strong) NSArray *cellSectionModels;

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (instancetype)initWithStyle:(UITableViewStyle)style defaultCellModels:(NSArray *)defaultCellModels;

- (instancetype)initWithStyle:(UITableViewStyle)style defaultCellSections:(NSArray *)defaultCellSections;

- (void)reloadData;

- (void)removeAll;

- (STNormalSectionModel *)addTitleSection:(NSString *)sectionTitle;
- (STNormalSectionModel *)insertTitleSection:(NSString *)sectionTitle atSectionIndex:(NSInteger)atSectionIndex;

- (STNormalCellModel *)addCellWithTitle:(NSString *)title inSection:(NSInteger)inSection;
- (STNormalCellModel *)addCellWithTitle:(NSString *)title detailText:(NSString *)detailText image:(UIImage *)image style:(UITableViewCellStyle)style inSection:(NSInteger)inSection;
- (STNormalCellModel *)insertCellWithTitle:(NSString *)title atIndexPath:(NSIndexPath *)atIndexPath;
- (STNormalCellModel *)insertCellWithTitle:(NSString *)title detailText:(NSString *)detailText image:(UIImage *)image style:(UITableViewCellStyle)style atIndexPath:(NSIndexPath *)atIndexPath;

- (void)addSection:(STNormalSectionModel *)sectionModel;
- (void)insertSection:(STNormalSectionModel *)sectionModel atSectionIndex:(NSInteger)atSectionIndex;
- (void)deleteSection:(STNormalSectionModel *)sectionModel;
- (void)deleteSectionAtIndex:(NSInteger)atSectionIndex;

- (void)addCell:(STNormalCellModel *)cellModel inSection:(NSInteger)inSection;
- (void)insertCell:(STNormalCellModel *)cellModel atIndexPath:(NSIndexPath *)atIndexPath;
- (void)deleteCell:(STNormalCellModel *)cellModel;
- (void)deleteCell:(STNormalCellModel *)cellModel inSection:(NSInteger)inSection;
- (void)deleteCellAtIndexPath:(NSIndexPath *)atIndexPath;

- (void)reloadCellAtIndexPaths:(NSArray *)atIndexPaths;

- (void)reloadSectionAtSections:(NSIndexSet *)atSections;

@end
