/**
 * File: fs1.glsl
 * Version: 1.0
 * @module OpenGL
 */

/** 
 *Last modified on January 13 2013 by dazar
 * -----------------------------------------------------
 * This is the fragment Shader. It is in charge of all the calculations to render an algebraic surface.
 * This Shader is not complete, it must be filled with the degree, equation and partial derivatives of the surface.
 * It use an adaptation of a Ray Tracer to generate the image from the surface roots.
 * It is based on the Surfer made by Christian Stussak and adapted by Daniel Azar and Cristian Prieto for the iPhone gpu.
 * Some bug fix made also by Christian Stussak.
 * @class Fragment_Shader
 */


#define DEGREE 
#define EPSILON 0.00001
#define DELTA 0.0000001
#define SIZE DEGREE+1 

uniform highp vec3 DiffuseMaterial;
uniform highp vec3 DiffuseMaterial2;

uniform highp float CELLSHADE;
uniform highp float TEXTURE;

uniform highp vec3 LightPosition;
uniform highp vec3 LightPosition2;
uniform highp vec3 LightPosition3;
uniform highp vec3 AmbientMaterial;
uniform highp vec3 AmbientMaterial2;
uniform highp vec3 SpecularMaterial;
uniform highp vec3 SpecularMaterial2;
uniform highp float Shininess;
uniform highp float radius2;
uniform highp vec4 eye;

varying mediump vec2 TextureCoordOut;

uniform sampler2D Sampler;


struct polynomial { highp float a[ DEGREE + 1 ]; };


polynomial create_poly_0( highp float a0 );
polynomial create_poly_1( highp float a0, highp float a1 );
polynomial add( polynomial p1, polynomial p2, int res_degree );
polynomial sub( polynomial p1, polynomial p2, int res_degree );
polynomial mult( polynomial p1, polynomial p2, int res_degree );
polynomial neg( polynomial p, int res_degree );
polynomial power( polynomial p, int exp, int degree );


polynomial calc_coefficients( in highp vec3 eye, in highp vec3 dir)
{
	polynomial x = create_poly_1( eye.x, dir.x );
	polynomial y = create_poly_1( eye.y, dir.y );
	polynomial z = create_poly_1( eye.z, dir.z );
	
	return  ;
	
	//return sub( add( add( power( x, 2, 2 ), power( y, 2, 2 ), 2 ), power( z, 2, 2 ), 2 ), create_poly_0( 0.5 ), 2 );
}

/**
 * Usage: polynomial p; p = create_poly_0(3.0); 
 * --------------------------------------
 * This function creates a new polynomial of degree DEGREE with an unique constant value.
 * @method create_poly_0
 * @param a0 {highp float} float value of independant coeficient.
 * @return {polynomial} a new polynomial.
 */
/**
 * Usage: polynomial p; p = create_poly_1(3.0,2.0); 
 * --------------------------------------
 * This function creates a new polynomial of degree DEGREE with two values linear and independant.
 * Use this method to generate the axis from the eye and dir of the ray. 
 * @method create_poly_1
 * @param a0 {highp float} float value of independant coeficient.
 * @param a1 {highp float} float value of linear coeficient.
 * @return {polynomial} a new polynomial.
 */
/**
 * Usage: polynomial p; p = add(p1,p2,5); 
 * --------------------------------------
 * This function creates a new polynomial of degree res_degree with the addition of p1 and p2.
 * It needs the degree of the result to optimize the function. 
 * @method add
 * @param p1 {polynomial} First poly.
 * @param p2 {polynomial} Second polly.
 * @param res_degree {int} degree of the resultant polynomial.
 * @return {polynomial} a new polynomial.
 */
/**
 * Usage: polynomial p; p = sub(p1,p2,5); 
 * --------------------------------------
 * This function creates a new polynomial of degree res_degree with the Substraction of p2 to p1.
 * It needs the degree of the result to optimize the function. 
 * @method sub
 * @param p1 {polynomial} First poly.
 * @param p2 {polynomial} Second polly.
 * @param res_degree {int} degree of the resultant polynomial.
 * @return {polynomial} a new polynomial.
 */
/**
 * Usage: polynomial p; p = mult(p1,p2,5); 
 * --------------------------------------
 * This function creates a new polynomial of degree res_degree with the multiplication of p1 and p2.
 * It needs the degree of the result to optimize the function. 
 * @method mult
 * @param p1 {polynomial} First poly.
 * @param p2 {polynomial} Second polly.
 * @param res_degree {int} degree of the resultant polynomial.
 * @return {polynomial} a new polynomial.
 */
