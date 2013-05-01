//
//  Sentence.h
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wordClass.h"

typedef enum { correct_answer, wrong_comma_position, wrong_symbol, wrong_symbol_position } answerStatus;

@interface Sentence : NSObject {
    
    //the sentence 
    NSString * text;
    //x og o
    NSArray * words;
    
    //Contains all the positions and types of word classes of the sentence
    NSMutableArray * wordClassList;
    //Kommapositions in the sentece
    NSMutableArray * kommaPositions;
    
    NSMutableDictionary * suggestedSymbolPositions;
    NSMutableArray * suggestedKommaPositions;
    
    int level;
    int number;
    int uid;
    //
    bool hasBeenSolved;
    bool result;
    int currentWord;
}

-(Sentence*) init: (NSString *) sentence;
-(void) addWordClass: (int) position : (grammarSymbolType) wct;
-(void) addComma: (int) position;
-(void) addWordClassFromString: (NSString *) positions : (grammarSymbolType) wct;
-(void) addCommaFromString: (NSString *) positions;

-(void) addCommaSuggestion;
-(void) addSymbolSuggestion:(grammarSymbolType) symbol;

-(void) removeSymbolAndKommaSuggestions;

-(NSString*) getTextWithComma;

-(bool) checkSuggestions;

-(int) getNumberOfWords;
-(void) nextWord;
-(void) previousWord;

//Must have interface for the setting of sumbols
//adding symbol

@property (nonatomic) bool hasBeenSolved;
@property (nonatomic) int level;
@property (nonatomic) int number;
@property (nonatomic) int uid;
@property (strong,nonatomic) NSString * text;
@property (strong,nonatomic) NSArray * words;
@property (nonatomic) int currentWord;
@property (strong,nonatomic) NSMutableDictionary * suggestedSymbolPositions;
@property (nonatomic) bool result;
@end
