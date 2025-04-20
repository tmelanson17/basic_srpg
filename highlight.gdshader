shader_type canvas_item;


varying flat vec2 vertexPos;
uniform int gameState;
uniform vec2 globalMousePos;
const vec4 BLUE = vec4(0.0, 0.0, 1.0, 1.0);
const vec4 RED = vec4(1.0, 0.0, 0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
	//COLOR = vec4(1.0, vec3(0.2));
	vertexPos = (MODEL_MATRIX*vec4(VERTEX, 0.0,1.0)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float within_x = step(vertexPos.x, globalMousePos.x);
	float within_y = step(vertexPos.y, globalMousePos.y);
	float above_x = step(globalMousePos.x, vertexPos.x+64.);
	float above_y = step(globalMousePos.y, vertexPos.y+64.);
	COLOR.a = 0.7;
	float current_tile = within_x*within_y*above_x*above_y;
	switch (gameState) {
		case 0:
			COLOR.a += 0.1*current_tile;
			break;
		case 1:
			if (current_tile > 0.0) {
				COLOR = BLUE;
			}
			break;
		case 2:
			break;
		case 3:
			if (current_tile > 0.0) {
				COLOR = RED;
			}
			break;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