/**
 * Usage: polynomial p; p = neg(p1,5); 
 * --------------------------------------
 * This function creates a new polynomial of degree res_degree with the negation of p.
 * It needs the degree of the result to optimize the function. 
 * @method neg
 * @param p1 {polynomial} First poly.
 * @param res_degree {int} degree of the resultant polynomial.
 * @return {polynomial} a new polynomial.
 */
/**
 * Usage: polynomial p; p = power(p1,7,5); 
 * --------------------------------------
 * This function creates a new polynomial of degree res_degree with p elevated to exp.
 * It needs the degree of the result to optimize the function. 
 * @method power
 * @param p {polynomial} First poly.
 * @param exp {int} Exponent.
 * @param res_degree {int} degree of the resultant polynomial.
 * @return {polynomial} a new polynomial.
 */
/**
 * Usage: polynomial p; p = calc_coefficients(eye,dir); 
 * --------------------------------------
 * This function creates a new polynomial of of the algebraic surface.
 * It needs eye and dir to generate the x,y,z axis.
 * This method should be filled with the algebraic surface equation in shader code. 
 * @method calc_coefficients
 * @param eye {highp float} eye of the Ray. Camera coord.
 * @param dir {highp float} direction of the Ray.
 * @return {polynomial} a new polynomial.
 */
polynomial calc_coefficients( in highp vec3 eye, in highp vec3 dir);
/**
 * Usage: Gl_fragColor = mygradient(point); 
 * --------------------------------------
 * Returns a color vector with gradient for the point specified.
 * @method mygradient
 * @param point {highp vec3} point in x,y,z to paint.
 * @return {vec3} color.
 */
highp vec3 mygradient( in highp vec3 point );
/**
 * Usage: s = eval_p(p,3.2); 
 * --------------------------------------
 * This function evaluates the polynomial at the point x.
 * @method eval_p
 * @param p {polynomial} polynomial to evaluate.
 * @param x {highp float} point to evaluate.
 * @return {highp float}.
 */
highp float eval_p( const in polynomial p, highp float x );
/**
 * Usage: s = bisect(p,lower,upper); 
 * --------------------------------------
 * This function uses the bisection method to select the next path for the roots.
 * It uses a while instead of recursion for performance.
 * @method bisect
 * @param p {polynomial} polynomial to evaluate.
 * @param lowerBound {highp float}
 * @param upperBound {highp float}
 * @return {highp float}.
 */
highp float bisect( const in polynomial p, highp float lowerBound, highp float upperBound );
/**
 * Usage: s = has_sign_changes(p); 
 * --------------------------------------
 * This function checks for sign changes in the coefficient array of p. It is used in Descartes algorithm
 * Returns -1 (root at x=0), 0 (no sign change), 1 (one sign change) or 2 (two OR MORE sign changes).
 * @method has_sign_changes
 * @param p {polynomial} polynomial to evaluate.
 * @return {int}.
 */
int has_sign_changes( const in polynomial p );
/**
 * Usage: s = reverseShift1(p,result); 
 * --------------------------------------
 * This function reverts the changes from shiftStrech.
 * @method reverseShift1
 * @param p {polynomial} polynomial to evaluate.
 * @param result {polynomial} polynomial output, this is the return value.
 * @return {void}.
 */
void reverseShift1( const in polynomial p, out polynomial result );
/**
 * Usage: s = shiftStretch(p,shift, scale, poly); 
 * --------------------------------------
 * This function shifts and strech the polynomial. The idea is to focus the roots in the interval (0;1) for precision.
 * Shift is like using p(x-shift) instead of p(x). Strech is like using p(x/scale) instead of p(x). 
 * @method shiftStretch
 * @param p {polynomial} polynomial to modify.
 * @param shift {highp float}
 * @param scale {highp float}
 * @param result {polynomial} polynomial output, this is the return value.
 * @return {polynomial} result is returned.
 */
polynomial shiftStretch( const in polynomial p, highp float shift, highp float scale, out polynomial result );

