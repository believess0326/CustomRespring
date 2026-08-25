#import <UIKit/UIKit.h>
#import <rootless.h>

%hook UIImage

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *)traitCollection {
    // 判断是否在请求注销齿轮动画图片
    if ([name hasPrefix:@"gear"] && bundle && [bundle.bundleIdentifier isEqualToString:@"com.apple.BackBoardServices"]) {
        // 构建 Roothide 规范下的自定义图片存放目录
        NSString *customDir = jbroot(@"/Library/Application Support/CustomRespring");
        
        // 拼接完整图片路径 (UIKit 会根据当前设备屏幕倍率自动寻找 @2x / @3x)
        NSString *imagePath = [customDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            return [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    return %orig;
}

%end

// 针对通过 NSBundle pathForResource 直接加载文件路径的兜底拦截
%hook NSBundle

- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext {
    if ([name hasPrefix:@"gear"] && [self.bundleIdentifier isEqualToString:@"com.apple.BackBoardServices"]) {
        NSString *customDir = jbroot(@"/Library/Application Support/CustomRespring");
        NSString *fileName = ext ? [NSString stringWithFormat:@"%@.%@", name, ext] : name;
        NSString *customPath = [customDir stringByAppendingPathComponent:fileName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:customPath]) {
            return customPath;
        }
    }
    return %orig;
}

%end
