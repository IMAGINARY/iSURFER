#define EXAMPLE 1

#if EXAMPLE == 1
// polynomial of degree 2
#define DEGREE 2
#define SIZE 3
#define EPSILON 0.0001

struct polynomial { highp float a[ SIZE ]; };

polynomial create_poly_0( highp float a0 );
polynomial create_poly_1( highp float a0, highp float a1 );
polynomial add( polynomial p1, polynomial p2, int res_degree );
polynomial sub( polynomial p1, polynomial p2, int res_degree );
polynomial mult( polynomial p1, polynomial p2, int res_degree );
polynomial neg( polynomial p, int res_degree );
polynomial power( polynomial p, int exp, int degree );
polynomial power_1( polynomial p, int exp );
highp float power( highp float base, int exp );

polynomial calc_coefficients( in highp vec3 eye, in highp vec3 dir, in highp vec2 trace_interval )
{
	polynomial x = create_poly_1( eye.x, dir.x );
	polynomial y = create_poly_1( eye.y, dir.y );
	polynomial z = create_poly_1( eye.z, dir.z );
	
	return  ;
	
	//return sub( add( add( power( x, 2, 2 ), power( y, 2, 2 ), 2 ), power( z, 2, 2 ), 2 ), create_poly_0( 0.5 ), 2 );
	}

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
#endif
#if EXAMPLE == 2
// polynomial of degree 3
#define DEGREE 3
#define SIZE 4
#define EPSILON 0.0001

struct polynomial { highp float a[ SIZE ]; };

polynomial create_poly_0( highp float a0 );
polynomial create_poly_1( highp float a0, highp float a1 );
polynomial add( polynomial p1, polynomial p2, int res_degree );
polynomial sub( polynomial p1, polynomial p2, int res_degree );
polynomial mult( polynomial p1, polynomial p2, int res_degree );
polynomial neg( polynomial p, int res_degree );
polynomial power( polynomial p, int exp, int degree );
polynomial power_1( polynomial p, int exp );
highp float power( highp float base, int exp );
polynomial calc_coefficients( in highp vec3 eye, in highp vec3 dir, in highp vec2 trace_interval )
{
	polynomial x = create_poly_1( eye.x, dir.x );
	polynomial y = create_poly_1( eye.y, dir.y );
	polynomial z = create_poly_1( eye.z, dir.z );

	return sub( add( sub( power( x, 3, 1 ), power( y, 2, 1 ), 2 ), power( z, 2, 1 ), 3 ), create_poly_0( 0.0 ), 3 );
}

highp vec3 mygradient( in highp vec3 point )
{
	highp float x = point.x;
	highp float y = point.y;
	highp float z = point.z;

	highp vec3 res;
	res.x = 3.0*x*x;
	res.y = -2.0*y;
	res.z = 2.0*z;

	return res;
}
#endif
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
		/* works with this line: */ // p1.a[ i ] = -( p2.a[ i ] - p1.a[ i ] );
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

polynomial power_1( polynomial p, int exp )
{
//	return power( p, exp, 1 );

	// compute powers of p.a[ 0 ] and p.a[ 1 ]
	highp float a0 = p.a[ 0 ];
	highp float a1 = p.a[ 1 ];
	highp float powers_0[ SIZE ];
	highp float powers_1[ SIZE ];
	powers_0[ 0 ] = 1.0;
	powers_0[ 1 ] = a0;
	powers_1[ 0 ] = 1.0;
	powers_1[ 1 ] = a1;
	for( int i = 2; i <= exp; i++ )
	{
		powers_0[ i ] = powers_0[ i - 1 ] * a0;
		powers_1[ i ] = powers_1[ i - 1 ] * a1;
	}
	
	// compute coefficients of polynomials by binomial expansion
	polynomial res = create_poly_0( 0.0 );
	int a1_exp = exp;
	int a0_exp = 0;
	int bin_coeff = 1;
	for( int deg = exp; deg >= 0; deg-- )
	{
		res.a[ deg ] = float( bin_coeff ) * powers_1[ a1_exp ] * powers_0[ a0_exp ];
		a0_exp++;
		bin_coeff = ( bin_coeff * a1_exp ) / a0_exp;
		a1_exp--;
	}
	return res;
}

// Ersatz für fehlerhafte NVidia-pow-Funktion ...
highp float power( highp float base, int exp )
{
	highp float res = 1.0;
	for( int i = 0; i < exp; i++ )
		res *= base;
	return res;
}

// ===================================================