/**
 * Usage: s = first_root_Descartes(p,epsilon, tmpCoeffs); 
 * --------------------------------------
 * This function shifts and strech the polynomial. The idea is to focus the roots in the interval (0;1) for precision.
 * Shift is like using p(x-shift) instead of p(x). Strech is like using p(x/scale) instead of p(x). 
 * @method first_root_Descartes
 * @param p {polynomial} polynomial to find the roots.
 * @param epsilon {highp float} this should be related to the interval length.
 * @param tmpCoeffs {polynomial} polynomial output / input, is the poly streched and shifted.
 * @return {polynomial} If the return value is >= 0 then it is the first root, else it should be discarded.
 */
highp float first_root_Descartes( const in polynomial p, highp float epsilon, inout polynomial tmpCoeffs );

/**
 * Usage: 	first_root_in( p,min,max ); 
 * --------------------------------------
 * This method is changed on compilation time to the right algorithm for the degree.
 * @param p {polynomial} Polinomial of th surface parametrized on t for the Ray.
 * @param min {highp float} Min value of t.
 * @param max {highp float} Max value of t.
 * @method first_root_in
 * @return {highp float} The nearest root to the camera inside the sphere if any.
 * Discard if there is no root inside the sphere.
 */
highp float first_root_in( inout polynomial p, highp float min, highp float max );
/**
 * Usage: 	clip_to_unit_sphere( varying_eye, dir, tmin, tmax ); 
 * --------------------------------------
 * This method is needed to generate the minimum and maximum value of t in the sphere.
 * We use the Ray Tracer principle of a a ray equation. a ray is a line so Y= m * t+b. 
 * We know b and m, and with this function we get the tmin and tmax for the ray inside the sphere.
 * @param eye {highp float} eye of the Ray. Camera coord.
 * @param dir {highp float} direction of the Ray.
 * @method clip_to_unit_sphere
 * @return tmin and tmax {highp floats} 
 */
void clip_to_unit_sphere( in highp vec3 eye, in highp vec3 dir, out highp float tmin, out highp float tmax );
/**
 * Usage: 	  calc_lights( eye, dir, hit_point); 
 * --------------------------------------
 * This method is needed to get the color of the surface at the hitpoint.
 * The result is written directly to gl_FragColor. 
 * It needs the partial derivatives to be filled, to calculate the Normal of the surface at the hit point.
 * So we can select which color is ok, if it is facing the camera or not.
 * @param eye {highp float} eye of the Ray. Camera coord.
 * @param dir {highp float} direction of the Ray.
 
 * @method clip_to_unit_sphere
 * @return tmin and tmax {highp floats} 
 */

void calc_lights( in highp vec3 eye, in highp vec3 dir , in highp vec3 hit_point);
/**
 * Usage: main(); 
 * --------------------------------------
 * This method guides the overall process. It is called automatically by OpenGL for each pixel. 
 * When a pixel is valid the vertex shader call this method as the entry point to the fragment shader. 
 * @method main
 * @return {void}
 */
void main( void );




highp vec3 mygradient( in highp vec3 point )
{
	highp float x = point.x;
	highp float y = point.y;
	highp float z = point.z;

	highp vec3 res;
	res.x = 2.0*x;
	res.y = -2.0*y;
	res.z = 2.0*z;

	return res;
}
polynomial create_poly_0( highp float a0 )
{
	polynomial res;
	for( int i = 1; i <= DEGREE; i++ )
		res.a[ i ] = 0.0;
	res.a[ 0 ] = a0;
	return res;
}

polynomial create_poly_1( highp float a0, highp float a1 )
{
	polynomial res;
#if DEGREE > 1
	for( int i = 2; i <= DEGREE; i++ )
		res.a[ i ] = 0.0;
#endif
	res.a[ 0 ] = a0;
	res.a[ 1 ] = a1;
	return res;
}

polynomial add( polynomial p1, in polynomial p2, int res_degree )
{
	for( int i = 0; i <= res_degree; i++ )
		p1.a[ i ] += p2.a[ i ];
	return p1;
}

polynomial sub( polynomial p1, in polynomial p2, int res_degree )
{
	for( int i = 0; i <= res_degree; i++ )
        p1.a[ i ] = p1.a[ i ] - p2.a[ i ];
	return p1;
}

polynomial mult( in polynomial p1, in polynomial p2, int res_degree )
{
	polynomial res = p1;
	for( int i = 0; i <= res_degree; i++ )
	{
		res.a[ i ] = 0.0;
		for( int j = 0; j <= i; j++ )
			res.a[ i ] += p1.a[ j ] * p2.a[ i - j ];
	}
	return res;
}

