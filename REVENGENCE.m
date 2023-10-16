%----SET VARIABLES------
clear
clc
E_Stop = 0;
robot = DobotMagician;
workspace = [-0.5 0.5 -0.5 0.5 0 0.5];
q1 = robot.model.ikcon(transl(0,0,0));
q2 = robot.model.ikcon(transl(0,0,0));
steps = 10;


%------------------


%----Main------
while true 
    if E_Stop == 0
        T=Dummy_Sensor();
        q2 = robot.model.ikcon(T);
        qMatrix = jtraj(q1,q2,steps);
        robot.model.plot(qMatrix,'workspace', workspace, 'trail','r-')
        q1 = q2;
    end
end
%------------------



%----DUMMY SENSOR DATA------
%Inputs:
function T = Dummy_Sensor
    persistent count
    if isempty(count)
        count = 1;
    end
  targetPoses = [transl(0.1, -0.1, 0.1);

 

                   transl(0.2, 0.2, 0.2);

 

                   transl(0.3, 0.4, 0.1);

                   transl(-0.4, 0.2, 0.3);

                   transl(0.7, -0.4, 0.1);

                   transl(0.9, 0.6, 0.6);

                   transl(-0.1, 0.7, 0.45);

                   transl(0.5, -0.4, 0.1);

                   transl(0.25, 0.65, 0.7);

                   transl(-0.4, 0.7, 0.25);

                   transl(0.3, 0.5, 0.8);

                   transl(0.3, -0.1, 0.1);

                   transl(0.4, 0.4, 0.4);

                   transl(-0.35, 0.7, 0.1);

                   transl(0.5, -0.3, 0.5);

                   transl(-0.3, 0.4, 0.1);

                   transl(0.2, -0.6, 0.45);

                   transl(0.3, 0.7, 0.3);

                   transl(-0.4, 0.45, 0.15);

                   transl(0.35, -0.55, 0.6);

                   transl(0.7, 0.8, 0.3);

                   transl(0.6, 0.65, 0.8);

                   transl(-0.1, 0.3, 0.55);

                   transl(0.2, 0.2, 0.2);

                   transl(-0.3, 0.6, 0.2);

                   transl(0.3, -0.4, 0.6);

                   transl(0.35, 0.45, 0.15);

                   transl(0.65, 0.25, 0.5);

                   transl(0.1, 0.1, 0.1);

                   transl(0.35, 0.4, 0.15);

                   transl(-0.6, 0.7, 0.1);

                   transl(0.6, 0.5, 0.5);

                   transl(-0.3, 0.45, 0.25);

                   transl(0.75, 0.65, 0.45);

                   transl(0.2, -0.6, 0.35);

                   transl(0.3, -0.1, 0.1);

                   transl(0.45, 0.45, 0.5);

                   transl(-0.25, -0.3, 0.4);

                   transl(0.3, 0.5, 0.8);

                   transl(0.3, -0.1, 0.1);

                   transl(0.4, 0.4, 0.4);

                   

 

                   ];

    


    
    T = targetPoses([count:count+3],:);
    
    if count <= size(targetPoses, 1)-4         
    count = count + 4;
    end
end
%Outputs:
%------------------

%----Solve Pose from Sensor to robot------
%Inputs:

%Outputs:
%------------------



