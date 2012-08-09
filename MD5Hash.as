/* -----------------------------
MD5Hash.as

Creates a class called MD5Hash used to calculate the MD5 hash value of a given set of data.
Place this file in a subdirectory named Hash in your classpath for ActionScript.

Use 'import MD5Hash;' to include the .as file
Use 'm = new MD5Hash("a");' to initialize a new instance

Class exports the following functions
// Constructor, takes one string
	MD5Hash(s:String)

// Getter/Setter functions
	getText():String -- returns string passed to the constructor or setText() function
	setText( s:String ):Void -- sets the internal data set to a new value and re-calculates the hash
	getHash():String -- returns the last calculated hash value
	toString():String -- synonym for getHash()
	valueOf():String -- synonym for getHash()

To re-use an existing Hash instance, simply call the setText() function with a new dataset, the hash
value will be re-calculated instantly.

Example:
////// BEGIN EXAMPLE //////
import MD5Hash;

m = new MD5Hash();
trace( m.getText() + ": " + m.getHash() );
// should return 'd41d8cd98f00b204e9800998ecf8427e'

m.setText("");  // an undefined value is the same as an empty string, should get the same result
trace( m.getText() + ": " + m.getHash() );
// should also return 'd41d8cd98f00b204e9800998ecf8427e'

m.setText("a");
trace( m.getText() + ": " + m.getHash() );
// should return '0cc175b9c0f1b6a831c399e269772661'

m.setText( "The quick brown fox jumps over the lazy dog; what a boring and useless phrase" );
trace( m.getText() + ": " + m.getHash() );
// should return 'f35cbee66b5f212043f5d6a12472ed6c'
//////  END EXAMPLE  //////

Portions of this code were borrowed from http://userpages.umbc.edu/~mabzug1/cs/md5/md5.html
*/