polynomial neg( polynomial p, int res_degree )
{
	for( int i = 0; i <= res_degree; i++ )
		p.a[ i ] = -p.a[ i ];
	return p;
}

polynomial power( in polynomial p, int exp, int degree )
{
	polynomial res = create_poly_0( 1.0 );
	for( int res_degree = degree; res_degree < degree * exp + 1; res_degree += degree )
		res = mult( res, p, res_degree );
	return res;
}

// ===================================================

highp float eval_p( const in polynomial p, highp float x )
{
	highp float fx = p.a[ DEGREE];
	for( int i = DEGREE - 1; i >= 0; i-- )
		fx = fx * x + p.a[ i ];
	return fx;
}

highp float bisect( const in polynomial p, highp float lowerBound, highp float upperBound )
{
    highp float aux = min(lowerBound, upperBound);
    upperBound = max(lowerBound , upperBound);
    lowerBound = aux;
    highp float center = lowerBound;
    highp float old_center = upperBound;
    highp float fl = eval_p( p, lowerBound );
    highp float fu = eval_p( p, upperBound );
    highp float delta = abs( upperBound - lowerBound )/ 2.0;
    highp float fc= 0.0;
    while( delta > EPSILON )
    {
        old_center = center;
        center = delta + lowerBound;
        fc = eval_p( p, center );

        if( fc * fl < 0.0 )
        {
            upperBound = center;
            fu = fc;
        }
        else if( fc == 0.0 )
        {
            return center;
            break;
        }
        else
        {
            lowerBound = center;
            fl = fc;
        }
        
        delta = abs( upperBound - lowerBound ) /2.0; 

    }
    return center;
}

// checks for sign changes in the coefficient array of p
// returns -1 (root at x=0), 0 (no sign change), 1 (one sign change) or 2 (two OR MORE sign changes)
int has_sign_changes( const in polynomial p )
{
    if( p.a[ 0 ] == 0.0 )
        return -1;

    int signChanges = 0;
    highp float lastNonZeroCoeff = p.a[ 0 ];
    for( int i = 1; i < SIZE && signChanges < 2; i++ )
    {
        if( p.a[ i ] != 0.0 )
        {
            if( ( p.a[ i ] > 0.0 && lastNonZeroCoeff < 0.0 ) || ( p.a[ i ] < 0.0 && lastNonZeroCoeff > 0.0 ) )
                signChanges++;
            lastNonZeroCoeff = p.a[ i ];
        }
    }
    return signChanges;
}

void reverseShift1( const in polynomial p, out polynomial result )
{
    for( int i = 0; i < SIZE / 2; i++ ) // in-place reverse (because p and result may be the same arrays)
    {
        highp float tmp = p.a[ i ];
        result.a[ i ] = p.a[ ( SIZE - 1 ) - i ];
        result.a[ ( SIZE - 1 ) - i ] = tmp;
    }
        result.a[ SIZE / 2 ] = p.a[ ( SIZE - 1 ) - SIZE / 2 ];

    for( int j = 0; j < SIZE; j++ )
        for( int i = SIZE - 2; i >= j; i-- )
            result.a[ i ] = result.a[ i ] + result.a[ i + 1 ];
}

polynomial shiftStretch( const in polynomial p, highp float shift, highp float scale, out polynomial result )
{
    for( int i = 0; i < SIZE; i++ )
        result.a[ i ] = p.a[ i ];

    for( int i = 1; i <= SIZE; i++ )
        for( int j = SIZE - 2; j >= i - 1; j-- )
            result.a[ j ] = result.a[ j ] + shift * result.a[ j + 1 ];    

    highp float multiplier = scale;
    for( int i = 1; i < SIZE; i++ )
    {
        result.a[ i ] = multiplier * result.a[ i ];
        multiplier *= scale;
    }
    return result;
}

