//
//  UITableView+Index.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/27.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "UITableView+Index.h"

@implementation UITableView (Index)

/**
 *  获取当前indexPath在当前TableView所有cell中所处的index
 *
 *  @param indexPath 当前的indexPath
 *
 *  @return 当前indexPath在所有cell中所处的index
 */
- (NSInteger)indexOfAllTableViewCellWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    for (int i = 0; i < indexPath.section; i++) {
        index += [self numberOfRowsInSection:i];
    }
    return index;
}

@end
