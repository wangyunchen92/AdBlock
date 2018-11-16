//
//  Fmdbmode.m
//  FMdbdemo
//
//  Created by 王云晨 on 16/5/24.
//  Copyright © 2016年 王云晨. All rights reserved.
//

#import "Fmdbmode.h"
#import "Model.h"
#import <FMDB.h>

#define AppGroupIdentifier @"group.ForAdBlockGroup"

@interface Fmdbmode ()

@end

static Fmdbmode *manage;

@implementation Fmdbmode

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manage) {
            manage = [[Fmdbmode alloc] init];
            [manage CreatTable:@""];
        }
    });
    return manage;
}

- (void)CreatTable:(NSString *)table {
    FMDatabase *db = [self Fmdbdatabase];
    NSString *FmdbCreatFirstTable=@"CREATE TABLE IF NOT EXISTS backPhoneNumber(uuid INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, number INTEGER UNIQUE)";
    BOOL res= [db executeStatements:FmdbCreatFirstTable];
    if (!res) {
        NSLog(@"error when creating db");
    }
    else
    {
        NSLog(@"success to creating db");
    }
    [db close];
}

- (FMDatabase *)Fmdbdatabase {
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AppGroupIdentifier];
    
    NSString *dbPath = [[containerURL absoluteString] stringByAppendingPathComponent:@"MyDatabase.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    [db open];
    if (![db open])
    {
        NSLog(@"Could not open db");
    }
    return db;
}

- (NSMutableArray *)executeQuery:(NSString *)sql {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    FMDatabase *db = [self Fmdbdatabase];
    FMResultSet *set = [db executeQuery:sql];
    while ([set next]) {
        @autoreleasepool {
            [tempArray addObject:set.resultDictionary];
        }
    }
    return tempArray;
}



- (void)insterDate:(Model *)model {
    FMDatabase *db = [self Fmdbdatabase];
    [db executeUpdate:@"INSERT INTO backPhoneNumber (name, number) VALUES (?, ?);", model.name, model.number];
}

@end
