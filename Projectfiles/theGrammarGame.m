//
//  theGrammarGame.m
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "theGrammarGame.h"
#import "parseCSV.h"
#import "Sentence.h"

@implementation theGrammarGame

@synthesize team1Cube;
@synthesize team2Cube;
@synthesize team1Name;
@synthesize team2Name;
@synthesize mode;
@synthesize currentLevel;

- (id) initSingleton
{
    if ((self = [super init]))
    {
        
        team1Cube = @"Cube 1";
        team2Cube = @"Cube 2";
        team1Name = @"Cube 1 Navn";
        team2Name = @"Cube 2 Navn";
        
        mode = grammarPractice;
        currentLevel = 0;
        //Load the sentences from the data file
        CSVParser * parser = [CSVParser new];
        
        //Setting the
        for (int i=0;i<5;i++) {
            currentSentence[i] = -1;
            numberOfSentences[i] = 0;
        }
        
        [parser setDelimiter:';'];
        
        //Getting the file with sentences
        bool res = [parser openFile:@"saetninger_lol.csv"];
        
        if (res) {
            
            //alloc data for the sentence library
            sentences = [[NSMutableArray alloc] init];
            
            [parser setEncoding:NSUTF8StringEncoding];
            
            NSMutableArray *csvContent = [parser parseFile];
            int c;
        
            for (c = 0; c < (int)[csvContent count]; c++) {
                
                NSMutableArray * lineContent = [csvContent objectAtIndex: c];
                
                if ([lineContent count]>3) {
                    
                    // 0 ID
                    // 1 Tekst
                    // 2 Level
                    // 3 Comma
                    // 4-> Cross, Cirkel
                    
                    Sentence * sentence = [[ Sentence alloc ] init:[lineContent objectAtIndex:1]];
                    
                    //Lets extract the level value
                    int level = [[lineContent objectAtIndex:2] intValue] - 1;
                    //adding comma
                    
                    [sentence setLevel:level];
                    
                    if (level>=0 && level<=4)
                        numberOfSentences[level]++;
                    
                    [sentence setNumber:numberOfSentences[level]];
                    
                    [sentence addCommaFromString:[lineContent objectAtIndex:3]];
                    
                    for (unsigned int n = 4; n < [lineContent count]; n=n+2) {
                        [sentence addWordClassFromString:[lineContent objectAtIndex:n] :cross_symbol];
                        [sentence addWordClassFromString:[lineContent objectAtIndex:(n+1)] :circle_symbol];
                    }
                    
                    //Adding the sentence object to the pile of sentences
                    [sentences addObject:sentence];
                
                }
                
            }
            
        }
        
    }
    
    return self;
}

-(void) nextWord
{
    Sentence * s = [self getCurrentSentence:currentLevel];
    
    [s nextWord];
}

-(void) previousWord
{
    Sentence * s = [self getCurrentSentence:currentLevel];
    
    [s previousWord];
}

-(int) getNumberOfSentencesForLevel
{
    return numberOfSentences[currentLevel];
}

-(int) getCurrentSentenceNumber
{
    return currentSentence[currentLevel];
}
-(Sentence *) getCurrentSentence
{
    return [self getCurrentSentence:currentLevel];
}

-(Sentence *) getCurrentSentence:(int) level
{
    if (level<0 || level>4)
        return nil;
    
    //no sentence has been selected
    if (currentSentence[level] < 0)
        return  [self getNextSentence];
    
    Sentence * s = [sentences objectAtIndex:currentSentence[level]];
    
    //returning the current sentence for the current level
    return s;
}

//return true if all sentences on the level has been solved
//either false
-(Boolean) getLevelStatus:(int)level
{
    Boolean allSolved = true;
    
    for (unsigned int i = 0; i < [sentences count]; i++) {
        
        Sentence * s = [sentences objectAtIndex:i];
        //
        if ([s level] == level && ![s hasBeenSolved]) {
            return false;
        }
    }

    return allSolved;
}
-(Sentence *) getNextSentence
{
    int textsSolvedForLevel = 0;
    
    for (unsigned int i = 0; i < [sentences count]; i++) {
        
        Sentence * s = [sentences objectAtIndex:i];
        //
        if ([s level] == currentLevel && [s hasBeenSolved]) {
            textsSolvedForLevel++;
            //increase the level if all texts has been solved
            //if we are in time mode only 2 has to be solved
            if (textsSolvedForLevel==10) {
                currentLevel++;
            }
        }
        
        if (![s hasBeenSolved] && [s level] == currentLevel) {
            
            currentSentence[currentLevel] = i;
            
            return s;
        }
    }
    
    //Huston we have a problem
    [self resetGameStatus];
    
    currentSentence[currentLevel] = 0;
    Sentence * s = [sentences objectAtIndex:0];
    
    return s;
}

-(NSString *) getNextTextSentence
{
    NSString * str = @"Alle sætninger er brugt for dette niveau";
    
    for (unsigned int i = 0; i < [sentences count]; i++) {
        
        Sentence * s = [sentences objectAtIndex:i];
        if (![s hasBeenSolved] && [s level] == currentLevel) {
            return [s text];
        }
    }
    
    return str;
}