highp float first_root_Descartes( const in polynomial p, highp float epsilon, inout polynomial tmpCoeffs )
{
	reverseShift1( p, tmpCoeffs );
	int sign_changes = has_sign_changes( tmpCoeffs );
	int id = 0;
	highp float size = 1.0;
	highp float result = -1.0;
	while( true )
	{
		if( sign_changes > 1 && size > epsilon )
		{
			// go deeper on left side
			id *= 2;
			size /= 2.0;
		}
		else if( sign_changes == 0 )
		{
            gl_FragColor = vec4( 0.0, 1.0, 0.0 , 0.5 );

			// go right
			while( ( id / 2 ) * 2 != id )
			{
                gl_FragColor = vec4( 1.0, 0.0, 0.0 , 0.5 );

				id /= 2;
				size *= 2.0;
			}
			id++;
		}
		else if( sign_changes >= 1 ) // will also be called, if sign_changes > 1, but size <= epsilon
		{
			// root isolated -> refine
			result = bisect( p, size * float( id ), size * float( id + 1 ) );

            break;
		}
		else if( sign_changes == -1 )
		{
			result = size * float( id );
			break;
		}
        
		if( size >= 1.0 ) // we would visit the root interval twice -> abort
			break;
        
		shiftStretch( p, size * float( id ), size, tmpCoeffs );
		reverseShift1( tmpCoeffs, tmpCoeffs );
		sign_changes = has_sign_changes( tmpCoeffs );
	}
	return result;
}


highp float first_root_in( inout polynomial p, highp float min, highp float max )
{
    
#if DEGREE >= 3

    // find smallest root in [0,1], if any
    polynomial p01 = p;
    
    p01 = shiftStretch( p, min, max - min, p01 );
    
    highp float x0 = first_root_Descartes( p01, EPSILON * ( max - min ), p );
    
    if( x0 >= 0.0 )
        return (max-min)*x0+min; // move root back to original interval
    else
        discard; // no root in [0,1]
    
#endif
    
#if DEGREE ==1

    highp float x0 = -p.a[ 0 ] / p.a[ 1 ];
    if( x0 >= min && x0 < max )
        return x0;
    else
        discard;
#endif
    
#if DEGREE ==2

    highp float a = p.a[ DEGREE ];
    highp float b = p.a[ 1 ];
    highp float c = p.a[ 0 ];

    //Find discriminant
    highp float disc = b * b - 4.0 * a * c;

    // if discriminant is negative there are no real roots, so return 
    // false as ray misses sphere
    if (disc < 0.0)
    {
        discard;
    }
    // compute q as described above
    highp float distSqrt = sqrt(disc);
    highp float q;
    if (b < 0.0)
        q = (-b - distSqrt)/2.0;
    else
        q = (-b + distSqrt)/2.0;

    // compute tmin and tmax
    highp float x0 = q / a;
    highp float x1 = c / q;

    // make sure tmin is smaller than tmax
    if (x0 > x1)
    {
        highp float temp = x0;
        x0 = x1;
        x1 = temp;
    }

    if( x0 >= min  && x0 < max )
        return x0;
    else if( x1 >= min && x1 < max )
            return x1;
        else
        	discard;

#endif
        //este es el grado 3 Cardano pero tiene Ruido.
#if DEGREE == -10
    highp float PI = 3.14159265358979323846264;
    // Based on JMonkey Engine https://projectsforge.org/projects/bundles/browser/trunk/jogl-2.0-rc3/jogl/src/main/java/jogamp/graph/math/plane/Crossing.java
    highp float res[ 3 ];
    res[0] =100000.0;
    res[1] =100000.0;
    res[2] =100000.0;

    highp float a = p.a[ 2 ] / p.a[ 3 ];
    highp float b = p.a[ 1 ] / p.a[ 3 ];
    highp float c = p.a[ 0 ] / p.a[ 3 ];
    highp int rc = 0;
    
    highp float Q = (a * a - 3.0 * b) / 9.0;
    highp float R = (2.0 * a * a * a - 9.0 * a * b + 27.0 * c) / 54.0;
    highp float Q3 = Q * Q * Q;
    highp float R2 = R * R;
    highp float n = - a / 3.0;
    	
    if (R2 < Q3) {
        highp float t = acos(R / sqrt(Q3)) / 3.0;
        highp float p = 2.0 * PI / 3.0;
        highp float m = -2.0 * sqrt(Q);
        res[0] = m * cos(t) + n;
        res[1] = m * cos(t + p) + n;
        res[2] = m * cos(t - p) + n;
    } else {
        highp float A = pow(abs(R) + sqrt(R2 - Q3), 1.0 / 3.0);
        if (R > 0.0) {
            A = -A;
        }
        if (  A == 0.0) {
            res[rc++] = n;
        } else {
            highp float B = Q / A;
            res[rc++] = A + B + n;
            highp float delta = R2 - Q3;
            if ( delta  == 0.0) {
                res[rc++] = - (A + B) / 2.0 + n;
            }
        }
            	
    }
    highp float aux = res[0];
    if(res[2] < res[1])
    {
        aux = res[2];
        res[2] = res[1];
        res[2] = aux;
    }
    
    if(res[1] < res[0])
    {
        aux = res[1];
        res[1] = res[0];
        res[0] = aux;
    }
    
    if(res[2] < res[1])
    {
        aux = res[2];
        res[2] = res[1];
        res[2] = aux;
    }
    
    
    highp float result = min;
    if( result < res[ 0 ] && res[ 0 ] < max )
        result = res[ 0 ];
    if( result < res[ 1 ] && res[ 1 ] < max )
        result = res[ 1 ];
    if( result < res[ 2 ] && res[ 2 ] < max )
        result = res[ 2 ];
    
    if( min < result && result < max )
        return result;
    else
        discard;

#endif
  
#if DEGREE <=0
discard;
#endif

}