package  
{

class MD5Hash {
	private var inText:String;
	private var hashValue:String;
	private var currentState:Array;
	private var processArray:Array;

	//Magic initialization constants
	private static var MD5_INIT_STATE_0:Number = 0x67452301;
	private static var MD5_INIT_STATE_1:Number = 0xefcdab89;
	private static var MD5_INIT_STATE_2:Number = 0x98badcfe;
	private static var MD5_INIT_STATE_3:Number = 0x10325476;

	//Constants for Transform routine.
	private static var MD5_S11:Number = 7;
	private static var MD5_S12:Number = 12;
	private static var MD5_S13:Number = 17;
	private static var MD5_S14:Number = 22;
	private static var MD5_S21:Number = 5;
	private static var MD5_S22:Number = 9;
	private static var MD5_S23:Number = 14;
	private static var MD5_S24:Number = 20;
	private static var MD5_S31:Number = 4;
	private static var MD5_S32:Number = 11;
	private static var MD5_S33:Number = 16;
	private static var MD5_S34:Number = 23;
	private static var MD5_S41:Number = 6;
	private static var MD5_S42:Number = 10;
	private static var MD5_S43:Number = 15;
	private static var MD5_S44:Number = 21;

	//Transformation Constants - Round 1
	private static var MD5_T01:Number = 0xd76aa478; //Transformation Constant 1 
	private static var MD5_T02:Number = 0xe8c7b756; //Transformation Constant 2
	private static var MD5_T03:Number = 0x242070db; //Transformation Constant 3
	private static var MD5_T04:Number = 0xc1bdceee; //Transformation Constant 4
	private static var MD5_T05:Number = 0xf57c0faf; //Transformation Constant 5
	private static var MD5_T06:Number = 0x4787c62a; //Transformation Constant 6
	private static var MD5_T07:Number = 0xa8304613; //Transformation Constant 7
	private static var MD5_T08:Number = 0xfd469501; //Transformation Constant 8
	private static var MD5_T09:Number = 0x698098d8; //Transformation Constant 9
	private static var MD5_T10:Number = 0x8b44f7af; //Transformation Constant 10
	private static var MD5_T11:Number = 0xffff5bb1; //Transformation Constant 11
	private static var MD5_T12:Number = 0x895cd7be; //Transformation Constant 12
	private static var MD5_T13:Number = 0x6b901122; //Transformation Constant 13
	private static var MD5_T14:Number = 0xfd987193; //Transformation Constant 14
	private static var MD5_T15:Number = 0xa679438e; //Transformation Constant 15
	private static var MD5_T16:Number = 0x49b40821; //Transformation Constant 16

	//Transformation Constants - Round 2
	private static var MD5_T17:Number = 0xf61e2562; //Transformation Constant 17
	private static var MD5_T18:Number = 0xc040b340; //Transformation Constant 18
	private static var MD5_T19:Number = 0x265e5a51; //Transformation Constant 19
	private static var MD5_T20:Number = 0xe9b6c7aa; //Transformation Constant 20
	private static var MD5_T21:Number = 0xd62f105d; //Transformation Constant 21
	private static var MD5_T22:Number = 0x02441453; //Transformation Constant 22
	private static var MD5_T23:Number = 0xd8a1e681; //Transformation Constant 23
	private static var MD5_T24:Number = 0xe7d3fbc8; //Transformation Constant 24
	private static var MD5_T25:Number = 0x21e1cde6; //Transformation Constant 25
	private static var MD5_T26:Number = 0xc33707d6; //Transformation Constant 26
	private static var MD5_T27:Number = 0xf4d50d87; //Transformation Constant 27
	private static var MD5_T28:Number = 0x455a14ed; //Transformation Constant 28
	private static var MD5_T29:Number = 0xa9e3e905; //Transformation Constant 29
	private static var MD5_T30:Number = 0xfcefa3f8; //Transformation Constant 30
	private static var MD5_T31:Number = 0x676f02d9; //Transformation Constant 31
	private static var MD5_T32:Number = 0x8d2a4c8a; //Transformation Constant 32

	//Transformation Constants - Round 3
	private static var MD5_T33:Number = 0xfffa3942; //Transformation Constant 33
	private static var MD5_T34:Number = 0x8771f681; //Transformation Constant 34
	private static var MD5_T35:Number = 0x6d9d6122; //Transformation Constant 35
	private static var MD5_T36:Number = 0xfde5380c; //Transformation Constant 36
	private static var MD5_T37:Number = 0xa4beea44; //Transformation Constant 37
	private static var MD5_T38:Number = 0x4bdecfa9; //Transformation Constant 38
	private static var MD5_T39:Number = 0xf6bb4b60; //Transformation Constant 39
	private static var MD5_T40:Number = 0xbebfbc70; //Transformation Constant 40
	private static var MD5_T41:Number = 0x289b7ec6; //Transformation Constant 41
	private static var MD5_T42:Number = 0xeaa127fa; //Transformation Constant 42
	private static var MD5_T43:Number = 0xd4ef3085; //Transformation Constant 43
	private static var MD5_T44:Number = 0x04881d05; //Transformation Constant 44
	private static var MD5_T45:Number = 0xd9d4d039; //Transformation Constant 45
	private static var MD5_T46:Number = 0xe6db99e5; //Transformation Constant 46
	private static var MD5_T47:Number = 0x1fa27cf8; //Transformation Constant 47
	private static var MD5_T48:Number = 0xc4ac5665; //Transformation Constant 48

	//Transformation Constants - Round 4
	private static var MD5_T49:Number = 0xf4292244; //Transformation Constant 49
	private static var MD5_T50:Number = 0x432aff97; //Transformation Constant 50
	private static var MD5_T51:Number = 0xab9423a7; //Transformation Constant 51
	private static var MD5_T52:Number = 0xfc93a039; //Transformation Constant 52
	private static var MD5_T53:Number = 0x655b59c3; //Transformation Constant 53
	private static var MD5_T54:Number = 0x8f0ccc92; //Transformation Constant 54
	private static var MD5_T55:Number = 0xffeff47d; //Transformation Constant 55
	private static var MD5_T56:Number = 0x85845dd1; //Transformation Constant 56
	private static var MD5_T57:Number = 0x6fa87e4f; //Transformation Constant 57
	private static var MD5_T58:Number = 0xfe2ce6e0; //Transformation Constant 58
	private static var MD5_T59:Number = 0xa3014314; //Transformation Constant 59
	private static var MD5_T60:Number = 0x4e0811a1; //Transformation Constant 60
	private static var MD5_T61:Number = 0xf7537e82; //Transformation Constant 61
	private static var MD5_T62:Number = 0xbd3af235; //Transformation Constant 62
	private static var MD5_T63:Number = 0x2ad7d2bb; //Transformation Constant 63
	private static var MD5_T64:Number = 0xeb86d391; //Transformation Constant 64

	// Getter/Setter methods
	public function getText():String { return inText; }
	public function setText( s:String ) { initialize( s ); }
	public function getHash():String { return hashValue; }
	public function toString():String { return getHash(); }
	public function valueOf():String { return toString(); }

	// Constructor, takes one string
	function MD5Hash(s:String) { initialize(s); }

	// Set up our initial values, set apart so that we may be called again
	private function initialize( s:String ) {
		inText = s;
		if( currentState != undefined ) { currentState = null; }
		currentState = new Array( MD5_INIT_STATE_0, MD5_INIT_STATE_1, MD5_INIT_STATE_2, MD5_INIT_STATE_3 );
		hash(); // Finally, update our hash value
	}
	
	// Rotates number X left by N bits and wraps carryover to LSB (32-bit integer)
	private function rotl( x:Number, n:Number ):Number { return ( ( x << n ) | ( x >>> ( 32 - n ) ) ); }

	// Calculates an unsigned addition of x and y
	private function au( x:Number, y:Number ):Number {
		var lX8:Number = ( x & 0x80000000 );
		var lY8:Number = ( y & 0x80000000 );
		var lX4:Number = ( x & 0x40000000 );
		var lY4:Number = ( y & 0x40000000 );
		var lResult:Number = ( x & 0x3fffffff ) + ( y & 0x3fffffff );
		if( lX4 & lY4 ) { return lResult ^ 0x80000000 ^ lX8 ^ lY8; }
		if( lX4 | lY4 ) {
			if( lResult & 0x40000000 ) { return lResult ^ 0xc0000000 ^ lX8 ^ lY8; }
			return lResult ^ 0x40000000 ^ lX8 ^ lY8;
		}
		
		var r:Number = lResult ^ lX8 ^ lY8;
		return r;
	}
	
	private function ff( a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number ):Number {
		return au( rotl( au( a, au( au( ( ( b & c ) | ( (~b) & d ) ), x ), t ) ), s ), b );
	}

	private function gg( a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number ):Number {
		return au( rotl( au( a, au( au( ( ( b & d ) | ( c & (~d) ) ), x ), t ) ), s ), b );
	}
	
	private function hh( a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number ):Number {
		return au( rotl( au( a, au( au( ( b ^ c ^ d ), x ), t ) ), s ), b );
	}

	private function ii( a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number ):Number {
		return au( rotl( au( a, au( au( ( c ^ ( b | (~d) ) ), x ), t ) ), s ), b );
	}
	
	private function transform( X:Array ) {
		var a:Number = currentState[ 0 ];
		var b:Number = currentState[ 1 ];
		var c:Number = currentState[ 2 ];
		var d:Number = currentState[ 3 ];

		//Perform Round 1 of the transformation
		a = ff( a, b, c, d, X[ 0], MD5_S11, MD5_T01 );
		d = ff( d, a, b, c, X[ 1], MD5_S12, MD5_T02 );
		c = ff( c, d, a, b, X[ 2], MD5_S13, MD5_T03 ); 
		b = ff( b, c, d, a, X[ 3], MD5_S14, MD5_T04 ); 
		a = ff( a, b, c, d, X[ 4], MD5_S11, MD5_T05 ); 
		d = ff( d, a, b, c, X[ 5], MD5_S12, MD5_T06 ); 
		c = ff( c, d, a, b, X[ 6], MD5_S13, MD5_T07 ); 
		b = ff( b, c, d, a, X[ 7], MD5_S14, MD5_T08 ); 
		a = ff( a, b, c, d, X[ 8], MD5_S11, MD5_T09 ); 
		d = ff( d, a, b, c, X[ 9], MD5_S12, MD5_T10 ); 
		c = ff( c, d, a, b, X[10], MD5_S13, MD5_T11 ); 
		b = ff( b, c, d, a, X[11], MD5_S14, MD5_T12 ); 
		a = ff( a, b, c, d, X[12], MD5_S11, MD5_T13 ); 
		d = ff( d, a, b, c, X[13], MD5_S12, MD5_T14 ); 
		c = ff( c, d, a, b, X[14], MD5_S13, MD5_T15 ); 
		b = ff( b, c, d, a, X[15], MD5_S14, MD5_T16 ); 

		//Perform Round 2 of the transformation
		a = gg( a, b, c, d, X[ 1], MD5_S21, MD5_T17 ); 
		d = gg( d, a, b, c, X[ 6], MD5_S22, MD5_T18 ); 
		c = gg( c, d, a, b, X[11], MD5_S23, MD5_T19 ); 
		b = gg( b, c, d, a, X[ 0], MD5_S24, MD5_T20 ); 
		a = gg( a, b, c, d, X[ 5], MD5_S21, MD5_T21 ); 
		d = gg( d, a, b, c, X[10], MD5_S22, MD5_T22 ); 
		c = gg( c, d, a, b, X[15], MD5_S23, MD5_T23 ); 
		b = gg( b, c, d, a, X[ 4], MD5_S24, MD5_T24 ); 
		a = gg( a, b, c, d, X[ 9], MD5_S21, MD5_T25 ); 
		d = gg( d, a, b, c, X[14], MD5_S22, MD5_T26 ); 
		c = gg( c, d, a, b, X[ 3], MD5_S23, MD5_T27 ); 
		b = gg( b, c, d, a, X[ 8], MD5_S24, MD5_T28 ); 
		a = gg( a, b, c, d, X[13], MD5_S21, MD5_T29 ); 
		d = gg( d, a, b, c, X[ 2], MD5_S22, MD5_T30 ); 
		c = gg( c, d, a, b, X[ 7], MD5_S23, MD5_T31 ); 
		b = gg( b, c, d, a, X[12], MD5_S24, MD5_T32 ); 
		
		//Perform Round 3 of the transformation
		a = hh( a, b, c, d, X[ 5], MD5_S31, MD5_T33 ); 
		d = hh( d, a, b, c, X[ 8], MD5_S32, MD5_T34 ); 
		c = hh( c, d, a, b, X[11], MD5_S33, MD5_T35 ); 
		b = hh( b, c, d, a, X[14], MD5_S34, MD5_T36 ); 
		a = hh( a, b, c, d, X[ 1], MD5_S31, MD5_T37 ); 
		d = hh( d, a, b, c, X[ 4], MD5_S32, MD5_T38 ); 
		c = hh( c, d, a, b, X[ 7], MD5_S33, MD5_T39 ); 
		b = hh( b, c, d, a, X[10], MD5_S34, MD5_T40 ); 
		a = hh( a, b, c, d, X[13], MD5_S31, MD5_T41 ); 
		d = hh( d, a, b, c, X[ 0], MD5_S32, MD5_T42 ); 
		c = hh( c, d, a, b, X[ 3], MD5_S33, MD5_T43 ); 
		b = hh( b, c, d, a, X[ 6], MD5_S34, MD5_T44 ); 
		a = hh( a, b, c, d, X[ 9], MD5_S31, MD5_T45 ); 
		d = hh( d, a, b, c, X[12], MD5_S32, MD5_T46 ); 
		c = hh( c, d, a, b, X[15], MD5_S33, MD5_T47 ); 
		b = hh( b, c, d, a, X[ 2], MD5_S34, MD5_T48 ); 
		
		//Perform Round 4 of the transformation
		a = ii( a, b, c, d, X[ 0], MD5_S41, MD5_T49 ); 
		d = ii( d, a, b, c, X[ 7], MD5_S42, MD5_T50 ); 
		c = ii( c, d, a, b, X[14], MD5_S43, MD5_T51 ); 
		b = ii( b, c, d, a, X[ 5], MD5_S44, MD5_T52 ); 
		a = ii( a, b, c, d, X[12], MD5_S41, MD5_T53 ); 
		d = ii( d, a, b, c, X[ 3], MD5_S42, MD5_T54 ); 
		c = ii( c, d, a, b, X[10], MD5_S43, MD5_T55 ); 
		b = ii( b, c, d, a, X[ 1], MD5_S44, MD5_T56 ); 
		a = ii( a, b, c, d, X[ 8], MD5_S41, MD5_T57 ); 
		d = ii( d, a, b, c, X[15], MD5_S42, MD5_T58 ); 
		c = ii( c, d, a, b, X[ 6], MD5_S43, MD5_T59 ); 
		b = ii( b, c, d, a, X[13], MD5_S44, MD5_T60 ); 
		a = ii( a, b, c, d, X[ 4], MD5_S41, MD5_T61 ); 
		d = ii( d, a, b, c, X[11], MD5_S42, MD5_T62 ); 
		c = ii( c, d, a, b, X[ 2], MD5_S43, MD5_T63 ); 
		b = ii( b, c, d, a, X[ 9], MD5_S44, MD5_T64 ); 
		
		//add the transformed values to the current checksum
		currentState[ 0 ] = au( a, currentState[ 0 ] );
		currentState[ 1 ] = au( b, currentState[ 1 ] );
		currentState[ 2 ] = au( c, currentState[ 2 ] );
		currentState[ 3 ] = au( d, currentState[ 3 ] );
	}

	private function ConvertToWordArray() {
		var lWordCount;
		var lMessageLength = inText.length;
		var lNumberOfWords_temp1=lMessageLength + 8;
		var lNumberOfWords_temp2=(lNumberOfWords_temp1-(lNumberOfWords_temp1 % 64))/64;
		var lNumberOfWords = (lNumberOfWords_temp2+1)*16;

		if( processArray != undefined ) { processArray = null; }
		processArray = new Array( lNumberOfWords );
		
		var lBytePosition = 0;
		var lByteCount = 0;

		while ( lByteCount < lMessageLength ) {
			lWordCount = (lByteCount-(lByteCount % 4))/4;
			lBytePosition = (lByteCount % 4)*8;
			processArray[lWordCount] |= inText.charCodeAt(lByteCount)<<lBytePosition;
			lByteCount++;
		}

		lWordCount = (lByteCount-(lByteCount % 4))/4;
		lBytePosition = (lByteCount % 4)*8;
		processArray[lWordCount] |=  (0x80<<lBytePosition);
		processArray[lNumberOfWords-2] = lMessageLength<<3;
		processArray[lNumberOfWords-1] = lMessageLength>>>29;
 	}

	private function hash() {		
		ConvertToWordArray();
		var a:Array = new Array( 16 );
		
		for( var i = 0; i < processArray.length; i += 16 ) {
			a = processArray.slice( i, i + 16 );
			transform( a );
		}
		
		hashValue = "";
		for( var i = 0; i < 4; i++ ) {
			hashValue = hashValue.concat( int2hex( currentState[ i ] ) );
		}
	}
	
	private function int2hex( n:Number, c:Number = 0 ):String {
		var lameArray:Array = new Array( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' );
		var s:String = "";
		if( c <= 0 || c > 8 ) { c = 8; }
		if( c % 2 == 1 ) { c++; }
		for( var i:Number = 0; i < c; i+=2 ) {
			var q:Number = ( n >>> ( i << 2 ) ) & 0xff;
			s = s.concat( lameArray[ ( ( q & 0xf0 ) >>> 4 ) & 0x0f ], lameArray[ q & 0x0f ] );
		}
		return s;
	}		
}

}

