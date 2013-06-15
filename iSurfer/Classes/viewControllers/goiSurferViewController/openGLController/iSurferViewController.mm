//
//  iSurferViewController.m
//  iSurfer
//
//  Created by Ignacio Liverotti on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "iSurferViewController.h"
#import "EAGLView.h"
#include "Compiler.hpp"
#include "programData.hpp"

#import "TrackBall.h"
#import "Matrix.hpp"
#include "Vector.hpp"

// Uniform index.
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface iSurferViewController ()
@property (nonatomic, retain) EAGLContext *context;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation iSurferViewController

@synthesize animating, context;
@synthesize trackBall, m_applicationEngine;


-(id)init{
		if (self = [super init]){
		//	pool = [[NSAutoreleasePool alloc]init];

		
		}
		return self;
	
	
}

-(void)setupGLContxt{
	EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
	if (!aContext)
	{
		aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	}
	
	if (!aContext)
		NSLog(@"Failed to create ES context");
	else if (![EAGLContext setCurrentContext:aContext])
		NSLog(@"Failed to set ES context current");
	
	self.context = aContext;
	[aContext release];
	
	[(EAGLView *)self.view setContext:context];
	[(EAGLView *)self.view setFramebuffer];
	
	//if ([context API] == kEAGLRenderingAPIOpenGLES2)
	//	[self loadShaders];
	glClearColor( 1.0, 1.0, 1.0, 1.0 );

	animating = FALSE;
	displayLinkSupported = FALSE;
	animationFrameInterval = 2;
	displayLink = nil;
	animationTimer = nil;
	
	// Use of CADisplayLink requires iOS version 3.1 or greater.
	// The NSTimer object is used as fallback when it isn't available.
	
	
}

- (void)awakeFromNib
{
	/*
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!aContext)
    {
        aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    }
    
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    
	self.context = aContext;
	[aContext release];
	
    [(EAGLView *)self.view setContext:context];
    [(EAGLView *)self.view setFramebuffer];
    
    if ([context API] == kEAGLRenderingAPIOpenGLES2)
        [self loadShaders];
    
    animating = FALSE;
    displayLinkSupported = FALSE;
    animationFrameInterval = 1;
    displayLink = nil;
    animationTimer = nil;
    
    // Use of CADisplayLink requires iOS version 3.1 or greater.
	// The NSTimer object is used as fallback when it isn't available.
    NSString *reqSysVer = @"3.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        displayLinkSupported = TRUE;
	 */
}

