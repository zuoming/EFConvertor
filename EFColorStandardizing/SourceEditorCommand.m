//
//  SourceEditorCommand.m
//  EFColorStandardizing
//
//  Created by zuoming on 2017/6/12.
//  Copyright © 2017年 zuoming. All rights reserved.
//

#import "SourceEditorCommand.h"

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
    NSInteger index = selection.start.line;
    
    
    completionHandler(nil);
}

@end
