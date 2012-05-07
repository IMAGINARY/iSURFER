uniform mat4 modelviewMatrix;

attribute vec4 pos;

void main()
{
	gl_Position = modelviewMatrix * pos;
}