- (void)dealloc
{
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }
    
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [context release];
 //   [pool release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }

    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	self.context = nil;	
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;
        
        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
			//	animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawFrame) userInfo:nil repeats:TRUE];
        
        animating = TRUE;
    }
	
	NSString *vs1 = [[NSBundle mainBundle] pathForResource:@"vs1" ofType:@"glsl"];
	NSString *fs1 = [[NSBundle mainBundle] pathForResource:@"fs1" ofType:@"glsl"];
	NSString *vs2 = [[NSBundle mainBundle] pathForResource:@"vs2" ofType:@"glsl"];
	NSString *fs2 = [[NSBundle mainBundle] pathForResource:@"fs2" ofType:@"glsl"];
	
    
    //NSString *formula =@"(z^3-2)^2+(x^2+y^2-3)^3";
    //NSString *formula =@"(z^3-2)^2";
     
    
    //NSString *formula = @"x^2*-y^2+z^2"; //Bien

    
    //GRADO 1
        //NSString *formula = @"x"; //Bien

    
    //Grado 2
        
        //NSString *formula = @"y*x";  //Bien

    
    
   // NSString *formula = @"-----x--1--y";  //Bien
    //NSString *formula = @"--x^2+-------y*x*x";  //Bien
   // NSString *formula = @"x^2-y*x*x";  //Bien
    
    NSString *formula = @"x^2+y^2+z^2+2*x*y*z-1"; //Bien
    //NSString *formula = @"x^2+y^2+z^2-1";  //Bien
    
    
        //Cylinder
            //NSString *formula = @"x^2+y^2-5";  //Bien
        //Dattel (Esfera)
            //NSString *formula = @"x^2+y^2+z^2-1";  //Bien
        //Pipe
            //NSString *formula = @"x^2-z";  //Bien
        //Gupf
            //NSString *formula = @"x^2+y^2+z";  //Bien    
        //Kegel
            //NSString *formula = @"x^2+y^2-z^2";//Bien  
        //Spindel
            //NSString *formula = @"x^2+y^2-z^2-1"; //Bien
        //Ufo
            //NSString *formula = @"z^2-x^2-y^2-10";  //Bien


        //Gupf
            //NSString *formula = @"x^2+y^2+z"; //Bien 
    
    
    

            //NSString *formula = @"x^2+y^2+z*x+y"; //Bien
    

    
    //Grado 3
    
        
    //Kegel
        //NSString *formula = @"x^2+y^2+z^3-20";//Bien 
    
            //NSString *formula = @"x^2+y^2+z^3-1";//Bien 
        //Kreuz
            //NSString *formula = @"x*y*z";  //mal 100%
        //Calypso 
           // NSString *formula = @"x^2+y^2*z-z^2"; // Mal
        //Cayley Cubic
            //NSString *formula = @"x^2+y^2+z^2+2*x*y*z-1"; //Bien
        //Este se ve raro
            //NSString *formula = @"x^2-x-x^2*y-y*z^2-z^2"; //Bien

    
        //DingDong
            //NSString *formula = @"x^2+y^2+z^3-z^2"; //Maso.
        //Fanfare 
            //NSString *formula = @"z^2+y^2-x^3"; //Bien
        //Sattel
            //NSString *formula = @"x^2+y^2*z+z^3"; // Mal
    
    
        //Whitney
            //NSString *formula = @"x^2-y^2*z"; // Mal 30%
    
    //Grado 4
    
    //NSString *formula = @"x^4+y^4+z^4-1";// Bien

      
   // NSString *formula = @"x^6-y^4-z*y";// Bien
    
            //NSString *formula = @"x^4-2";// Bien

        //Pellet
            //NSString *formula = @"x^2+y^2+z^4-20"; //Bien
        //cosa rara
            //NSString *formula =@"x^2+y^2+z^4-20*x^2-y^3"; //Bien

    
        //Zeck
            //NSString *formula =@"20*(z^2+y^2)-20*x^3+x^4"; // Bien
         
        //Helix
            //NSString *formula =@"6*x^2-2*x^4-y^2*z^2"; //bien
    
        //DromeBar
            //NSString *formula =@"x^4-3*x^2+y^2+z^3";// rara pero bien en forma. la corta la esfera
        
        //Xano
            //NSString *formula =@"x^4+z^3-y*z^2"; //MAL


    //Grado 5
    //Calyx
    //NSString *formula = @"x^2+y^2*z^3-z^4"; //Maso

        //NSString *formula = @"x^2+y^2*z^3";// mal
    //NSString *formula = @"x^2+y^2*z^3";// mal

    
    //Grado 6
        //Cube
            //NSString *formula = @"x^6+y^6+z^6-19";  //Bien
        //citrus 
            //NSString *formula = @"x^2+z^2-(!y)^3*(y-1)^3";
            //NSString *formula = @"x^2+z^2-((0-1)*y)^3*(y-1)^3"; //Bien
        //Twilight
            //NSString *formula =@"(z^3-2)^2+(x^2+y^2-3)^3"; //Bien

            //NSString *formula = @"x^2-y^3*z^3"; //Mal

    
    
   //iSurferDelegate::init([vs1 UTF8String],[fs1 UTF8String],[vs2 UTF8String],[fs2 UTF8String],[formula UTF8String]);
	
    m_renderingEngine = SolidES2::CreateRenderingEngine();
    
    m_applicationEngine = ParametricViewer::CreateApplicationEngine(m_renderingEngine);
    int width = 240;//CGRectGetWidth(frame);
    int height = 240;//CGRectGetHeight(frame);
    m_applicationEngine->Initialize(width, height);
    
    //m_applicationEngine->ChangeSurface(1);
    
    
	Compiler::init([vs1 UTF8String],[fs1 UTF8String],[vs2 UTF8String],[fs2 UTF8String],[formula UTF8String]);
    
    programData::InitializeProgramData();
    
    
	[self drawFrame];

}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }
        
        animating = FALSE;
    }
}