-(void) resetGameStatus
{
    mode = grammarPractice;
    currentLevel = 0;
    //Setting the
    for (int i=0;i<5;i++) {
        currentSentence[i] = -1;
        //numberOfSentences[i] = 0;
    }
    
    //reset status for all the sentences
    for (unsigned int i = 0; i < [sentences count]; i++) {
        
        Sentence * s = [sentences objectAtIndex:i];
        
        [s setHasBeenSolved:false];
        //remove all the suggeste symbols and komma suggestions
        [s removeSymbolAndKommaSuggestions];
        
    }
    
}
//
//Database support
//

-(NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"grammar.db"];
}

-(Boolean) openDB {
    NSString *dbfilepath = [self filePath];
    //NSString *dbfilepath = @"/Users/jcb/Documents/grammar.db";
    
    NSLog(@"Database Path %@",dbfilepath);
    
    const char *dbpath = [dbfilepath UTF8String];
    
    int err = sqlite3_open(dbpath, &db);
    
    if (err != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0,@"Database failed to open");
        
        return false;
    }
    
    return true;
}

-(Boolean) createTable
{
    char *err;
    
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS GRAMMAR_STAT (ID INTEGER PRIMARY KEY, TEAM TEXT, LEVEL INTEGER, SENTENCE INTEGER, SOLVED INTEGER)"];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0,@"Database failed to create table");
        
        return false;
    }
    
    return true;
}

-(void) closeDB
{
    sqlite3_close(db);
}

//Set the sentence status
-(void) setSentenceStatus:(int) level:(int) sentenceNumber:(int) solved
{
    for (unsigned int i = 0; i < [sentences count]; i++) {
        
        Sentence * s = [sentences objectAtIndex:i];
        
        if ([s level] == level && [s number]== sentenceNumber) {
            [s setHasBeenSolved:solved];
        }
        
    }
}

-(void) loadStatus
{
    //if both names are empty
    //no need to store the status
    if ([team1Name length] == 0 && [team2Name length] == 0)
        return;
    
    if (![self openDB])
        return;
    
    if (![self createTable])
        return;
    
    //Ok data base is ready
    
    NSString * team = [NSString stringWithFormat:@"%@_%@",team1Name,team2Name ];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM GRAMMAR_STAT WHERE TEAM='%@'",team];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            //Column 0 is the unique ID entry
            
            char *teamn = (char*) sqlite3_column_text(statement,1);
            
            NSString * team = [NSString stringWithUTF8String:teamn];
            
            int level = (int) sqlite3_column_int(statement, 2);
            
            int sentenceNumber = (int) sqlite3_column_int(statement, 3);
            
            int solved = (int) sqlite3_column_int(statement, 4);
            
            //Update the status of the sentence from the database
            [self setSentenceStatus:level :sentenceNumber :solved];
            
        }
    }
    
    [self getNextSentence];
    //Close the database
    [self closeDB];
}
//Store the status in the database
-(void) saveStatus
{
    //if both names are empty
    //no need to store the status
    if ([team1Name length] == 0 && [team2Name length] == 0)
        return;
    
    if (![self openDB])
        return;
    
    if (![self createTable])
        return;
    
    //TEAM: name1_name2
    //Level
    //Sentence NUMBER (could be ID)
    //solved or not solved
    
    char *err;
    
    NSString * team = [NSString stringWithFormat:@"%@_%@",team1Name,team2Name ];
    
    NSString * sqlDelete = [NSString stringWithFormat:@"DELETE FROM GRAMMAR_STAT WHERE TEAM='%@'",team];
    
    if (sqlite3_exec(db, [sqlDelete UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0,@"Unable delete data into table");
    }
    
    for (unsigned int i = 0; i < [sentences count]; i++) {
        
        Sentence * s = [sentences objectAtIndex:i];
        //
        //Sentence has been solved??
        if ([s hasBeenSolved]) {
            //Store in database
            
            
            NSString * sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO GRAMMAR_STAT ('TEAM',LEVEL,SENTENCE,SOLVED) VALUES ('%@',%d,%d,%d)",team,[s level],[s number],[s hasBeenSolved]];
            
            if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
                sqlite3_close(db);
                NSAssert(0,@"Unable to insert data into table");
            }
        }
    }
    
}

+ (theGrammarGame *) instance
{
    // Persistent instance.
    static theGrammarGame *_default = nil;
    
    // Small optimization to avoid wasting time after the
    // singleton being initialized.
    if (_default != nil)
    {
        return _default;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    // Allocates once with Grand Central Dispatch (GCD) routine.
    // It's thread safe.
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
                  {
                      _default = [[theGrammarGame alloc] initSingleton];
                  });
#else
    // Allocates once using the old approach, it's slower.
    // It's thread safe.
    @synchronized([theGrammarGame class])
    {
        // The synchronized instruction will make sure,
        // that only one thread will access this point at a time.
        if (_default == nil)
        {
            _default = [[CubeEnumurator alloc] initSingleton];
        }
    }
#endif
    return _default;
}


@end
