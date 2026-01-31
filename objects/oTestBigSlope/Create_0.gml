var _shape = new BonkStructTriangle(bbox_left, bbox_top, 0,
                                    bbox_right, bbox_top, 400,
                                    bbox_left, bbox_bottom, 0);
instance_create_depth(_shape.x1, _shape.y1, 0, oTestBigSlopePart, { shape: _shape });

var _shape = new BonkStructTriangle(bbox_right, bbox_top, 400,
                                    bbox_right, bbox_bottom, 400,
                                    bbox_left, bbox_bottom, 0);
instance_create_depth(_shape.x1, _shape.y1, 0, oTestBigSlopePart, { shape: _shape });

instance_destroy();