clear;
clc;
close all;
rosshutdown;
%% Start Dobot Magician Node
rosinit('192.168.27.1');

%% Start Dobot ROS
dobot = DobotMagician();
%% 
[safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
safetyStateMsg.Data = 2;
send(safetyStatePublisher,safetyStateMsg);


%% 
safetyStatusSubscriber = rossubscriber('/dobot_magician/safety_status');
pause(2);
currentSafetyStatus = safetyStatusSubscriber.LatestMessage.Data;
%% 
jointStateSubscriber = rossubscriber('/dobot_magician/joint_states'); % Create a ROS Subscriber to the topic joint_states
pause(2); % Allow some time for a message to appear
currentJointState = jointStateSubscriber.LatestMessage.Position % Get the latest message

endEffectorPoseSubscriber = rossubscriber('/dobot_magician/end_effector_poses'); % Create a ROS Subscriber to the topic end_effector_poses
pause(2); %Allow some time for MATLAB to start the subscriber
currentEndEffectorPoseMsg = endEffectorPoseSubscriber.LatestMessage;
% Extract the position of the end effector from the received message
currentEndEffectorPosition = [currentEndEffectorPoseMsg.Pose.Position.X, currentEndEffectorPoseMsg.Pose.Position.Y, currentEndEffectorPoseMsg.Pose.Position.Z]
% Extract the orientation of the end effector
currentEndEffectorQuat = [currentEndEffectorPoseMsg.Pose.Orientation.W, currentEndEffectorPoseMsg.Pose.Orientation.X, currentEndEffectorPoseMsg.Pose.Orientation.Y, currentEndEffectorPoseMsg.Pose.Orientation.Z];
% Convert from quaternion to euler
%[roll,pitch,yaw] =
 quat2eul(currentEndEffectorQuat)
 
 %% 
pipe = realsense.pipeline();

cfg = realsense.config();
cfg.enable_stream(realsense.stream.color, 848, 480, realsense.format.rgb8);
cfg.enable_stream(realsense.stream.depth, 848, 480, realsense.format.z16);
align_to = realsense.stream.color;
align = realsense.align(align_to);


colorizer = realsense.colorizer();
profile = pipe.start(cfg);
dev = profile.get_device();
name = dev.get_info(realsense.camera_info.name);

%% 
while(1)
    %Sensor_Data(pipe,colorizer,profile,dev,name,align)
    Sensor = Sensor_Data(pipe,colorizer,profile,dev,name,align);
    % Sensor(1)=max(0.25, Sensor(1));
    % Sensor(1)=min(0.19, Sensor(1));
    % Sensor(2)=min(-0.1, Sensor(2));
    % Sensor(2)=max(0.1, Sensor(2));
    if Sensor(1)>0.25 
        Sensor(1) = 0.25;
    elseif Sensor(1) < 0.19
        Sensor(1) = 0.19;

    end
    if Sensor(2)>0.08 
        Sensor(2) = 0.08;
    elseif Sensor(2) < -0.08
        Sensor(2) = -0.08;

    end
    Sensor(3) = Sensor(3) - 0.2;
    if Sensor(3)>0.16 
        Sensor(3) = 0.16;
    elseif Sensor(3) < 0
        Sensor(3) = 0;

    end
    %Sensor
    
     end_effector_position = Sensor
     %pause(1);
    % end_effector_position = uicontrol
    % end_effector_position2 = [0.20 ,-0.14,0.1];
    
    
    
    %c.Value = end_effector_position(2);
    
     % 
     % end_effector_rotation = [0,0,0];
     % dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
     % pause(1);
    %dobot.PublishEndEffectorPose(end_effector_position2,end_effector_rotation);
end

%% 
% 
end_effector_position = [0.2287, 0.2266, 0.0448];

end_effector_position3 = [-0.054 ,-0.3051, -0.0158];
end_effector_position2 = [0.2, 0, 0];



%c.Value = end_effector_position(2);


end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
pause(5);
dobot.PublishEndEffectorPose(end_effector_position2,end_effector_rotation);
pause(5);
dobot.PublishEndEffectorPose(end_effector_position3,end_effector_rotation);
%% 


% Get the initial joint positions
jointStateSubscriber = rossubscriber('/dobot_magician/joint_states'); % Create a ROS Subscriber to the topic joint_states
pause(2); % Allow some time for a message to appear
initialJointPositions = jointStateSubscriber.LatestMessage.Position % Get the latest message

% Record the starting time
startTime = now;  % Use 'now' to get the current time

% Move the robot to a new joint configuration
newJointPositions = [0.1, 0.2, 0.3, 0.4];  % Replace with the desired joint positions
dobot.PublishTargetJoint(newJointPositions);

% Wait for a short time if needed
% pause(2);  % Adjust the time delay as needed

% Get the final joint positions
finalJointPositions = jointStateSubscriber.LatestMessage.Position;

% Calculate the displacement
displacement = finalJointPositions - initialJointPositions;

% Calculate the time elapsed
endTime = now;
timeElapsed = (endTime - startTime) * 24 * 3600;  % Convert from days to seconds

% Calculate the speed (in joint units per second)
speed = displacement / timeElapsed;

disp("Joint Speeds: ");
disp(speed);

% Clean up, stop the robot, or perform other actions as needed


