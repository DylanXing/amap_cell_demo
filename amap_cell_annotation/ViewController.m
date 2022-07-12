//
//  ViewController.m
//  amap_cell_annotation
//
//  Created by xing di on 2022/7/12.
//

#import "ViewController.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>
#import "YYCategories.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AMapServices sharedServices].apiKey = @"361de803ba32a0f377d9b7eb87831e61";
    [AMapServices sharedServices].enableHTTPS = YES;
    [AMapSearchAPI updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    [AMapSearchAPI updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1111"];
    cell.backgroundColor = [UIColor systemPinkColor];
    MAMapView *mapView = [[MAMapView alloc]init];
    mapView.rotateEnabled = NO;                //旋转手势关闭
    mapView.rotateCameraEnabled = NO;          //仰角手势关闭
    mapView.showsScale = false;
    mapView.showsCompass = false;
    mapView.delegate = self;
    [cell.contentView addSubview:mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(cell.contentView).inset(8);
        make.width.mas_equalTo(120);
    }];
    
    //两个annotation
    NSMutableArray *items = [[NSMutableArray alloc]initWithCapacity:2];
    MAPointAnnotation *annotation1 = [[MAPointAnnotation alloc]init];
    annotation1.coordinate = CLLocationCoordinate2DMake(37.015526,99.589297);
    annotation1.title = @"青海湖";
    annotation1.subtitle = @"这是一首简单的小情歌";
    [items addObject:annotation1];
    
    MAPointAnnotation *annotation2 = [[MAPointAnnotation alloc]init];
    annotation2.coordinate = CLLocationCoordinate2DMake(36.661073,117.015873);
    annotation2.title = @"趵突泉";
    annotation2.subtitle = @"唱着人们心头的白鸽";
    [items addObject:annotation2];
    
    [mapView addAnnotations:items];
    [mapView showAnnotations:items animated:YES];
    return cell;
}
//添加标注回调
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
 if ([annotation isKindOfClass:[MAPointAnnotation class]]){
//        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotation.subtitle];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:annotation.subtitle];
        }
        annotationView.image = [UIImage imageNamed:@"img_map_des"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, 0);
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.width = 6;
        annotationView.height = 6;
        return annotationView;
    }
    return nil;
}
@end
