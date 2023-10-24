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

    Sensor = Sensor_Data(pipe,colorizer,profile,dev,name,align);
    Sensor(1)=max(0.25, Sensor(1))
    Sensor(1)=min(0.19, Sensor(1))
    Sensor(2)=max(-0.04, Sensor(2))
    Sensor(2)=max(-0.04, Sensor(2))
    Sensor(3) = Sensor(3)-0.3
    if Sensor(3)>0.16 
        Sensor(3) = 0.16
    end

     end_effector_position = Sensor;
    % end_effector_position = uicontrol
    % end_effector_position2 = [0.20 ,-0.14,0.1];
    
    
    
    %c.Value = end_effector_position(2);
    
    
    end_effector_rotation = [0,0,0];
    dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
    %pause(10);
    %dobot.PublishEndEffectorPose(end_effector_position2,end_effector_rotation);
end

%% 

end_effector_position = [0.19, -0.1, 0.15];
% end_effector_position = uicontrol
% end_effector_position2 = [0.20 ,-0.14,0.1];



%c.Value = end_effector_position(2);


end_effector_rotation = [0,0,0];
dobot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
% pause(10);
% dobot.PublishEndEffectorPose(end_effector_position2,end_effector_rotation);

