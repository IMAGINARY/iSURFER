uniform mat4 modelviewMatrix;
uniform mat4 modelviewMatrixInverse;
uniform mat4 projectionMatrix;

attribute vec4 pos;

void main()
{
	gl_Position = modelviewMatrix * pos;
}
