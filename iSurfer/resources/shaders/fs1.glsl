
#define DEGREE 
#define EPSILON 0.001
#define DELTA 0.0000001
#define SIZE DEGREE+1 

uniform lowp vec3 Diffuse;

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
//uniform highp vec3 varying_eye;

struct polynomial { highp float a[ DEGREE + 1 ]; };

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
	highp float powers_0[ DEGREE + 1 ];
	highp float powers_1[ DEGREE + 1 ];
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


highp float mypower(highp float base, highp float exp)
{
	int neg = 0;
	highp float ans;
	if(base < 0.0)
	{
		neg = 1;
		base = base * -1.0;
	}
			
	ans = pow(base, exp);

	if(exp == 1.0/3.0)
		ans = ans * -1.0;
	else if(exp == 0.5)
		ans = ans;
	else if(neg == 1  && mod(exp,2.0) != 0.0)
		ans = ans * -1.0;

	return ans;	
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
    //if(abs(fc) > 1.0)
    //    discard;
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
			//result = bisect( p, size * float( id ), size * float( id + 1 ), epsilon );
            //result = bisect_new( p, 0.0, size , epsilon);
            result = bisect( p, 0.0, size);

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
    
#if DEGREE > 3

    // find smallest root in [0,1], if any
    polynomial p01 = p;

    
    highp float x0 = first_root_Descartes( p01, EPSILON * ( max - min ), p );
    
    if( x0 >= 0.0 )
        return (max-min)*x0+min; // move root back to original interval
    else
        discard; // no root in [0,1]
    
#endif
    
#if DEGREE ==1

        highp float x0 = -p.a[ 0 ] / p.a[ 1 ];
//    x0 = (max-min)*x0+min;
    if(x0 < 1.0)
        gl_FragColor = vec4( 1.0, 0.0, 1.0 , 1.0 );
		if( x0 >= min && x0 < max )
			return x0;
		else
			discard;

/**********************************************/

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
            //gl_FragColor = vec4( 1.0, 0.0, 0.0 , 1.0 );
            //return 0.0;
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
        {
            //if( (x0 < min && abs(x0-min) < EPSILON) || (x0 >max && abs(x0-max) < EPSILON ))
            //    return x0;
            //if( (x1 < min && abs(x1-min) < EPSILON) || (x1 >max && abs(x1-max) < EPSILON ))
            //    return x1;

            //gl_FragColor = vec4( 1.0, 1.0, 0.0 , 1.0 );

            //return 0.0;

			discard;
        }

/**********************************************/

#endif
    
#if DEGREE ==3

		highp float a=p.a[DEGREE-1]/-p.a[DEGREE];
		highp float b=p.a[1]/-p.a[DEGREE];
		highp float c=p.a[0]/-p.a[DEGREE];


				
		highp float pe=b-a*a/3.0;

		
		highp float part1qu = 2.0* a*a*a/27.0;
		highp float part2qu = a*b/3.0;
		

		
		highp float qu=part1qu - part2qu + c;
		
		
		highp float disc=qu*qu+4.0*pe*pe*pe/27.0;
		

		if (disc > 0.0 )
		{
		
			highp float u=mypower(((-qu+mypower(disc,0.5))/2.0),1.0/3.0);
			highp float v=mypower(((-qu-mypower(disc,0.5))/2.0),1.0/3.0);
			highp float z0=u+v;
			highp float x0 = z0-a/3.0;
            if(x0 >= min && x0 < max)
            {
                gl_FragColor = vec4( 1.0, 1.0, 0.0 , 1 );
                //Este no sirve hace circulos raros.
                //discard;
                return x0;
            }else
                //gl_FragColor = vec4( 0.5, 0.5, 1 , 1 );
                discard;

		}
		/*else if (disc >= 0.0 - EPSILON && disc <= 0.0 + EPSILON)
		{
			highp float z0=3.0*qu/pe;
			highp float z1=-3.0*qu/(2.0*pe);
			highp float x0 = z0-a/3.0;
			highp float x1 = z1-a/3.0;
				
			if(x0 >=min && x0 < max)
			{
             
				if(x1 >= min && x1 < max && x1 < x0)
					return x1;
				return x0;	
			}
			else if(x1 >=min && x1 < max)
				return x1;
			else
				discard;
		}*/
		else if (disc < 0.0 )
		{
			highp float pi = 3.14159265358979323846264;
			highp float z0 = 2.0*(mypower(-pe/3.0,0.5))*cos((1.0/3.0)*acos((-qu/2.0)*mypower(27.0/(-pe*pe*pe),0.5)));
			highp float z1 = 2.0*(mypower(-pe/3.0,0.5))*cos((1.0/3.0)*acos((-qu/2.0)*mypower(27.0/(-pe*pe*pe),0.5))+2.0*pi/3.0);
			highp float z2 = 2.0*(mypower(-pe/3.0,0.5))*cos((1.0/3.0)*acos((-qu/2.0)*mypower(27.0/(-pe*pe*pe),0.5))+4.0*pi/3.0);
			highp float x0 = z0- a/3.0;
			highp float x1 = z1- a/3.0;
			highp float x2 = z2- a/3.0;
			
			//----Testeo raices----
			
			//if(x0 > 2.9 && x0 < 3.1)
			//	gl_FragColor = vec4( 0.0, 1.0, 0.0 , 0.5 );
			
			//if(x1 > -2.1 && x1 < -1.9)
			//	gl_FragColor = vec4( 0.0, 1.0, 0.0 , 0.5 );
				
			//if(x2 > 0.9 && x2 < 1.1)
			//	gl_FragColor = vec4( 0.0, 1.0, 0.0 , 0.5 );
			
			//----Raices correctas----
	
            highp float xmin = min(x0, min(x1, x2));
            if(xmin >= min && xmin < max)
            {
                gl_FragColor = vec4( 0.0, 1.0, 1.0 , 1 );

                return xmin;
            }
            highp float xmax = max(x0, max(x1,x2));
            highp float xmid; 

            if(xmin == x0 || xmax== x0 )
                if(xmin == x1 || xmax == x1)
                    xmid = x2;
                else
                    xmid = x1;
            else
                xmid = x0;

            if(xmid >= min && xmid < max)
            {
                gl_FragColor = vec4( 1.0, 0.0, 1.0 , 1 );
                return xmid;
            }
            if(xmax >= min && xmax < max)
            {
                gl_FragColor = vec4( 1.0, 0.0, 0.0 , 1 );
                return xmax;
            }
            discard;
		
        }
	
	
/**********************************************/
#endif

#if DEGREE <=0
discard;
#endif

}


