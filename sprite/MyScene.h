//
//  MyScene.h
//  sprite
//

//  Copyright (c) 2013 LLBER. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene<SKPhysicsContactDelegate>


// Declaramos e introducimos el delegado del SKPhysics 

@property SKLabelNode *titulo;
@property SKLabelNode *puntacion;
@property SKLabelNode *vida;

@property int puntos;
@property int vidas;

@property NSTimer *enemigo;

@property SKSpriteNode *nave;



@end
