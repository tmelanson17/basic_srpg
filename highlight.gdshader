shader_type canvas_item;


varying flat vec2 vertexPos[2];
uniform vec2 globalMousePos;

void vertex() {
	// Called for every vertex the material is visible on.
	//COLOR = vec4(1.0, vec3(0.2));
	vertexPos[0] = (MODEL_MATRIX*vec4(VERTEX, 0.0,1.0)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float within_x = step(vertexPos[0].x, globalMousePos.x);
	float within_y = step(vertexPos[0].y, globalMousePos.y);
	float above_x = step(-vertexPos[0].x-64., -globalMousePos.x);
	float above_y = step(-vertexPos[0].y-64., -globalMousePos.y);
	COLOR.a = 0.7;
	COLOR.a += 0.1*within_x*within_y*above_x*above_y;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
