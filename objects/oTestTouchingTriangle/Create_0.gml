var _shape = new BonkStructTriangle(bbox_left, bbox_top, 20,
                                    bbox_right, bbox_top, 20,
                                    bbox_left, bbox_bottom, 20);
_shape.hardEdge23 = false;
instance_create_depth(_shape.x1, _shape.y1, 0, oTestBigSlopePart, { shape: _shape });

var _shape = new BonkStructTriangle(bbox_right, bbox_top, 20,
                                    bbox_right, bbox_bottom, 20,
                                    bbox_left, bbox_bottom, 20);
_shape.hardEdge31 = false;
instance_create_depth(_shape.x1, _shape.y1, 0, oTestBigSlopePart, { shape: _shape });

instance_destroy();