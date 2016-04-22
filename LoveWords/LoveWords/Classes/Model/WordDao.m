//
//  WordDao.m
//  LoveWords
//
//  Created by youdingquan on 16/4/21.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "WordDao.h"
#import <FMDB.h>
#import "Word.h"

@implementation WordDao

+(FMDatabase *)getCurrentDB{
    static FMDatabase * db = nil;
    if (!db) {
        NSString * path = [NSString stringWithFormat:@"%@/Documents/myword.db",NSHomeDirectory()];
        NSLog(@"%@",path);
        db = [FMDatabase databaseWithPath:path];
        
        NSFileManager * filemanager = [NSFileManager defaultManager];
        if (![filemanager fileExistsAtPath:path]) {
            if ([db open]) {
                NSString * createWord = @"create table word(name text primary key, paraphrase text, state integer, adddate text);";
                [db executeStatements:createWord];
                [db close];
            }
        }
    }
    return db;
}

+(BOOL)save:(Word *)model{
    FMDatabase * db = [self getCurrentDB];
    if ([db open]) {
        BOOL isSuccese = [db executeUpdate:@"insert into word(name, paraphrase, state, adddate) values(?, ?, ?, ?)",model.name, model.paraphrase, [NSString stringWithFormat:@"%ld",model.state], model.addDate];
        [db close];
        return isSuccese;
    }
    return NO;
}

+(BOOL)update:(Word *)model{
    FMDatabase * db = [self getCurrentDB];
    if ([db open]) {
        BOOL isSuccese = [db executeUpdate:@"update word set name=?, paraphrase=?, state=?, adddate=? where name=?", model.name, model.paraphrase, [NSString stringWithFormat:@"%ld",model.state], model.addDate, model.name];
        [db close];
        return isSuccese;
    }
    return NO;
}

+(NSMutableArray *)findAll{
    FMDatabase * db = [self getCurrentDB];
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:@"select * from word"];
        NSMutableArray * wordArray = [NSMutableArray new];
        while (rs.next) {
            Word * word = [[Word alloc] init];
            word.name = [rs stringForColumnIndex:0];
            word.paraphrase = [rs stringForColumnIndex:1];
            word.state = [rs intForColumnIndex:2];
            word.addDate = [rs stringForColumnIndex:3];
            [wordArray insertObject:word atIndex:0];
        }
        [db close];
        [wordArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Word * word1 = obj1;
            Word * word2 = obj2;
            return [word2.addDate compare:word1.addDate];
        }];
        return wordArray;
    }
    return nil;
}

+(NSMutableArray *)findAtState:(NSInteger)state{
    FMDatabase * db = [self getCurrentDB];
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:@"select * from word"];
        NSMutableArray * wordArray = [NSMutableArray new];
        while (rs.next) {
            if ([rs intForColumnIndex:2] == state) {
                Word * word = [[Word alloc] init];
                word.name = [rs stringForColumnIndex:0];
                word.paraphrase = [rs stringForColumnIndex:1];
                word.state = [rs intForColumnIndex:2];
                word.addDate = [rs stringForColumnIndex:3];
                [wordArray insertObject:word atIndex:0];
            }
        }
        [db close];
        [wordArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Word * word1 = obj1;
            Word * word2 = obj2;
            return [word2.addDate compare:word1.addDate];
        }];
        return wordArray;
    }
    return nil;
}

@end
