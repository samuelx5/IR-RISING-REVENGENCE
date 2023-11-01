robot = TM5;
bot = DobotMagician;
workspace = [-1.5, 1.5,-1.5,1.5,-0.01,1.5];
scale = 0.5;
q = zeros(1,6);
r = zeros(1,5);
robot.model.base = transl([-0.5,0,0]);
bot.model.base = transl([0.5,0,0]);
robot.model.plot(q,'workspace',workspace,'scale',scale);
bot.model.plot(r,'workspace',workspace,'scale',scale); 

T1 = transl(-0.1,0,0.5);
q1 = robot.model.ikcon(T1);
T2 = transl(-0.9,0.4,0.3);
q2 = robot.model.ikcon(T2);
T3 = transl(0.4,0,0.3);
q3 = bot.model.ikcon(T3);
T4 = transl(0.7,0.1,0.3);
q4 = bot.model.ikcon(T4);

steps = 50;

qMatrix = jtraj(q1,q2,steps);
qMatrix1 = jtraj(q3,q4,steps);

figure(1)
robot.model.plot(qMatrix,'workspace',workspace,'trail','r-') 
bot.model.plot(qMatrix1, 'workspace',workspace,'trail','r-')

