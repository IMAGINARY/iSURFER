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

#import "iSurferDelegate.h"

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
	
	if ([context API] == kEAGLRenderingAPIOpenGLES2)
		[self loadShaders];
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
	//NSString *formula = @"x^2+y^2+z*x+y";
    //NSString *formula = @"x^2+y^2+z^2-19";
    NSString *formula = @"x^2-x-x^2*y-y*z^2-z^2";
   // NSString *formula = @"x^2+y^2*z-z^2";
   
    //Grado 3
    //NSString *formula = @"x^2-y^3*z^3";
    //NSString *formula = @"x^2+y^2*z^3";
    //NSString *formula = @"x^2+y^2+z^3-z^2";
    
   iSurferDelegate::init([vs1 UTF8String],[fs1 UTF8String],[vs2 UTF8String],[fs2 UTF8String],[formula UTF8String]);
	
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
/*
    // Replace the implementation of this method to do your own custom drawing.
    static const GLfloat squareVertices[] = {
        -0.5f, -0.33f,
        0.5f, -0.33f,
        -0.5f,  0.33f,
        0.5f,  0.33f,
    };
    
    static const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };
    
    static float transY = 0.0f;
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    if ([context API] == kEAGLRenderingAPIOpenGLES2)
    {
        // Use shader program.
        glUseProgram(program);
        
        // Update uniform value.
        glUniform1f(uniforms[UNIFORM_TRANSLATE], (GLfloat)transY);
        transY += 0.075f;	
        
        // Update attribute values.
        glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
        glEnableVertexAttribArray(ATTRIB_VERTEX);
        glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, 1, 0, squareColors);
        glEnableVertexAttribArray(ATTRIB_COLOR);
        
        // Validate program before drawing. This is a good check, but only really necessary in a debug build.
        // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
        if (![self validateProgram:program])
        {
            NSLog(@"Failed to validate program: %d", program);
            return;
        }
#endif
    }
    else
    {
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
        transY += 0.075f;
        
        glVertexPointer(2, GL_FLOAT, 0, squareVertices);
        glEnableClientState(GL_VERTEX_ARRAY);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
        glEnableClientState(GL_COLOR_ARRAY);
    }
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
*/
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f); 	

	iSurferDelegate::display();
    [(EAGLView *)self.view presentFramebuffer];
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

-(void)rotateX:(float)x Y:(float)y{
    if( iSurferDelegate::rotationX >2 * M_PI || iSurferDelegate::rotationX < -2 * M_PI) 
        iSurferDelegate::rotationX = 0;
    else
        iSurferDelegate::rotationX =  iSurferDelegate::rotationX + (y * M_PI / 180 / 5.0);
    if( iSurferDelegate::rotationY  > 2 * M_PI  || iSurferDelegate::rotationY  <  -2 * M_PI)
        iSurferDelegate::rotationY  = 0;
    else
        iSurferDelegate::rotationY =  iSurferDelegate::rotationY +  (x * M_PI /180 /5.0);
	NSLog(@"x: %.2f    y:%.2f", iSurferDelegate::rotationX , iSurferDelegate::rotationY );
    //NSLog(@"calc x: %.2f  calcy: %.2f", x * M_PI / 180, y * M_PI / 180 );

	[self drawFrame];

}


-(void)setZoom:(double)zoomvalue{
	iSurferDelegate::radius = zoomvalue;
	[self drawFrame];
}

-(void)generateSurface:(NSString*)eq{
	NSString *vs1 = [[NSBundle mainBundle] pathForResource:@"vs1" ofType:@"glsl"];
	NSString *fs1 = [[NSBundle mainBundle] pathForResource:@"fs1" ofType:@"glsl"];
	NSString *vs2 = [[NSBundle mainBundle] pathForResource:@"vs2" ofType:@"glsl"];
	NSString *fs2 = [[NSBundle mainBundle] pathForResource:@"fs2" ofType:@"glsl"];
	//NSString *formula = @"x^2+y^2+z*x+y";
	iSurferDelegate::init([vs1 UTF8String],[fs1 UTF8String],[vs2 UTF8String],[fs2 UTF8String],[eq UTF8String]);
	
	[self drawFrame];
	
}

-(float)zoom{
	return iSurferDelegate::radius;
}

-(void)setSurfaceColorRed:(float)red Green:(float)green Blue:(float)blue{
	NSLog(@"red: %f green: %f  blue: %f", red, green, blue);
	iSurferDelegate::colorR = red;
	iSurferDelegate::colorG = green;
	iSurferDelegate::colorB = blue;

	[self drawFrame];
}

-(UIImage *) drawableToCGImage {
	CGRect myRect = CGRectMake(0, 0, 300, 200	);
	NSInteger myDataLength = myRect.size.width * myRect.size.height * 4;
	void *buffer = (GLubyte *) malloc(myDataLength);
	
	glFinish();
	glPixelStorei(GL_PACK_ALIGNMENT, 4);
	
	glReadPixels(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height, GL_RGB, GL_UNSIGNED_BYTE, buffer);
	
	NSData* myImageData = [NSData dataWithBytesNoCopy:(unsigned char const **)&buffer length:myDataLength freeWhenDone:NO];
	
	UIImage *myImage = [UIImage imageWithData:myImageData];
	if( myImage != nil) { NSLog(@"Save EAGLImage failed to bind data to a IUImage"); }
	//	free(myGLData); not needed - NSData:dataWithBytesNoCopy: The returned object takes ownership of the bytes pointer and frees it on deallocation. Therefore, bytes must point to a memory block allocated with malloc.
	
	return myImage;
}

@end
