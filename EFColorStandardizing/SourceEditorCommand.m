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
    NSString *standardColor = [self standardColrStatementWith:[selectionString stringByReplacingOccurrencesOfString:@"0x" withString:@""]];
    if (!standardColor) {
        completionHandler(nil);
        return;
    }
    
    NSString *newSelectionString = [NSString stringWithFormat:@"RGB_HEX(%@)",selectionString];
    line = [line stringByReplacingOccurrencesOfString:newSelectionString withString:standardColor];
    invocation.buffer.lines[start.line] = line;
    
    completionHandler(nil);
}


- (NSString *)standardCodeMapsWith:(NSString *)hexColor
{
    NSDictionary *maps = @{@"ffffff":@"C0",
                           @"ff4400":@"C1",
                           @"e8260c":@"C2",
                           @"ff7475":@"C3",
                           @"f5dad0":@"C4",
                           @"fffbeb":@"C5",
                           @"000000":@"C6",
                           @"666666":@"C7",
                           @"999999":@"C8",
                           @"cccccc":@"C9",
                           @"008aff":@"C10",
                           @"007be4":@"C11",
                           @"7cc3ff":@"C12",
                           @"333333":@"C13",
                           @"ff0000":@"C14",
                           @"33cc33":@"C15",
                           @"ff7748":@"C16",
                           @"f8e81c":@"C17",
                           @"dfdfdf":@"C18"
                           };
    return [maps objectForKey:hexColor];
}

- (NSString *)standardColrStatementWith:(NSString *)hexColor
{
    if (hexColor.length == 0) {
        return nil;
    }
    NSString *standardCode = [self standardCodeMapsWith:[hexColor lowercaseString]];
    if (standardCode.length == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"[UIColor ef_color%@]", standardCode];
}

@end
