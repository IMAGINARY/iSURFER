YUI.add("yuidoc-meta", function(Y) {
   Y.YUIDoc = { meta: {
    "classes": [
        "ApplicationEngine",
        "Compiler",
        "Error",
        "Fragment_Shader",
        "Matrix",
        "ParametricEquations",
        "ParametricSurface",
        "QuaternionT",
        "ScannerADT",
        "Vector",
        "Vertex_Shader",
        "Wire_Fragment_Shader",
        "Wire_Vertex_Shader",
        "exception",
        "expressionT",
        "genlib",
        "parser",
        "programData",
        "simpio",
        "strlib",
        "surfaceRender"
    ],
    "modules": [
        "Engine",
        "OpenGL",
        "Parser",
        "Surface"
    ],
    "allModules": [
        {
            "displayName": "Engine",
            "name": "Engine",
            "description": "This module is written in C++. it is in charge\nof parsing initialize and generate some Data to use OpenGL.\n\nSome parts are based on the book \"iPhone 3D programming\" from O'Reilly.\nby dazar\n\nVersion: 1.0"
        },
        {
            "displayName": "OpenGL",
            "name": "OpenGL",
            "description": "File: fs1.glsl\nVersion: 1.0"
        },
        {
            "displayName": "Parser",
            "name": "Parser",
            "description": "This module is written in C. it is in charge\nof parsing the function and generate shader code for it.\n\nFor this porpouse we use an expression tree. and some string filters on the formula.\nby dazar"
        },
        {
            "displayName": "Surface",
            "name": "Surface",
            "description": "This module is written in C++. it is in charge\nof Creating and compilling the shaders, and render them.\n by dazar\n\nVersion: 3.0"
        }
    ]
} };
});