//
//  SourceEditorCommand.m
//  EFColorStandardizing
//
//  Created by zuoming on 2017/6/12.
//  Copyright © 2017年 zuoming. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "EFColorMapUtil.h"


@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    XCSourceTextRange *selection = invocation.buffer.selections.firstObject;
    
    //    invocation.buffer.lines[index] = @"hh";
    //    NSString *ide = invocation.commandIdentifier;
    
    if (selection.start.line != selection.end.line) {
        completionHandler(nil);
        return;
    }
    
    XCSourceTextPosition start = selection.start;
    XCSourceTextPosition end = selection.end;
    NSString *line = invocation.buffer.lines[start.line];
    
    if (start.column < 0 || end.column < 0 || start.column >= line.length || end.column >= line.length) {
        completionHandler(nil);
        return;
    }
    
    NSString *selectionString = [line substringWithRange:NSMakeRange(start.column, end.column - start.column)];
    if ([selectionString isEqualToString:@"version"]) {
        invocation.buffer.lines[start.line] = [line stringByAppendingFormat:@"//适用于开发版本：%@", [EFColorMapUtil version]];
        completionHandler(nil);
        return;
    }
    
    NSString *standardColor = [EFColorMapUtil standardColrStatementWith:[selectionString stringByReplacingOccurrencesOfString:@"0x" withString:@""]];
    if (!standardColor) {
        completionHandler(nil);
        return;
    }
    
    NSString *newSelectionString = [NSString stringWithFormat:@"RGB_HEX(%@)",selectionString];
    line = [line stringByReplacingOccurrencesOfString:newSelectionString withString:standardColor];
    invocation.buffer.lines[start.line] = line;
    
    completionHandler(nil);
}




@end
