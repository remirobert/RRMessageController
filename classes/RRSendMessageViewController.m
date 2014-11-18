//
//  SendMessageViewController.m
//  SendMessageController
//
//  Created by Remi Robert on 17/11/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "RRSendMessageViewController.h"
#import "RRCustomScrollView.h"

@interface RRSendMessageViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIButton *buttonAddPhoto;
@property (nonatomic, strong) UILabel *numberLine;
@property (nonatomic, strong) NSMutableArray *photosThumbnailLibrairy;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) UICollectionView *photosCollection;
@property (nonatomic, strong) RRCustomScrollView *selectedPhotosView;
@property (nonatomic, assign) BOOL state;

@property (nonatomic, strong) void (^completion)(RRMessageModel *model, BOOL isCancel);
@end

# define CELL_PHOTO_IDENTIFIER  @"photoLibraryCell"
# define CLOSE_PHOTO_IMAGE      @"close"
# define ADD_PHOTO_IMAGE        @"photo"

@implementation RRSendMessageViewController

- (ALAssetsLibrary *) defaultAssetLibrairy {
    static ALAssetsLibrary *assetLibrairy;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetLibrairy = [[ALAssetsLibrary alloc] init];
    });
    return (assetLibrairy);
}

- (BOOL) shouldAutorotate {
    return (false);
}

# pragma mark Deltegate

- (void) postMessage {
    RRMessageModel *modelMessage = [[RRMessageModel alloc] init];
    modelMessage.text = self.textView.text;
    modelMessage.photos = self.selectedPhotos;
    
    if (self.completion != nil) {
        self.completion(modelMessage, false);
    }
    
    if ([self.delegate respondsToSelector:@selector(getMessage:)]) {
        [self.delegate getMessage:modelMessage];
    }
}

- (void) cancelMessage {
    if ([self.delegate respondsToSelector:@selector(messageCancel)]) {
        [self.delegate messageCancel];
    }
    
    if (self.completion != nil) {
        self.completion(nil, true);
    }
}

#pragma mark UITextView delegate

- (void)textViewDidChange:(UITextView *)textView {
    self.numberLine.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.textView.text.length];
}

#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.photosThumbnailLibrairy.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCellPhoto *cell = [collectionView
                                       dequeueReusableCellWithReuseIdentifier:CELL_PHOTO_IDENTIFIER
                                       forIndexPath:indexPath];
    
    cell.photo.image = [self.photosThumbnailLibrairy objectAtIndex:indexPath.row];
    return (cell);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.numberPhoto != -1 && self.selectedPhotos.count >= self.numberPhoto) {
        return  ;
    }
    if (self.selectedPhotos.count == 0) {
        CGFloat positionY = self.textView.frame.origin.y + self.textView.frame.size.height / 2;
        CGFloat sizeHeigth = self.textView.frame.size.height / 2;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y,
                                             self.textView.frame.size.width, self.textView.frame.size.height / 2);
        } completion:^(BOOL finished) {
            NSRange bottom = NSMakeRange(self.textView.text.length -1, 1);
            [self.textView scrollRangeToVisible:bottom];
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.selectedPhotosView.frame = CGRectMake(self.textView.frame.origin.x, positionY,
                                                       self.textView.frame.size.width, sizeHeigth);
        } completion:^(BOOL finished) {
            [self addPhotoSelectedView:[self.photosThumbnailLibrairy objectAtIndex:indexPath.row]
                       initialPosition:[collectionView cellForItemAtIndexPath:indexPath].frame.origin];
            [self.selectedPhotos addObject:[self.photosThumbnailLibrairy objectAtIndex:indexPath.row]];
        }];
    }
    else {
        [self addPhotoSelectedView:[self.photosThumbnailLibrairy objectAtIndex:indexPath.row]
                   initialPosition:[collectionView cellForItemAtIndexPath:indexPath].frame.origin];
        [self.selectedPhotos addObject:[self.photosThumbnailLibrairy objectAtIndex:indexPath.row]];
    }
}

# pragma mark interface button

