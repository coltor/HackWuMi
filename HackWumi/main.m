
//
//  main.mm
//  HackWumi
//
//  Created by akong on 14-11-14.
//
//

#import "substrate.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIAlertView+Blocks.h"

typedef void (*pfn_viewDidLoad)(id self,SEL _cmd);
static pfn_viewDidLoad Real_viewDidLoad = NULL;
void Mine_viewDidLoad(id self,SEL _cmd);

typedef void (*pfn_imageDestroying)(id self,SEL _cmd);
static pfn_viewDidLoad Real_imageDestroying = NULL;
void Mine_imageDestroying(id self,SEL _cmd);


#define NS_TITLE    @"保存图片"
#define NS_MESSAGE  @"图片即将销毁,是否立即保存?"


MSInitialize
{
    MSHookMessageEx(objc_getClass("WMBrowseTransientImageViewController"), @selector(viewDidLoad), (IMP)Mine_viewDidLoad, (IMP*)&Real_viewDidLoad);
    
    MSHookMessageEx(objc_getClass("WMBrowseTransientImageViewController"), @selector(imageDestroying), (IMP)Mine_imageDestroying, (IMP*)&Real_imageDestroying);
}

void Mine_viewDidLoad(id self,SEL _cmd)
{
    Real_viewDidLoad(self,_cmd);
    
    objc_msgSend(self, @selector(setRemainTimeInMs:),20);
    
    return;
}

//void Mine_viewImageContainerViewTouchUp(id self, SEL _cmd,id arg1)
//{
//    RIButtonItem* cancelItem = [RIButtonItem itemWithLabel:@"放弃" action:^{
//        Real_viewImageContainerViewTouchUp(self,_cmd,arg1);
//    }];
//    
//    RIButtonItem* saveItem = [RIButtonItem itemWithLabel:@"保存" action:^{
//        // todo: save image
//        id zoomView = objc_msgSend(self, @selector(imageZoomableView));
//        UIImageView* imageView = (UIImageView*)objc_msgSend(zoomView, @selector(imageView));
//        UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
//        Real_viewImageContainerViewTouchUp(self,_cmd,arg1);
//    }];
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NS_TITLE
//                                                        message:NS_MESSAGE
//                                               cancelButtonItem:cancelItem
//                                               otherButtonItems:saveItem, nil];
//    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//}

void Mine_imageDestroying(id self,SEL _cmd)
{
    RIButtonItem* cancelItem = [RIButtonItem itemWithLabel:@"放弃" action:^{
        Real_imageDestroying(self,_cmd);
    }];
    
    RIButtonItem* saveItem = [RIButtonItem itemWithLabel:@"保存" action:^{
        // todo: save image
        id zoomView = objc_msgSend(self, @selector(imageZoomableView));
        UIImageView* imageView = (UIImageView*)objc_msgSend(zoomView, @selector(imageView));
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
        Real_imageDestroying(self,_cmd);
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NS_TITLE
                                                        message:NS_MESSAGE
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:saveItem, nil];
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}