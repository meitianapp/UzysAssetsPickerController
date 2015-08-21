//
//  UzysAssetsViewCell.m
//  UzysAssetsPickerController
//
//  Created by Uzysjung on 2014. 2. 12..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//

#import "UzysAssetsViewCell.h"
#import "UzysAppearanceConfig.h"

@interface UzysAssetsViewCell()
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *videoImage;
@property (weak, nonatomic) IBOutlet UIImageView *thumnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *videoMark;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
@implementation UzysAssetsViewCell

static UIFont *videoTimeFont = nil;

static CGFloat videoTimeHeight;
static UIImage *videoIcon;
static UIColor *videoTitleColor;
static UIImage *checkedIcon;
static UIImage *uncheckedIcon;
static UIColor *selectedColor;
static CGFloat thumnailLength;
+ (void)initialize
{
    UzysAppearanceConfig *appearanceConfig = [UzysAppearanceConfig sharedConfig];

    videoTitleColor      = [UIColor whiteColor];
    videoTimeFont       = [UIFont systemFontOfSize:12];
    videoTimeHeight     = 20.0f;
    videoIcon       = [UIImage imageNamed:@"UzysAssetPickerController.bundle/uzysAP_ico_assets_video"];
    
    checkedIcon     = [UIImage Uzys_imageNamed:appearanceConfig.assetSelectedImageName];
    uncheckedIcon   = [UIImage Uzys_imageNamed:appearanceConfig.assetDeselectedImageName];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    
    thumnailLength = ([UIScreen mainScreen].bounds.size.width - appearanceConfig.cellSpacing * ((CGFloat)appearanceConfig.assetsCountInALine - 1.0f)) / (CGFloat)appearanceConfig.assetsCountInALine;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.opaque = YES;
        
    }
    return self;
}
- (void)applyData:(ALAsset *)asset
{
    self.asset  = asset;
    self.image  = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
    self.type   = [asset valueForProperty:ALAssetPropertyType];
    self.title  = [UzysAssetsViewCell getTimeStringOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    self.thumnailImageView.image = self.image;
    self.checkImageView.image = self.selected ? checkedIcon : uncheckedIcon;
    BOOL isVideo = [self.type isEqual:ALAssetTypeVideo];
    self.videoMark.hidden = !isVideo;
    self.timeLabel.hidden = !isVideo;
    if (isVideo) {
        self.timeLabel.text = self.title;
    }
}

- (void)toggleSelected:(BOOL)selected {
    if(selected)
    {
        self.checkImageView.image = checkedIcon;
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeScale(0.97, 0.97);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    else
    {
        self.checkImageView.image = uncheckedIcon;
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeScale(1.03, 1.03);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
        
    }
}

+ (NSString *)getTimeStringOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *dateRef = [[NSDate alloc] init];
    NSDate *dateNow = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:dateRef];
    
    unsigned int uFlags =
    NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit |
    NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    

    NSDateComponents *components = [calendar components:uFlags
                                               fromDate:dateRef
                                                 toDate:dateNow
                                                options:0];
    NSString *retTimeInterval;
    if (components.hour > 0)
    {
        retTimeInterval = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)components.second];
    }
    
    else
    {
        retTimeInterval = [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)components.second];
    }
    return retTimeInterval;
}


@end
