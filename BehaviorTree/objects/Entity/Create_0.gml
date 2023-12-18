timer		= 1;
image_speed = 0;

target	= { 
	x : x, 
	y : y 
};
patrol = function(){
	
	if ( !target || ( timer && !--timer ) ) {
		timer = 60 + irandom(120);
		target.x = random(room_width);
		target.y = random(room_height);
	}

	image_index = 0;
	direction	= point_direction(x, y, target.x, target.y);
	speed		= 2;
	
}
chase = function(){
	
	image_index = 1;
	direction	= point_direction(x, y, target.x, target.y);
	speed		= 4;
	
}
attack = function(){
	image_index = 2;
}
enemyFind = function(_range=300){
	var col = collision_circle(x, y, _range, Entity, false, true);
	if ( col ) target = col;
	return col;
}
enemyNear = function(){
	return enemyFind(64);
}

behavior = bh_tree()
behavior.selector(
	bh_sequence(
		bh_condition(enemyNear),
		bh_action(attack)
	),
	bh_sequence(
		bh_condition(enemyFind),
		bh_action(chase)
	),
	bh_action(patrol)
);