varying highp vec3 varying_eye;
varying highp vec3 varying_dir;

void clip_to_unit_sphere( in highp vec3 eye, in highp vec3 dir, out highp float tmin, out highp float tmax )
{

// http://wiki.cgsociety.org/index.php/Ray_Sphere_Intersection
	//Compute A, B and C coefficients
	highp float a = dot(dir, dir);
	highp float b = 2.0 * dot(dir, eye);
	highp float c = dot(eye, eye) - (radius2);
    highp float D = b * b - c;
    if(D <0.0)
        discard;
   // tmin = -b -sqrt(D);
   // tmax = b + sqrt(D);
   // return;
	//Find discriminant
	highp float disc = b * b - 4.0 * a * c;
    gl_FragColor = vec4( 0.0, 1.0, 1.0 , 0.5 );

    if(disc < 1.0)
        return;
    gl_FragColor = vec4( 0.0, 1.0, 1.0 , 0.5 );
    
	// if discriminant is negative there are no real roots, so return 
	// false as ray misses sphere
	if (disc < DELTA)
		discard;

	// compute q as described above
	highp float distSqrt = sqrt(disc);
	highp float q;
	if (b < DELTA)
		q = (-b - distSqrt)/2.0;
	else
		q = (-b + distSqrt)/2.0;

	// compute tmin and tmax
	tmin = q / a;
	tmax = c / q;

	// make sure tmin is smaller than tmax
	if (tmin > tmax)
	{
		highp float temp = tmax;
		tmax = tmin;
		tmin = temp;
	}
}





void calc_lights10( in highp vec3 eye, in highp vec3 dir , in highp vec3 hit_point)
{
    // We use the hitPoint and numbers, and not the Poly Structure because of speed.
    highp float x = hit_point.x;
    highp float y = hit_point.y;
    highp float z = hit_point.z;
    highp vec3 N;

    
    N = normalize(N);
    
    highp vec3 L = normalize(LightPosition);
    highp vec3 E = vec3(0, 0, 1);
    lowp vec3 color;

            highp vec3 H = normalize(L + E);
            
            highp float sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            highp float df = max(0.0,dot(N, L));
            color = SpecularMaterial;
            color = DiffuseMaterial;
    
            //color +=   sf * SpecularMaterial;
    
    
        gl_FragColor = vec4(color, 1);
    
}