highp float eval_p( const in polynomial p, highp float x )
{
	highp float fx = p.a[ SIZE - 1 ];
	for( int i = SIZE - 2; i >= 0; i-- )
		fx = fx * x + p.a[ i ];
	return fx;
}

highp float bisect( const in polynomial p, highp float epsilon, highp float lowerBound, highp float upperBound )
{
	highp float center = lowerBound;
	highp float old_center = upperBound;
	highp float fl = eval_p( p, lowerBound );
	highp float fu = eval_p( p, upperBound );

	while( abs( upperBound - lowerBound ) > epsilon )
	{
		old_center = center;
		center = 0.5 * ( lowerBound + upperBound );
		highp float fc = eval_p( p, center );
		
		if( fc * fl < 0.0 )
		{
			upperBound = center;
			fu = fc;
		}
		else if( fc == 0.0 )
		{
			break;
		}
		else
		{
			lowerBound = center;
			fl = fc;
		}
	}
	return ( upperBound + lowerBound ) * 0.5;
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

void shiftStretch( const in polynomial p, highp float shift, highp float scale, out polynomial result )
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
}

highp float first_root_in__descartes( const in polynomial p, highp float epsilon, inout polynomial tmpCoeffs )
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
			// go right
			while( ( id / 2 ) * 2 != id )
			{
				id /= 2;
				size *= 2.0;
			}
			id++;
		}
		else if( sign_changes >= 1 ) // will also be called, if sign_changes > 1, but size <= epsilon
		{
			// root isolated -> refine
			result = bisect( p, size * float( id ), size * float( id + 1 ), epsilon );
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

highp float first_root_in( in polynomial p, highp float min, highp float max )
{
	if( DEGREE == 1 )
	{
		highp float x0 = -p.a[ 0 ] / p.a[ 1 ];
		if( x0 >= min && x0 < max )
			return x0;
		else
			discard;
	}
	else if( DEGREE == 2 )
	{
		highp float a = p.a[ 2 ];
		highp float b = p.a[ 1 ];
		highp float c = p.a[ 0 ];

		//Find discriminant
		highp float disc = b * b - 4.0 * a * c;

		// if discriminant is negative there are no real roots, so return 
		// false as ray misses sphere
		if (disc < 0.0)
			discard;

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

		if( x0 >= min && x0 < max )
			return x0;
		else if( x1 >= min && x1 < max )
			return x1;
		else
			discard;
	}
	else if( DEGREE > 1 )
	{
		// move roots from [min,max] to [0,1]
		polynomial p01;
		shiftStretch( p, min, max - min, p01 );
		
		// find smallest root in [0,1], if any
		highp float x0 = first_root_in__descartes( p01, EPSILON * ( max - min ), p );
		if( x0 >= 0.0 )
			return (max-min)*x0+min; // move root back to original interval
		else
			discard; // no root in [0,1]
	}
	else
	{
		// error!!
		discard;
	}
}

varying highp vec3 varying_eye;
varying highp vec3 varying_dir;

void clip_to_unit_sphere( in highp vec3 eye, in highp vec3 dir, out highp float tmin, out highp float tmax )
{
	highp float r = 1.0;
	//Compute A, B and C coefficients
	highp float a = dot(dir, dir);
	highp float b = 2.0 * dot(dir, eye);
	highp float c = dot(eye, eye) - (r * r);

	//Find discriminant
	highp float disc = b * b - 4.0 * a * c;

	// if discriminant is negative there are no real roots, so return 
	// false as ray misses sphere
	if (disc < 0.0)
		discard;

	// compute q as described above
	highp float distSqrt = sqrt(disc);
	highp float q;
	if (b < 0.0)
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

/**
 * main method, that guides the overall process
 */
void main( void )
{
	// setup ray(s)
	highp float tmin, tmax;
	clip_to_unit_sphere( varying_eye, varying_dir, tmin, tmax );
	highp float tcenter = ( tmin + tmax ) * 0.5;
	highp vec3 eye = varying_eye + tcenter * varying_dir;
	highp vec3 dir = varying_dir;
	tmin = tmin - tcenter;
	tmax = tmax - tcenter;

	// setup polynomial
	polynomial p_ray = calc_coefficients( eye, dir, vec2( tmin, tmax ) );

	// find intersection of ray and surface
	highp float root = first_root_in( p_ray, tmin, tmax );

	highp vec3 hit_point = eye + root * dir;

	gl_FragColor = vec4( normalize( mygradient( hit_point ) ), 0.5 );
//	gl_FragColor = vec4( clamp( dir, 0.0, 1.0 ), 0.5 );
}