- (void) deletePhoto:(id)sender {
    NSInteger deletedPhoto = ((UIButton *)sender).tag;
    
    for (UIView *currentSubView in [self.selectedPhotosView subviews]) {
        if (currentSubView.tag > 0 && deletedPhoto == currentSubView.tag) {
            if ([currentSubView isKindOfClass:[UIImageView class]]) {
                [self.selectedPhotos removeObjectAtIndex:deletedPhoto - 1];
            }
            if ([currentSubView isKindOfClass:[UIImageView class]]) {
                [UIView animateWithDuration:0.3 animations:^{
                    currentSubView.frame = CGRectMake(currentSubView.frame.origin.x,
                                                      currentSubView.frame.origin.y + 50, 0, 0);
                } completion:^(BOOL finished) {
                    [currentSubView removeFromSuperview];
                }];
            }
            else {
                [currentSubView removeFromSuperview];
            }
        }
    }

    for (UIView *currentSubView in [self.selectedPhotosView subviews]) {
        if (currentSubView.tag > 0 && currentSubView.tag > deletedPhoto) {
            [UIView animateWithDuration:0.5 animations:^{
                currentSubView.tag -= 1;
                currentSubView.frame = CGRectMake(currentSubView.frame.origin.x - self.textView.frame.size.height,
                                                  currentSubView.frame.origin.y,
                                                  currentSubView.frame.size.width,
                                                  currentSubView.frame.size.height);
            }];
        }
    }
    self.selectedPhotosView.contentSize = CGSizeMake(self.selectedPhotosView.contentSize.width -
                                                     self.textView.frame.size.height,
                                                     self.selectedPhotosView.contentSize.height);
    if (self.selectedPhotos.count == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y,
                                             self.textView.frame.size.width, self.textView.frame.size.height * 2);
        } completion:^(BOOL finished) {
            NSRange bottom = NSMakeRange(self.textView.text.length -1, 1);
            [self.textView scrollRangeToVisible:bottom];
            self.selectedPhotosView.frame = CGRectZero;
        }];
    }
}

- (void) addPhoto {
    if (self.state == true) {
        [self.view endEditing:YES];
        self.state = false;
        [self.view addSubview:self.photosCollection];
        
        if (self.photosThumbnailLibrairy.count != 0) {
            return ;
        }
        
        ALAssetsLibrary *library = [self defaultAssetLibrairy];
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group,
                                                                                BOOL *stop) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset,
                                                                                NSUInteger index, BOOL *innerStop) {
                if (alAsset) {
                    UIImage *currentThumbnail = [UIImage imageWithCGImage:[alAsset thumbnail]];
                    [self.photosThumbnailLibrairy addObject:currentThumbnail];
                    [self.photosCollection reloadData];
                }
            }];
        } failureBlock: ^(NSError *error) {
            NSLog(@"No groups");
        }];
    }
    else {
        [self.textView becomeFirstResponder];
        self.state = true;
    }
}

- (void) addPhotoSelectedView:(UIImage *)photo initialPosition:(CGPoint)position {
    CGFloat indexPositionX = self.textView.frame.size.height * self.selectedPhotos.count;
    
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(position.x, self.textView.frame.size.height,
                                                                           self.textView.frame.size.height - 10,
                                                                           self.textView.frame.size.height - 10)];
    
    UIButton *buttonClose = [[UIButton alloc] init];

    photoView.tag = self.selectedPhotos.count + 1;
    buttonClose.tag = self.selectedPhotos.count + 1;
    UIImageView *imgCloseButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imgCloseButton.image = [UIImage imageNamed:CLOSE_PHOTO_IMAGE];

    [buttonClose addSubview:imgCloseButton];
    [buttonClose addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectedPhotosView.contentSize = CGSizeMake(self.textView.frame.size.height +
                                                     self.selectedPhotosView.contentSize.width,
                                                     self.textView.frame.size.height);
    photoView.image = photo;
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.selectedPhotosView addSubview:photoView];
    
    [UIView animateWithDuration:0.5 animations:^{
        photoView.frame = CGRectMake(indexPositionX + 5, 5,
                                     self.textView.frame.size.height - 10,
                                     self.textView.frame.size.height - 10);
    } completion:^(BOOL finished) {
        buttonClose.frame = CGRectMake(photoView.frame.origin.x, 0, 25, 25);
        [self.selectedPhotosView addSubview:buttonClose];
    }];
    
}

# pragma mark notification keyboard

