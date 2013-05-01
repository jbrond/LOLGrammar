//
//  theGrammarGame.h
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sentence.h"
#import "sqlite3.h"

typedef enum { grammarPractice, grammarGame } grammarGameMode;


//This singleton contains the grammar game data

@interface theGrammarGame : NSObject {
    
    //The current mode of the application
    grammarGameMode mode;
    //
    
    NSString * team1Cube;
    NSString * team2Cube;
    NSString * team1Name;
    NSString * team2Name;
    
    //Contains all the sentences 
    NSMutableArray * sentences;
    //Current level working on
    int currentLevel;
    
    //thats the current sentence for specific level
    int currentSentence[5];
    int numberOfSentences[5];
    
    sqlite3 *db;
}

@property (strong, nonatomic) NSString * team1Cube;
@property (strong, nonatomic) NSString * team2Cube;
@property (strong, nonatomic) NSString * team1Name;
@property (strong, nonatomic) NSString * team2Name;
@property (nonatomic) grammarGameMode mode;
@property (nonatomic) int currentLevel;

+ (theGrammarGame *) instance;
//Returning the number of levels of the game
-(Sentence *) getCurrentSentence:(int) level;
-(Sentence *) getCurrentSentence;
-(int) getCurrentSentenceNumber;
-(int) getNumberOfSentencesForLevel;
-(void) nextWord;
-(void) previousWord;
-(void) saveStatus;
-(void) loadStatus;
-(void) resetGameStatus;
//Based on mode it will return either the next sentence of th current level
-(Sentence *) getNextSentence;
-(Boolean) getLevelStatus:(int)level;
@end
