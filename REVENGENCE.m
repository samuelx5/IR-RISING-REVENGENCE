%% ----SET VARIABLES------

clear
clc

% --------ROS-----------
% rosshutdown;
% rosinit('192.168.27.1');
% dobot = DobotMagician();
% 
% [safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
% safetyStateMsg.Data = 2;
% send(safetyStatePublisher,safetyStateMsg);
% 
% safetyStatusSubscriber = rossubscriber('/dobot_magician/safety_status');
% 
% % currentSafetyStatus = safetyStatusSubscriber.LatestMessage.Data;
% 
% jointStateSubscriber = rossubscriber('/dobot_magician/joint_states');

% ---------------------



%----Sim Settup------
E_Stop = 0;
bot = TM5;
robot = DobotMagicianSim;
workspace = [-1.5, 1.5,-1.5,1.5, 0,5];
scale = 0.5;
r = zeros(1,6);
q = zeros(1,5);
robot.model.base = transl([0,0,0]);
bot.model.base = transl([1,0,0]);
robot.model.plot(q,'workspace',workspace,'scale',scale);
bot.model.plot(r,'workspace',workspace,'scale',scale); 
% workspace = [-0.5 0.5 -0.5 1 0 1];
q1 = robot.model.ikcon(transl(0,0,0));
q2 = robot.model.ikcon(transl(0,0,0));
speed = 10;
T1 = eye(4);
T2 = eye(4);
b = RMRC_test(bot);




%-------------------

% %----Sensor Settup------
% pipe = realsense.pipeline();
% cfg = realsense.config();
% cfg.enable_stream(realsense.stream.color, 848, 480, realsense.format.rgb8);
% cfg.enable_stream(realsense.stream.depth, 848, 480, realsense.format.z16);
% align_to = realsense.stream.color;
% align = realsense.align(align_to);
% colorizer = realsense.colorizer();
% profile = pipe.start(cfg);
% dev = profile.get_device();
% name = dev.get_info(realsense.camera_info.name);
%-----------------


%------------------



%% ----Main------
% 
% for i = 1:5
%     fs = pipe.wait_for_frames();
% end
% 
while true 
    if E_Stop == 0
       for i = 1: 5 : size(b)- 4 

            figure(1)
            hold on
            
        % currentSafetyStatus = safetyStatusSubscriber.LatestMessage.Data;

            T2=Dummy_Sensor();
        % T2=transl(Sensor_Data(pipe,colorizer,profile,dev,name,align));
        steps = 5;%steps2speed(speed, T1, T2);
            q2 = robot.model.ikcon(T2);
            qMatrixTM5 = b(i:i + 4, 1:6)


        %----------- TEST
        % jointTarget = q2(1:4)
        % Sensor_Data(pipe,colorizer,profile,dev,name,align)
        % 
        % 
        % [targetJointTrajPub,targetJointTrajMsg] = rospublisher('/dobot_magician/target_joint_states');
        % trajectoryPoint = rosmessage("trajectory_msgs/JointTrajectoryPoint");
        % trajectoryPoint.Positions = jointTarget;
        % targetJointTrajMsg.Points = trajectoryPoint;
        % send(targetJointTrajPub,targetJointTrajMsg);
        % pause(5)
        %------------------

            qMatrix = jtraj(q1,q2,steps)
            robot.model.plot(qMatrix,'workspace', workspace, 'scale', scale,  'trail','r-')
            bot.model.plot(qMatrixTM5,'workspace', workspace, 'scale', scale, 'trail','r-')
            q1 =q2;
            T1=T2;
       end
    end
end
%------------------




%% ----DUMMY SENSOR DATA----
%Inputs: None
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
%Outputs: T Target Poses
%------------------

%----Solve Pose from Sensor to robot------
%Inputs:

%Outputs:
%------------------
%% 

%% ----Speed To Steps------
%Inputs: Speed, T1, T2
function steps = steps2speed(speed, T1, T2)
    %steps = max(abs(q2-q1))*(1/speed)
    %T1(1:3,4)
    %T2(1:3,4)
    %dist = sqrt((T2(1,4)-T1(1,4))^2+(T2(2,4)-T1(2,4))^2+(T2(3,4)-T1(3,4))^2);
    %steps = dist * speed*10
    steps = 1;
end
%Outputs: Steps
%------------------


