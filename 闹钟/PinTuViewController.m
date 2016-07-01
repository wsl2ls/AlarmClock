//
//  PinTuViewController.m
//  闹钟
//
//  Created by 王双龙 on 16/6/30.
//  Copyright © 2016年 王双龙. All rights reserved.
//

#import "PinTuViewController.h"

#define kSCREEN_FRAME ([UIScreen mainScreen].applicationFrame)       // 屏幕Frame
#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)      // 屏幕宽度
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)    // 屏幕高度
#define kBounds [UIScreen mainScreen].bounds.size

@interface PinTuViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) UIView *contentview;       //拼图面板
@property (strong,nonatomic) UIImageView *imageView;    //缩略图
@property (assign,nonatomic) int kCol;                  //行列
@property (assign,nonatomic) int kImageWith;            //格子宽度
@property (strong,nonatomic) NSMutableArray *images;    //图片列表
@property (assign,nonatomic) int imageNumber;          //图片名称数
@property (assign,nonatomic) UIImage * currentImage;
@end

@implementation PinTuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _images = [[NSMutableArray alloc] init];
    [self setupUI];
    [self disOrderImage];

    
}
-(void)setupUI {
    _kCol = 3;
    _imageNumber = 1;
    
    _contentview = [[UIView alloc] initWithFrame:CGRectMake(30, 80, (kSCREEN_WIDTH-60), (kSCREEN_WIDTH-60))];
    _contentview.tag = 200;
    
    [self resetViews];
    
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 80, 40)];
    [backBtn setTitle:@"⬅️back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton* btncheck = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btncheck.frame = CGRectMake(_imageView.frame.size.width + 50, _kImageWith * _kCol +50+80, 50, 30);
    [btncheck setTitle:@"3*3" forState:UIControlStateNormal];
    [btncheck setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btncheck addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [btncheck setBackgroundImage:[UIImage imageNamed:@"ic_cart_order"] forState:UIControlStateNormal];
    [btncheck setBackgroundImage:[UIImage imageNamed:@"ic_cart_order_hover"] forState:UIControlStateHighlighted];
    [btncheck.titleLabel setFont:[UIFont systemFontOfSize:15]];
    btncheck.tag = 103;
    [self.view addSubview:btncheck];
    
    UIButton* btncheck2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btncheck2.frame = CGRectMake(_imageView.frame.size.width + 50, _kImageWith * _kCol +50+80+40, 50, 30);
    [btncheck2 setTitle:@"4*4" forState:UIControlStateNormal];
    [btncheck2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btncheck2 addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [btncheck2 setBackgroundImage:[UIImage imageNamed:@"ic_cart_order"] forState:UIControlStateNormal];
    [btncheck2 setBackgroundImage:[UIImage imageNamed:@"ic_cart_order_hover"] forState:UIControlStateHighlighted];
    [btncheck2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    btncheck2.tag = 104;
    [self.view addSubview:btncheck2];
    
    UIButton* btncheck3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btncheck3.frame = CGRectMake(_imageView.frame.size.width + 50, _kImageWith * _kCol +50+80+80, 50, 30);
    [btncheck3 setTitle:@"5*5" forState:UIControlStateNormal];
    [btncheck3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btncheck3 addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [btncheck3 setBackgroundImage:[UIImage imageNamed:@"ic_cart_order"] forState:UIControlStateNormal];
    [btncheck3 setBackgroundImage:[UIImage imageNamed:@"ic_cart_order_hover"] forState:UIControlStateHighlighted];
    [btncheck3.titleLabel setFont:[UIFont systemFontOfSize:15]];
    btncheck3.tag = 105;
    [self.view addSubview:btncheck3];
    
    UIButton* btncheck4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btncheck4.frame = CGRectMake(_imageView.frame.size.width + 50, _kImageWith * _kCol +50+80+80+40, 50, 30);
    [btncheck4 setTitle:@"6*6" forState:UIControlStateNormal];
    [btncheck4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btncheck4 addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [btncheck4 setBackgroundImage:[UIImage imageNamed:@"ic_cart_order"] forState:UIControlStateNormal];
    [btncheck4 setBackgroundImage:[UIImage imageNamed:@"ic_cart_order_hover"] forState:UIControlStateHighlighted];
    [btncheck4.titleLabel setFont:[UIFont systemFontOfSize:15]];
    btncheck4.tag = 106;
    [self.view addSubview:btncheck4];
    
    UIButton* btnreOrderImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnreOrderImage.frame = CGRectMake(_imageView.frame.size.width + 50+80, _kImageWith * _kCol +50+80, 50, 30);
    [btnreOrderImage setTitle:@"打乱" forState:UIControlStateNormal];
    [btnreOrderImage setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnreOrderImage addTarget:self action:@selector(reOrderImage:) forControlEvents:UIControlEventTouchUpInside];
    [btnreOrderImage setBackgroundImage:[UIImage imageNamed:@"ic_cart_order"] forState:UIControlStateNormal];
    [btnreOrderImage setBackgroundImage:[UIImage imageNamed:@"ic_cart_order_hover"] forState:UIControlStateHighlighted];
    [btnreOrderImage.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //    btnreOrderImage.tag = 5;
    [self.view addSubview:btnreOrderImage];
    
    UIButton* btnresetImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnresetImage.frame = CGRectMake(_imageView.frame.size.width+50+80, _kImageWith * _kCol +50+80+40, 50, 30);
    [btnresetImage setTitle:@"还原" forState:UIControlStateNormal];
    [btnresetImage setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnresetImage addTarget:self action:@selector(resetImage:) forControlEvents:UIControlEventTouchUpInside];
    [btnresetImage setBackgroundImage:[UIImage imageNamed:@"ic_cart_order"] forState:UIControlStateNormal];
    [btnresetImage setBackgroundImage:[UIImage imageNamed:@"ic_cart_order_hover"] forState:UIControlStateHighlighted];
    [btnresetImage.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //    btnreOrderImage.tag = 5;
    [self.view addSubview:btnresetImage];
    
    UIButton* btnChangeImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnChangeImage.frame = CGRectMake(_imageView.frame.size.width+50+80, _kImageWith * _kCol +50+80+40+40, 50, 30);
    [btnChangeImage setTitle:@"换图" forState:UIControlStateNormal];
    [btnChangeImage setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnChangeImage addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
    [btnChangeImage setBackgroundImage:[UIImage imageNamed:@"ic_cart_order"] forState:UIControlStateNormal];
    [btnChangeImage setBackgroundImage:[UIImage imageNamed:@"ic_cart_order_hover"] forState:UIControlStateHighlighted];
    [btnChangeImage.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //    btnreOrderImage.tag = 5;
    [self.view addSubview:btnChangeImage];
    
    
    UIButton* choiceImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    choiceImage.frame = CGRectMake(_imageView.frame.size.width+50+80, _kImageWith * _kCol +50+80+40+40+40, 50, 30);
    [choiceImage setTitle:@"选图" forState:UIControlStateNormal];
    [choiceImage setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [choiceImage addTarget:self action:@selector(choiceImage:) forControlEvents:UIControlEventTouchUpInside];
    [choiceImage setBackgroundImage:[UIImage imageNamed:@"ic_cart_order"] forState:UIControlStateNormal];
    [choiceImage setBackgroundImage:[UIImage imageNamed:@"ic_cart_order_hover"] forState:UIControlStateHighlighted];
    [choiceImage.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //    btnreOrderImage.tag = 5;
    [self.view addSubview:choiceImage];

    
    [self.view addSubview:_contentview];
}

- (void)backClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  设置规格
 *
 *  @param btn <#btn description#>
 */
-(void)checkAction:(UIButton *)btn {
    _kCol = (int)btn.tag - 100;
    [_images removeAllObjects];
    [self refreshImageView];
}

/**
 *  切换图片
 *
 *  @param btn <#btn description#>
 */
-(void)changeImage:(UIButton *)btn {
    if (_imageNumber++ == 4) {
        _imageNumber = 1;
    }
    [_images removeAllObjects];
    [self refreshImageView];
}

/**
 *  从手机中选择图片
 *
 *  @param btn <#btn description#>
 */
- (void)choiceImage:(UIButton *)btn{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //处理点击拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }else{
            [self showAlertWithMessage:@"相机无法使用"];
        }
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        //相册库
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else{
            [self showAlertWithMessage:@"无法获取相册库"];
        }
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}
//调用相机和相册库资源
- (void)loadImagePickerWithSourceType:(UIImagePickerControllerSourceType)type{
    //UIImagePickerController 系统封装好的加载相机、相册库资源的类
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //加载不同的资源
    picker.sourceType =type;
    //是否允许picker对图片资源进行优化
    picker.allowsEditing = YES;
    picker.delegate = self;
    //软件中习惯通过present的方式，呈现相册库
    [self presentViewController:picker animated:YES completion:^{
    }];
}
- (void)showAlertWithMessage:(NSString *)message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"温馨提示"                                                                             message:message                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController: alertController animated: YES completion: nil];
    
}
#pragma mark - UIImagePickerControllerDelegate
//点击cancel按钮，调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//点击choose按钮的时候，触发此方法
//info 带有选中资源的信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取资源的类型(图片or视频)
    // NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //kUTTypeImage 代表图片资源类型
    // if ([mediaType isEqualToString:]) {
    //直接拿到选中的图片,
    //手机拍出的照片大概在2M左右，拿到程序中对图片进行频繁处理之前，需要对图片进行转换，否则很容易内存超范围，程序被操作系统杀掉
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _currentImage = image;
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    [self changeImage:nil];
}


/**
 *  换图
 */
-(void)refreshImageView {
    
    [self resetViews];
    [self disOrderImage];
}

/**
 *  打乱排序
 *
 *  @param btn <#btn description#>
 */
-(void)reOrderImage:(UIButton*)btn {
    [self disOrderImage];
}

/**
 *  还原图像
 *
 *  @param btn <#btn description#>
 */
-(void)resetImage:(UIButton*)btn {
    for (int i =0; i<_kCol*_kCol; i++) {
        
        UIImageView *nextimageview = [_images objectAtIndex:i];
        
        UIImageView *imageview = (UIImageView*)[_contentview viewWithTag:i];
        
        CGRect frame = nextimageview.frame;
        [UIView animateWithDuration:1  //动画持续的时间
                              delay:0     //延迟
                            options:UIViewAnimationOptionCurveLinear //设置动画类型
                         animations:^{
                             nextimageview.frame = imageview.frame;
                             imageview.frame = frame;
                         }
                         completion:^(BOOL finished){
                             // 动画结束时的处理
                         }];
        [_images exchangeObjectAtIndex:i withObjectAtIndex: [_images indexOfObject:imageview]];
    }
}

/**
 *  重置图像拼图
 */
-(void)resetViews {
    for (UIView* item in _contentview.subviews) {
        if([item isKindOfClass:[UIImageView class]]){
            [item removeFromSuperview];
        }
    }
    [_images removeAllObjects];
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat: @"image-pintu%d",_imageNumber]];
    
    if (_currentImage == nil) {
       _currentImage = image;
    }
    
    _kImageWith = (kSCREEN_WIDTH-60) / _kCol;
    
    for (int i = 0; i<_kCol * _kCol; i++) {
        int col = i % _kCol;
        int row = i / _kCol;
        int x = (float)col * _kImageWith;
        int y = (float)row * _kImageWith;
        
        CGRect imageRect = CGRectMake(x, y, _kImageWith, _kImageWith);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:imageRect];
        imageview.layer.borderWidth = i == (_kCol*_kCol-1) ? 5 : 1;
        imageview.layer.borderColor = i == (_kCol*_kCol-1) ? [[UIColor redColor] CGColor] : [[UIColor whiteColor] CGColor];
        imageview.layer.cornerRadius = i == (_kCol*_kCol-1) ? 6 : 3;
        imageview.clipsToBounds = YES;
        imageview.userInteractionEnabled = YES; // 设置点击响应
        
        [imageview setImage:[self getSubImage:_currentImage idx:i]];
        
        if (i == (_kCol * _kCol - 1)) {
            imageview.image = nil;
            imageview.layer.borderWidth = 0;
        }
        imageview.tag = i;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageviewTapGestures:)];
        //UITapGestureRecognizer.init(target: self, action: Selector("imageviewTapGestures:"))
        tapGesture.numberOfTapsRequired = 1;
        [imageview addGestureRecognizer:tapGesture];
        
        /// 对换模式用轻扫手势
        UISwipeGestureRecognizer* leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [imageview addGestureRecognizer:leftSwipeGesture];
        
        UISwipeGestureRecognizer* rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [imageview addGestureRecognizer:rightSwipeGesture];
        
        UISwipeGestureRecognizer* upSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [imageview addGestureRecognizer:upSwipeGesture];
        
        UISwipeGestureRecognizer* downSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        downSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [imageview addGestureRecognizer:downSwipeGesture];
        
        [_images addObject:imageview];
        [_contentview addSubview:imageview];
    }
    
    CGRect rect = CGRectMake(30, 300 +50 + 95, (kSCREEN_WIDTH - 60)/2, (kSCREEN_WIDTH - 60)/2);
    
    _imageView = [[UIImageView alloc] initWithFrame:rect];
    [_imageView setImage:_currentImage];
    [self.view addSubview:_imageView];
    _currentImage = nil;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer {
    [self moveImageRecognizer:recognizer];
}

-(void) imageviewTapGestures:(UITapGestureRecognizer*) recognizer{
    [self moveImageRecognizer:recognizer];
}

/**
 *  移动imageView块
 *
 *  @param recognizer
 */
-(void)moveImageRecognizer:(UIGestureRecognizer*) recognizer {
    
    UIImageView *nilimageview = (UIImageView*)[_contentview viewWithTag:(_kCol*_kCol-1)];
    int nilIndex = (int)[_images indexOfObject:nilimageview];   // 空格元素在数列中的位置
    int index = (int)[_images indexOfObject:recognizer.view];   // 点击元素的在数列中的位置
    
    if ([self checkMoveFrom:nilIndex clickIndex:index]) {
        CGRect frame = nilimageview.frame;
        nilimageview.frame = recognizer.view.frame;
        //开始动画
        [UIView animateWithDuration:.25  //动画持续的时间
                              delay:0     //延迟
         // usingSpringWithDamping:.5 initialSpringVelocity:4    // 反弹效果
                            options:UIViewAnimationOptionCurveLinear //设置动画类型
                         animations:^{
                             recognizer.view.frame = frame;
                         }
                         completion:^(BOOL finished){
                             // 动画结束时的处理
                             
                         }];
        [_images exchangeObjectAtIndex:nilIndex withObjectAtIndex:index];
        
        if ([self issucess]) {
            [self sucess];
        }
    }
}

-(void)sucess {
    UIAlertController *alertContrller = [UIAlertController alertControllerWithTitle:nil message:@"拼图完成,是否挑战更高难度?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    UIAlertAction *sucessAction = [UIAlertAction actionWithTitle:@"挑战" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(_kCol ++ == 10){
            _kCol = 3;
            if(_imageNumber ++ == 4){
                _imageNumber = 1;
            }
        }
        
        [self refreshImageView];
    }];
    
    [alertContrller addAction:cancelAction];
    [alertContrller addAction:sucessAction];
    [self presentViewController:alertContrller animated:YES completion:nil];
}

//打乱图片
-(void) disOrderImage {
    if (![self resetImage]) {
        [self disOrderImage];
    }
}

-(BOOL)resetImage {
    for (int i=0; i<10 *_kCol; i++) {
        NSInteger idx1 = arc4random() % (_kCol * _kCol);
        NSInteger idx2 = arc4random() % (_kCol * _kCol);
        
        UIImageView* imgView = _images[idx1];
        UIImageView* imgV = _images[idx2];
        
        CGRect frame = imgV.frame;
        
        [UIView animateWithDuration:1  //动画持续的时间
                              delay:0     //延迟
                            options:UIViewAnimationOptionCurveLinear //设置动画类型
                         animations:^{
                             imgV.frame = imgView.frame;
                             imgView.frame = frame;
                         }
                         completion:^(BOOL finished){}];
        
        [_images exchangeObjectAtIndex:idx1 withObjectAtIndex: idx2];
    }
    if ([self validSequence]) {
        return true;
        
    }else {
        return false;
    }
    
}

//根据数列的tag计算逆序数,由于原数列tag的逆序数为0,计算后的逆序数需要保持奇偶性不一致
-(BOOL) validSequence {
    NSInteger count = 0;
    NSInteger a = 0;
    NSInteger b = 0;
    NSInteger m = 0;
    NSInteger n = 0;
    
    NSInteger len = [_images count];
    NSInteger size = _kCol ;
    for (int i=0; i<len; i++) {
        UIImageView *imageview = (UIImageView*)[_images objectAtIndex:i];
        a = imageview.tag;
        
        if (a==size*size-1) {
            m = i/size + 1;
            n = i%size + 1;
        }
        
        for (int j=i+1; j<len; j++) {
            UIImageView *imageviewnext = (UIImageView*)[_images objectAtIndex:j];
            b = imageviewnext.tag;
            if (b < a) {
                count ++;
            }
        }
    }
    count += m;
    count += n;
    //    if (count%2==0) {
    //        NSLog(@"row:%ld,col:%ld 奇偶性:%ld",m,n,count);
    //        [_listtest removeAllObjects];
    //        for (int i = 0; i<_kCol*_kCol; i++) {
    //            UIImageView *imageview = [_images objectAtIndex:i];
    //
    //            NSLog(@"%ld",imageview.tag);
    //            NSInteger taga = imageview.tag;
    //            [_listtest addObject:[NSString stringWithFormat:@"%ld",taga]];
    //        }
    //        NSLog(@"________________________________");
    //    }
    return count%2==0;
}

/**
 *  判断元素是否可以移动
 *
 *  @param nilIndex   空格在数列中的位置
 *  @param clickIndex 点击的项在序列中的位置
 *
 *  @return 返回是否可以移动
 */
- (BOOL) checkMoveFrom:(int)nilIndex clickIndex:(int)clickIndex {
    int otherPosintion = -1;    // 当空格满足当中的其中一个条件时,就去空格的其他三种或两种情况是否满足,满足就给移动
    int upViewLocation = [self borderType:nilIndex]== 3 ? otherPosintion:(nilIndex - _kCol);
    int downViewLocation = [self borderType:nilIndex]== 4 ? otherPosintion:(nilIndex + _kCol);
    int leftViewLocation = [self borderType:nilIndex]== 1 ? otherPosintion:(nilIndex - 1);
    int rightViewLocation = [self borderType:nilIndex]== 2 ? otherPosintion:(nilIndex + 1);
    
    if(clickIndex == upViewLocation || clickIndex == downViewLocation || clickIndex == leftViewLocation || clickIndex == rightViewLocation){
        return true;
    }
    return false;
}

-(int) borderType:(int)nilIndex  {
    
    /*!
     *  是否为左边界的点
     */
    if ((nilIndex)%_kCol == 0){
        return 1;
    }
    /*!
     *  是否为右边界
     */
    if ((nilIndex+1)%_kCol == 0){
        return 2;
    }
    /*!
     *  是否为上边界
     */
    if (nilIndex < _kCol){
        return 3;
    }
    /*!
     *  是否为下边界
     */
    if (nilIndex >= _kCol*_kCol - _kCol){
        return 4;
    }
    return -1;
}


-(BOOL) issucess {
    int iskcol = 0;
    for (int i = 0; i<_kCol*_kCol; i++) {
        UIImageView *imageview = [_images objectAtIndex:i];
        if(imageview.tag == i){
            iskcol ++;
        }
        continue;
    }
    if (iskcol == _kCol*_kCol) {
        return YES;
    }
    return NO;
}

/**
 *  得到分割后的部分图片
 *
 *  @param image <#image description#>
 *  @param idx   <#idx description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *) getSubImage:(UIImage *)image idx:(int) idx{
    float cgImgH = image.size.height;
    float cgImgW = image.size.width;
    
    float eleH = cgImgH / (float)_kCol;
    float eleW = cgImgW / (float)_kCol;
    
    float space = eleH < eleW ? eleH : eleW;
    float topX = (cgImgW - space * (float)_kCol) * 0.5;
    float topY = (cgImgH - space * (float)_kCol) * 0.5;
    float X = topX + space * (float)(idx % _kCol);
    float Y = topY + space * (float)(idx / _kCol);
    
    CGRect rect = CGRectMake(X, Y, space, space);
    
    CGImageRef subImageref = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageref), CGImageGetHeight(subImageref));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageref);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageref];
    UIGraphicsEndImageContext();
    
    return smallImage;
}
#pragma mark --- 点赞动画
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self praise];
}

- (void)praise{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(kBounds.width - 60, kBounds.height - 49, 35, 35);
    imageView.image = [UIImage imageNamed:@"heart"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    
    CGFloat startX = round(random() % 200);
    CGFloat scale = round(random() % 2) + 1.0;
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    int imageName = round(random() % 12);
    NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
    
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    [UIView setAnimationDuration:7 * speed];
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"resource.bundle/heart%d.png",imageName]];
    imageView.frame = CGRectMake(kBounds.width - startX, -100, 35 * scale, 35 * scale);
    
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
