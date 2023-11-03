robot = TM5;
bot = DobotMagicianSim;
workspace = [-1.5, 1.5,-1.5,1.5,-0.01,1.5];
scale = 0.5;
q = zeros(1,6);
r = zeros(1,5);
robot.model.base = transl([-0.5,0,0]);
bot.model.base = transl([0.5,0,0]);
% robot.model.plot(q,'workspace',workspace,'scale',scale);
% bot.model.plot(r,'workspace',workspace,'scale',scale); 
 planeNormal = [-1,0,0];
 planePoint = [1.5,0,0];

 % Then if we have a line (perhaps a robot's link) represented by two points:
 lineStartPoint = [-0.5,0,0];
 lineEndPoint = [3.5,0,0];

 % Then we can use the function to calculate the point of
 % intersection between the line (line) and plane (obstacle)
 [intersectionPoints,check] = LinePlaneIntersection(planeNormal,planePoint,lineStartPoint,lineEndPoint);

 % The returned values and their means are as follows:
 % (1) intersectionPoints, which shows the xyz point where the line
 intersectionPoints

 % (2) check intersects the plane check, which is defined as follows:
 check
 % Check == 0 if there is no intersection
 % Check == 1 if there is a line plane intersection between the two points
 % Check == 2 if the segment lies in the plane (always intersecting)
 % Check == 3 if there is intersection point which lies outside line segment

 % We can visualise this as follows by first creating and
 % plotting a plane, which conforms to the previously defined planePoint and planeNormal

[Y,Z] = meshgrid(-0.7:0.1:-0.3,-0.8:0.1:-0.4);
X = repmat(1.5,size(Y,1),size(Y,2));
surf(X,Y,Z);

hold on;