- (void)drawFrame
{
    [(EAGLView *)self.view setFramebuffer];

    @synchronized(self)
    {
            glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
            m_applicationEngine->Render();
        NSLog(@"finished drawing");
        [(EAGLView *)self.view presentFramebuffer];
        
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(program, ATTRIB_COLOR, "color");
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(program, "translate");
    
    // Release vertex and fragment shaders.
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return TRUE;
}
float rotAtenuation = 100.0f;

ivec2 oldLocation;
-(void)rotateX:(float)x Y:(float)y{
    m_applicationEngine->OnFingerMove(oldLocation, ivec2(x, y));
    oldLocation= ivec2(x, y);

    if( programData::rotationX >=2 * M_PI || programData::rotationX <= -2 * M_PI) 
        programData::rotationX = 0;
    else
        programData::rotationX =  programData::rotationX + (y * M_PI / 180.0f / rotAtenuation);
    
    if( programData::rotationY  > 2 * M_PI  || programData::rotationY  <  -2 * M_PI)
        programData::rotationY  = 0;
    else
        programData::rotationY =  programData::rotationY +  (x * M_PI /180.0f /rotAtenuation);
    if(x != 0 && y != 0)
    {
        if( programData::rotationZ  > 2 * M_PI  || programData::rotationZ  <  -2 * M_PI)
        {
            programData::rotationZ  = 0;
        }
        else
            programData::rotationZ =  programData::rotationZ +  (x * M_PI /180.0f / rotAtenuation + y * M_PI /180 /rotAtenuation);
    }
    CGPoint location;
    location.x = x;
    location.y = y;
    
    CATransform3D transform = [trackBall rotationTransformForLocation:location];
    vec4 xvec,yvec,z,w;
    xvec = vec4(transform.m11, transform.m12, transform.m13, transform.m41);
    yvec = vec4(transform.m21, transform.m22, transform.m23, transform.m42);
    z = vec4(transform.m31, transform.m32, transform.m33, transform.m43);
    w = vec4(transform.m14, transform.m24, transform.m34, transform.m44);
    programData::rot = mat4::fromCATransform3D(xvec, yvec, z, w);
    
    
    /*
    printf("loation %f %f" , location.x, location.y);

    
    printf("transform\n");
    
    printf("  %f  %f   %f  %f \n", transform.m11 , transform.m12, transform.m13, transform.m14);
    printf("  %f  %f   %f  %f \n", transform.m21 , transform.m22, transform.m23, transform.m24);
    printf("  %f  %f   %f  %f \n", transform.m31 , transform.m32, transform.m33, transform.m34);
    printf("  %f  %f   %f  %f \n", transform.m41 , transform.m42, transform.m43, transform.m44);

    
    printf("rotation\n");
    for (int i = 0; i<4; i++) {
        for (int j=0; j<4; j++) {
            printf("  %f", programData::rot.Pointer()[i*4+j]);
        }
        printf("\n");
        
    }

    */
	//NSLog(@"x: %.2f    y:%.2f", x , y );
     
    //NSLog(@"calc x: %.2f  calcy: %.2f", x * M_PI / 180, y * M_PI / 180 );

	[self drawFrame];

}
-(void)initRotation:(NSMutableDictionary*)dic{
    float x = [[dic valueForKey:@"x"]floatValue ];
    float y = [[dic valueForKey:@"y"]floatValue ];
    
    oldLocation = ivec2(x, y);
    m_applicationEngine->OnFingerDown(oldLocation);
    
    CGPoint location;
    location.x = x;
    location.y = y;
    
    
    if(nil == self.trackBall) {
        CGRect bounds = CGRectMake(110, 24, 364, 245	);
        
        self.trackBall = [TrackBall trackBallWithLocation:location inRect:bounds];
    } else {
        [self.trackBall setStartPointFromLocation:location];
    }
    
    
	NSLog(@"rotation start at x: %.2f    y:%.2f", x , y );
    
	[self drawFrame];

}



-(void)initRotationX:(float)x Y:(float)y{
    
      
    oldLocation = ivec2(x, y);
    m_applicationEngine->OnFingerDown(oldLocation);
    
    CGPoint location;
    location.x = x;
    location.y = y;

    
    if(nil == self.trackBall) {
        CGRect bounds = CGRectMake(110, 24, 364, 245	);
 
        self.trackBall = [TrackBall trackBallWithLocation:location inRect:bounds];
    } else {
        [self.trackBall setStartPointFromLocation:location];
    }

    
	NSLog(@"rotation start at x: %.2f    y:%.2f", x , y );
    
	[self drawFrame];
    
    NSLog(@"rotation ends");
     
}


-(void)endRotationX:(float)x Y:(float)y{
    oldLocation = ivec2(x, y);
    m_applicationEngine->OnFingerDown(oldLocation);
    
    CGPoint location;
    location.x = x;
    location.y = y;
    
    [self.trackBall finalizeTrackBallForLocation:location];

    
	NSLog(@"rotation start at x: %.2f    y:%.2f", x , y );
    
	[self drawFrame];
}

-(void)setZoom:(double)zoomvalue{
    @synchronized(self)
    {
	//iSurferDelegate::radius = zoomvalue;
    programData::UpdateRadius(zoomvalue);
    m_applicationEngine->Zoom(zoomvalue);
    
    [self drawFrame];
    }
}

-(void)generateSurface:(NSString*)eq{
	NSString *vs1 = [[NSBundle mainBundle] pathForResource:@"vs1" ofType:@"glsl"];
	NSString *fs1 = [[NSBundle mainBundle] pathForResource:@"fs1" ofType:@"glsl"];
	NSString *vs2 = [[NSBundle mainBundle] pathForResource:@"vs2" ofType:@"glsl"];
	NSString *fs2 = [[NSBundle mainBundle] pathForResource:@"fs2" ofType:@"glsl"];
	//NSString *formula = @"x^2+y^2+z*x+y";
	//iSurferDelegate::init([vs1 UTF8String],[fs1 UTF8String],[vs2 UTF8String],[fs2 UTF8String],[eq UTF8String]);
    //NSString * str = [eq stringByReplacingOccurrencesOfString: @"-" withString:@"!"];
    //str = [str stringByReplacingOccurrencesOfString: @"\u2212" withString:@"-"];

    Compiler::init([vs1 UTF8String],[fs1 UTF8String],[vs2 UTF8String],[fs2 UTF8String],[eq UTF8String]);

    programData::InitializeProgramData();

	[self drawFrame];
	
}

-(float)zoom{
	return programData::radius;
}

-(void)setSurfaceColorRed:(float)red Green:(float)green Blue:(float)blue{
	NSLog(@"red: %f green: %f  blue: %f", red, green, blue);
    
	programData::UpdateColor(red, green, blue);
	[self drawFrame];
}

-(void)setSurfaceColor2Red:(float)red Green:(float)green Blue:(float)blue{
	NSLog(@"red: %f green: %f  blue: %f", red, green, blue);
    
	programData::UpdateColor2(red, green, blue);
	[self drawFrame];
}


-(UIImage *) drawableToCGImage {
	CGRect myRect = CGRectMake(0, 0, 300, 200	);
	NSInteger myDataLength = myRect.size.width * myRect.size.height * 4;
	void *buffer = (GLubyte *) malloc(myDataLength);
	
	glFinish();
	glPixelStorei(GL_PACK_ALIGNMENT, 4);
	
	glReadPixels(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height, GL_RGB, GL_UNSIGNED_INT, buffer);
	
	NSData* myImageData = [NSData dataWithBytesNoCopy:(unsigned char const **)&buffer length:myDataLength freeWhenDone:NO];
	
	UIImage *myImage = [UIImage imageWithData:myImageData];
	if( myImage != nil) { NSLog(@"Save EAGLImage failed to bind data to a IUImage"); }
	//	free(myGLData); not needed - NSData:dataWithBytesNoCopy: The returned object takes ownership of the bytes pointer and frees it on deallocation. Therefore, bytes must point to a memory block allocated with malloc.
	
	return myImage;
}

@end