//
//  CDMapViewController.m
//  ClusterDemo
//
//  Created by Patrick Nollet on 09/10/12.
//  Copyright (c) 2012 Applidium. All rights reserved.
//

#import "CDMapViewController.h"
#import "ADClusterableAnnotation.h"

@implementation CDMapViewController
@synthesize mapView = _mapView;

#pragma mark - NSObject


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray * annotations = [[NSMutableArray alloc] init];

    self.mapView.visibleMapRect = MKMapRectMake(135888858.533591, 92250098.902419, 190858.927912, 145995.678292);
    _mapView.clusterDiscriminationPower = 1.8;
    
    NSLog(@"Loading data…");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData * JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.seedFileName ofType:@"json"]];

        for (NSDictionary * annotationDictionary in [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:NULL]) {
            ADClusterableAnnotation * annotation = [[ADClusterableAnnotation alloc] initWithDictionary:annotationDictionary];
            [annotations addObject:annotation];
        }
        
        [self.mapView addClusteredAnnotations:annotations];
    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Abstract methods

- (NSString *)seedFileName {
    NSAssert(FALSE, @"This abstract method must be overridden!");
    return nil;
}

- (NSString *)pictoName {
    NSAssert(FALSE, @"This abstract method must be overridden!");
    return nil;
}

- (NSString *)clusterPictoName {
    NSAssert(FALSE, @"This abstract method must be overridden!");
    return nil;
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView * pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ADClusterableAnnotation"];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"ADClusterableAnnotation"];
        pinView.image = [UIImage imageNamed:self.pictoName];
        pinView.canShowCallout = YES;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}


#pragma mark - ADClusterMapView Delegate

- (MKAnnotationView *)mapView:(ADClusterMapView *)mapView viewForClusterAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView * pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ADMapCluster"];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"ADMapCluster"];
        pinView.image = [UIImage imageNamed:self.clusterPictoName];
        pinView.canShowCallout = YES;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)mapView:(ADClusterMapView *)mapView willBeginBuildingClusterTreeForMapPoints:(NSSet *)annotations {
    
    NSLog(@"Kd-tree will begin mapping item count %lu", (unsigned long)annotations.count);
}

- (void)mapView:(ADClusterMapView *)mapView didFinishBuildingClusterTreeForMapPoints:(NSSet *)annotations {
    
    NSLog(@"Kd-tree finished mapping item count %lu", (unsigned long)annotations.count);
}

- (void)mapViewWillBeginClusteringAnimation:(ADClusterMapView *)mapView{
    
     NSLog(@"Animation operation will begin");
}

- (void)mapViewDidCancelClusteringAnimation:(ADClusterMapView *)mapView {
    
    NSLog(@"Animation operation cancelled");
}

- (void)mapViewDidFinishClusteringAnimation:(ADClusterMapView *)mapView{
    
    NSLog(@"Animation operation finished");
}

- (void)userWillPanMapView:(ADClusterMapView *)mapView {
    
    NSLog(@"Map will pan from user interaction");
}

- (void)userDidPanMapView:(ADClusterMapView *)mapView {
    
    NSLog(@"Map did pan from user interaction");
}


@end
