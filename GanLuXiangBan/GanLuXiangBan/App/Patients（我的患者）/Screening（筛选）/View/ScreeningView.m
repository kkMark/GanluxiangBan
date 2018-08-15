//
//  ScreeningView.m
//  GanLuXiangBan
//
//  Created by M on 2018/6/20.
//  Copyright © 2018年 黄锡凯. All rights reserved.
//

#import "ScreeningView.h"

@implementation ScreeningView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UIImage *img = [UIImage imageNamed:@"SelectPatients"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.size = img.size;
        cell.accessoryView = imageView;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.dataSources[indexPath.row];
    return cell;
}

@end
