%----SET VARIABLES------
clear
clc
E_Stop = 0;
robot = DobotMagician;
workspace = [-0.5 0.5 -0.5 0.5 0 0.5]
q1 = robot.model.ikcon(transl(0,0,0));
q2 = robot.model.ikcon(transl(0,0,0));
steps = 10;


%------------------


%----DUMMY SENSOR DATA------
%Inputs:
%Outputs:
%------------------

%----Solve Pose from Sensor to robot------
%Inputs:
while true 
    if E_Stop == 0
        q2 = robot.model.ikcon(transl(randn(1),randn(1),randn(1)));
        qMatrix = jtraj(q1,q2,steps);
        robot.model.plot(qMatrix,'workspace', workspace, 'trail','r-')
        q1 = q2;
    end
end
%Outputs:
%------------------