- (void)notificationKeyboardUp:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    self.state = true;
    [UIView animateWithDuration:0.5 animations:^{
        self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y,
                                         self.textView.frame.size.width, (self.view.frame.size.height - 64) -
                                         keyboardFrameBeginRect.size.height - 40 - self.selectedPhotosView.frame.size.height);
    }];
    self.buttonAddPhoto.frame = CGRectMake(self.buttonAddPhoto.frame.origin.x, self.view.frame.size.height -
                                           keyboardFrameBeginRect.size.height - 30, self.buttonAddPhoto.frame.size.width,
                                           self.buttonAddPhoto.frame.size.height);
    
    self.numberLine.frame = CGRectMake(self.numberLine.frame.origin.x, self.view.frame.size.height -
                                       keyboardFrameBeginRect.size.height - 30, self.numberLine.frame.size.width,
                                       self.numberLine.frame.size.height);
    
    self.photosCollection.frame = CGRectMake(0, self.view.frame.size.height - keyboardFrameBeginRect.size.height,
                                             self.view.frame.size.width, keyboardFrameBeginRect.size.height);
}

# pragma mark init interface

- (void) initPanelButton {
    self.self.buttonAddPhoto = [[UIButton alloc] initWithFrame:CGRectMake(10, -20, 20, 20)];
    UIImageView *imageButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageButton.contentMode = UIViewContentModeScaleAspectFit;
    imageButton.image = [UIImage imageNamed:ADD_PHOTO_IMAGE];
    [self.buttonAddPhoto addSubview:imageButton];
    [self.buttonAddPhoto addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    self.numberLine = [[UILabel alloc] initWithFrame:CGRectMake(10, - 20,
                                                                self.view.frame.size.width - 20, 20)];
    self.numberLine.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    self.numberLine.textAlignment = NSTextAlignmentRight;
    
    self.numberLine.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.textView.text.length];
    
    [self.view addSubview:self.numberLine];
    [self.view addSubview:self.buttonAddPhoto];
}

- (void) initPhotosCollection {
    UICollectionViewFlowLayout *layoutCollection = [[UICollectionViewFlowLayout alloc] init];
    
    layoutCollection.itemSize = CGSizeMake(self.view.frame.size.width / 4 - 2, self.view.frame.size.width / 4 - 2);
    layoutCollection.minimumLineSpacing = 2;
    layoutCollection.minimumInteritemSpacing = 2;
    layoutCollection.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photosCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layoutCollection];
    [self.photosCollection registerClass:[UICollectionViewCellPhoto class] forCellWithReuseIdentifier:CELL_PHOTO_IDENTIFIER];
    self.photosCollection.backgroundColor = [UIColor clearColor];
    self.photosCollection.delegate = self;
    self.photosCollection.dataSource = self;
}

- (void) initScrollSelectedPhotos {
    self.selectedPhotosView = [[RRCustomScrollView alloc] initWithFrame:CGRectZero];
    self.selectedPhotosView.canCancelContentTouches = YES;
    self.selectedPhotosView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.selectedPhotosView];
}

- (void) initTextView {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5, self.navigationBar.frame.size.height + 5,
                                                                 self.view.frame.size.width - 10, 0)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
}

- (void) initUI {
    self.state = true;
    self.numberPhoto = -1;
    self.view.backgroundColor = [UIColor colorWithWhite:0.847 alpha:1.000];
    
    self.selectedPhotos = [[NSMutableArray alloc] init];
    self.photosThumbnailLibrairy = [[NSMutableArray alloc] init];
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.navigationBar.backgroundColor = [UIColor colorWithWhite:0.846 alpha:1.000];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(postMessage)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(cancelMessage)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Nouveau message"];
    item.rightBarButtonItem = rightButton;
    item.leftBarButtonItem = leftButton;
    item.hidesBackButton = YES;
    [self.navigationBar pushNavigationItem:item animated:NO];
    
    [self.view addSubview:self.navigationBar];
    [self initPhotosCollection];
    [self initTextView];
    [self initPanelButton];
    [self initScrollSelectedPhotos];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardUp:)
                                                 name:UIKeyboardDidShowNotification object:nil];
}

- (void) presentController:(UIViewController *)parentController :(void (^)(RRMessageModel *model, BOOL isCancel))completion {
    [parentController presentViewController:self animated:true completion:nil];
    self.completion = completion;
}

# pragma mark constructor

- (instancetype) initWithMessage:(RRMessageModel *)message {
    self = [super init];
    
    if (self != nil) {
        [self initUI];
        self.textView.text = message.text;
        self.selectedPhotos = message.photos;
        for (UIImage *currentPhoto in self.selectedPhotos) {
            [self addPhotoSelectedView:currentPhoto initialPosition:CGRectZero.origin];
        }
    }
    return (self);
}

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        [self initUI];
    }
    return (self);
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.selectedPhotos = nil;
    self.photosThumbnailLibrairy = nil;
}

@end