void calc_lights( in highp vec3 eye, in highp vec3 dir , in highp vec3 hit_point)
{
        // We use the hitPoint and numbers, and not the Poly Structure because of speed.
        highp float x = hit_point.x;
        highp float y = hit_point.y;
        highp float z = hit_point.z;
 
    highp vec3 N 
    
        N = normalize(N);

        highp vec3 L = normalize(LightPosition);
        highp vec3 E = dir;
        lowp vec3 color;
if (CELLSHADE ==1.0)
{
    if(dot(N, E) >= DELTA)
    {
        highp vec3 H = normalize(L + E);
        highp float df = max(0.0, dot(N, L)); highp float sf = max(0.0, dot(N, H)); sf = pow(sf, Shininess);
        if (df < 0.1) df = 0.0; else if (df < 0.3) df = 0.3; else if (df < 0.6) df = 0.6; else df = 1.0;
        if (sf < 0.1) sf = 0.0; else if (sf < 0.3) sf = 0.3; else if (sf < 0.6) sf = 0.6; else sf = 1.0;
        color = AmbientMaterial + df * DiffuseMaterial + sf * SpecularMaterial;
        L = normalize(LightPosition2);
        H = normalize(L + E);
        df = max(0.0, dot(N, L));
        sf = max(0.0, dot(N, H)); sf = pow(sf, Shininess);
        if (df < 0.1) df = 0.0;
        else if (df < 0.3) df = 0.3; else if (df < 0.6) df = 0.6; else df = 1.0;
        if (sf < 0.1) sf = 0.0; else if (sf < 0.3) sf = 0.3; else if (sf < 0.6) sf = 0.6; else sf = 1.0;
        color +=   sf * SpecularMaterial +  df * DiffuseMaterial;
        
        
    }else
    {
        E = -E;
        highp vec3 H = normalize(L + E);
        highp float df = max(0.0, dot(N, L)); highp float sf = max(0.0, dot(N, H)); sf = pow(sf, Shininess);
        if (df < 0.1) df = 0.0;
        else if (df < 0.3) df = 0.3; else if (df < 0.6) df = 0.6; else df = 1.0;
        if (sf < 0.1) sf = 0.0; else if (sf < 0.3) sf = 0.3; else if (sf < 0.6) sf = 0.6; else sf = 1.0;
        color = AmbientMaterial2 + df * DiffuseMaterial2 + sf * SpecularMaterial2;
        L = normalize(LightPosition2);
        H = normalize(L + E);
        df = max(0.0, dot(N, L));
        sf = max(0.0, dot(N, H)); sf = pow(sf, Shininess);
        if (df < 0.1) df = 0.0;
        else if (df < 0.3) df = 0.3; else if (df < 0.6) df = 0.6; else df = 1.0;
        if (sf < 0.1) sf = 0.0; else if (sf < 0.3) sf = 0.3; else if (sf < 0.6) sf = 0.6; else sf = 1.0;
        color +=   sf * SpecularMaterial2 +  df * DiffuseMaterial2;
        
        

    }
}
else
{
    if(dot(N, E) >= DELTA)
        {
            highp vec3 H = normalize(L + E);

            highp float sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            highp float df = max(0.0,dot(N, L));
            color = AmbientMaterial +df * DiffuseMaterial;

            color +=   sf * SpecularMaterial;
         
            L = normalize(LightPosition2);
            H = normalize(L + E);
            df = max(0.0, dot(N, L));
            sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            color +=   sf * SpecularMaterial +  df * DiffuseMaterial;
            
    }else
        {
            E = - E;
            highp vec3 H = normalize(L);

            highp float df = max(0.0, dot(N, L));
            highp float sf = max(0.0, dot(N, L));
            highp float aux = Shininess;
            sf = pow(sf, aux);
            color = AmbientMaterial2 + df * DiffuseMaterial2 + sf * SpecularMaterial2;
            L = normalize(LightPosition2);
            H = normalize(L);
            df = max(0.0, dot(N, L));
            sf = max(0.0, dot(N, L));
            sf = pow(sf, Shininess);
            color +=  sf * SpecularMaterial2 + df * DiffuseMaterial2;
            //color = vec3(1.0,0.0,0.0);
            
        }
}
    if (TEXTURE== 1.0) {
        gl_FragColor = texture2D(Sampler, TextureCoordOut) * vec4(color,1);
    }
    else{
        gl_FragColor = vec4(color, 1);
    }

}


uniform highp vec4 origin;



void main( void )
{
	highp float l = length( varying_dir );
    highp vec3 dir = varying_dir;// / l;

	// setup ray(s)
	highp float tmin, tmax, min, max;
	clip_to_unit_sphere( varying_eye, dir, tmin, tmax );
    
	highp float tcenter = ( tmin + tmax ) * 0.5;

    //Con esto ponemos el 0 en el medio del grafico.
	highp vec3 eye = varying_eye + tcenter * dir;
	tmin = tmin - tcenter;
	tmax = tmax - tcenter;

    // setup polynomial
	polynomial p_ray = calc_coefficients( eye, dir);
    highp float scale = tmax-tmin;

	// find intersection of ray and surface
	highp float root = first_root_in( p_ray, tmin, tmax );

    if( root <= tmin || root >= tmax )
        discard;

	highp vec3 hit_point = eye + root * dir;


  calc_lights( eye, dir, hit_point);

}