varying highp vec3 varying_eye;
varying highp vec3 varying_dir;
/*
void clip_to_unit_sphere( in highp vec3 eye, in highp vec3 dir, out highp float tmin, out highp float tmax )
{
    tmin = -radius2;
    tmax = radius2;
}
*/

void clip_to_unit_sphere( in highp vec3 eye, in highp vec3 dir, out highp float tmin, out highp float tmax )
{

// http://wiki.cgsociety.org/index.php/Ray_Sphere_Intersection
	//Compute A, B and C coefficients
	highp float a = dot(dir, dir);
	highp float b = 2.0 * dot(dir, eye);
	highp float c = dot(eye, eye) - (radius2);

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


void calc_lights( in highp vec3 eye, in highp vec3 dir , in highp vec3 hit_point)
{

        highp float x = hit_point.x;
        highp float y = hit_point.y;
        highp float z = hit_point.z;
        //highp float tmin, tmax;

    //polynomial x = create_poly_1( eye.x, dir.x );
	//polynomial y = create_poly_1( eye.y, dir.y );
	//polynomial z = create_poly_1( eye.z, dir.z );

    
        polynomial px, py ,pz;
    
        highp vec3 N 


        //tmin = min;
        //tmax = max;
        //tmin = (tmin - min) / (max-min);
        //tmax = (tmax - min) / (max-min);

    
        N = normalize(N);

        //highp vec3 N = eval_p(p_normal, hit_point);
        //highp vec3 N = vec3(eval_p( mult(create_poly_0(2.0),x,1), hit_point.x), eval_p(  mult(mult(create_poly_0(2.0),x,1),create_poly_0(0.0),1), hit_point.x), eval_p(  mult(mult(create_poly_0(2.0),x,1),create_poly_0(0.0),1), hit_point.z));


        highp vec3 L = normalize(LightPosition);
        highp vec3 E = -dir;
        lowp vec3 color;

        if(dot(N, E) >= DELTA)
        {
            highp vec3 H = normalize(L + E);

            highp float df = max(0.0, dot(N, L));
            highp float sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            color = AmbientMaterial;
            color +=   sf * SpecularMaterial;
            L = normalize(LightPosition2);
            H = normalize(L + E);

            df = max(0.0, dot(N, L));
            sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            color +=   sf * SpecularMaterial;

          /*  L = normalize(LightPosition3);
            H = normalize(L + E);

            df = max(0.0, dot(N, L));
            sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            color +=   sf * SpecularMaterial;
          */

        }else
        {
            E = - E;
            highp vec3 H = normalize(L - E);

            highp float df = max(0.0, dot(N, L));
            highp float sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            color = AmbientMaterial2;
            color +=   sf * SpecularMaterial2;
            L = normalize(LightPosition2);
            H = normalize(L + E);

            df = max(0.0, dot(N, L));
            sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            color +=   sf * SpecularMaterial2;

          /*  L = normalize(LightPosition3);
            H = normalize(L + E);

            df = max(0.0, dot(N, L));
            sf = max(0.0, dot(N, H));
            sf = pow(sf, Shininess);
            color +=   sf * SpecularMaterial2;
        */
        }


    gl_FragColor = vec4(color, 1);


}



/**
 * main method, that guides the overall process
 */
void main( void )
{
    //gl_FragColor = vec4( 0.0, 0.0, 1.0 , 1.0 );

	// setup ray(s)
	highp float tmin, tmax, min, max;
	clip_to_unit_sphere( varying_eye, varying_dir, tmin, tmax );
    //gl_FragColor = vec4( 0.0, 1.0, 0.0 , 1.0 );

//    if(tmax < 10.0)
  //      gl_FragColor = vec4( 0.0, 0.0, 1.0 , 1.0 ); 
    
	highp float tcenter = ( tmin + tmax ) * 0.5;
    //Con esto ponemos el 0 en el medio del grafico.
	highp vec3 eye = varying_eye + tcenter * varying_dir;
	highp vec3 dir = varying_dir;
	tmin = tmin - tcenter;
	tmax = tmax - tcenter;
    // setup polynomial
	polynomial p_ray = calc_coefficients( eye, dir, vec2( tmin, tmax ) );
    highp float scale = tmax-tmin;
    //highp float scale = 1000.0;

    //shiftStretch( p_ray, tmin, scale , p_ray );
    //min = tmin;
    //max = tmax;
    //tmin = 0.0;//(tmin - min) / (max-min);
//    if(tmin == 0.0)
//        discard;
	//tmax = (tmax - min) / scale;
    
    //gl_FragColor = vec4( clamp( dir, 0.0, 1.0 ), 0.5 );

gl_FragColor = vec4( 0.0, 0.0, 1.0 , 1.0 );

	// find intersection of ray and surface
	highp float root = first_root_in( p_ray, tmin, tmax );
//    if(abs(root - tmax) < 0.1 || abs(root - tmin) < 0.1)
//        discard;
    //root = (max-min)*root+min;
	highp vec3 hit_point = eye + root * dir;


   calc_lights( eye, dir, hit_point);


	//gl_FragColor = vec4( normalize( mygradient( hit_point ) ), 0.5 );

//gl_FragColor = gl_Color;
//gl_FragColor = vec4( 0.0, 0.0, 1.0 , 0.5 );
//gl_FragColor = vec4( clamp( dir, 0.0, 1.0 ), 0.5 );


}
