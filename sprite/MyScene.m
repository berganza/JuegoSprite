//
//  MyScene.m
//  sprite
//
//  Created by LLBER on 30/11/13.
//  Copyright (c) 2013 LLBER. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

@synthesize titulo, puntacion, vida, puntos, vidas, enemigo, nave;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        // Imagen de fondo
        self.backgroundColor = [SKColor lightGrayColor];
        
        SKSpriteNode *imagen = [SKSpriteNode spriteNodeWithImageNamed:@"espacio"];
        imagen.position = CGPointMake(160,256);//(160,250);
        [self addChild: imagen];

        
        // Fuerza de la física
        self.physicsWorld.gravity = CGVectorMake(-0.20, -2);
        self.physicsWorld.contactDelegate = self;
        
        
        

        

        // Etiqueta titulo del juego
        titulo = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        titulo.text = @"juego";
        titulo.fontSize = 25;
        titulo.position = CGPointMake(85, 20);
        
        [self addChild:titulo];
        
        
        // Etiqueta label vidas
        vidas = 3;
        
        vida = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        vida.text = @"Vidas: 3";
        vida.fontSize = 20;
        vida.position = CGPointMake(60, 520);
        
        [self addChild:vida];
        
        
        // Etiqueta label puntos
        puntos = 0;
        
        puntacion = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        puntacion.text = @"Puntos: 0";
        puntacion.fontSize = 20;
        puntacion.position = CGPointMake(240, 520);
        
        [self addChild:puntacion];
        
        
        // Nave
        nave = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        nave.name = @"nave";
        nave.size = CGSizeMake(50, 50);
        nave.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:nave.size];
        nave.physicsBody.affectedByGravity = NO;
        nave.physicsBody.dynamic = NO;
        
        [self addChild:nave];
        

        // Partículas 
        NSString *fireArchivo = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
        SKEmitterNode * fireEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:fireArchivo];
        fireEmitter.targetNode = self;
        fireEmitter.position = CGPointMake(nave.frame.origin.x + nave.frame.size.width/2, nave.frame.origin.y);
        
        
        nave.position = CGPointMake(150, 250);
        nave.physicsBody.contactTestBitMask = 0x1 << 1;
        
        
        // Sumamos los enemigos a la escena
        enemigo = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(sumarEnemigos) userInfo:Nil repeats:YES];
        
        [nave addChild:fireEmitter];
        
        
        // Posicionamos nuestra nave
        nave.position = CGPointMake(150, 250);
        nave.physicsBody.contactTestBitMask = 0x1 << 1;
        
    }
    return self;
}

        // Comportamiento de los enemigos
- (void) sumarEnemigos {
    
    int randomNumber = rand() % 2;
    
    NSString * imagen;
    if (randomNumber == 1) {
        imagen = @"enemigo1";
    } else {
        imagen = @"enemigo2";
    }
    
    SKSpriteNode *navesEnemigas = [SKSpriteNode spriteNodeWithImageNamed:imagen];
    navesEnemigas.name = @"enemigos";
    
    int tamanioEnemigo = rand() % 10 + 30;
    
    navesEnemigas.size = CGSizeMake(tamanioEnemigo, tamanioEnemigo);
    
    int ancho = rand() % 300;
    int alto = rand() % 1 + 500;
    
    navesEnemigas.position = CGPointMake(ancho, alto);
    
    // Implementamos la física a las naves enemigas
    navesEnemigas.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:navesEnemigas.size];
    navesEnemigas.physicsBody.affectedByGravity = YES;
    navesEnemigas.physicsBody.dynamic = YES;
    nave.physicsBody.contactTestBitMask = 0x1 << 1;
    
    [self addChild:navesEnemigas];
}


        // Definimos que hacer cuando entran en contacto nuestra nave con las naves enemigas
-(void) didBeginContact:(SKPhysicsContact *)contact {
    
    SKNode *cuerpo1 = contact.bodyA.node;
    SKNode *cuerpo2 = contact.bodyB.node;
    
    if ([cuerpo1.name isEqualToString:@"nave"] && [cuerpo2.name isEqualToString:@"enemigos"]) {
        [self removeChildrenInArray:@[contact.bodyB.node]];
        
        vidas--;
        vida.text = [NSString stringWithFormat:@"Vidas :%i", vidas];
        
        if (vidas == 0) {
            titulo.text = @"Game Over";
            self.view.userInteractionEnabled = NO;
            [self removeChildrenInArray:@[contact.bodyA.node]];
            [enemigo invalidate];
        }
    }
    
    // Definimos que hacer cuando entran en contacto nuestro misil con las naves enemigas
    if ([cuerpo1.name isEqualToString:@"enemigos"] && [cuerpo2.name isEqualToString:@"misil"]) {
        [self removeChildrenInArray:@[contact.bodyB.node, contact.bodyA.node]];
        
        puntos++;
        puntacion.text = [NSString stringWithFormat:@"Puntos :%i", puntos];
    }
}

    // Implementamos el misil y definimos su física
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    SKSpriteNode * imagenMisil = [SKSpriteNode spriteNodeWithImageNamed:@"misil"];
    imagenMisil.name = @"misil";
    
    SKEmitterNode * estelaMisil = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"smoke" ofType:@"sks"]];
    estelaMisil.position = imagenMisil.position;
    [imagenMisil addChild:estelaMisil];
    
    imagenMisil.size = CGSizeMake(imagenMisil.size.width, imagenMisil.size.height);
    imagenMisil.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:imagenMisil.size.width/2];
    imagenMisil.position = CGPointMake(nave.position.x, nave.position.y + nave.frame.size.height);
    
    imagenMisil.physicsBody.dynamic = YES;
    
    imagenMisil.physicsBody.contactTestBitMask = 0x1 << 1;
    imagenMisil.physicsBody.affectedByGravity = NO;
    
    [self addChild:imagenMisil];
    [imagenMisil.physicsBody applyForce:CGVectorMake(0, 50)];
    
}

    // Implementamos el movimiento a nuestra nave con el TAP del touches
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint puntoInicial = [[touches anyObject] locationInNode:self];
    nave.position = puntoInicial;
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
