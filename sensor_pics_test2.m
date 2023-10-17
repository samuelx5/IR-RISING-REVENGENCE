function sensor_pics_test2()

    i = 1;   
    while i <= 3
        i = i + 1;
        % Make Pipeline object to manage streaming
        pipe = realsense.pipeline();
    
        % Start streaming on an arbitrary camera with default settings
        profile = pipe.start();
    
        % Get streaming device's name
        dev = profile.get_device();
        name = dev.get_info(realsense.camera_info.name);
    
        % Get frames. We discard the first couple to allow
        % the camera time to settle

        for j = 1:5
            fs = pipe.wait_for_frames();
        end
        
        % Stop streaming
        pipe.stop();
    
        % Select depth frame
        depth = fs.get_depth_frame();
    
        % Get actual depth data
        data = depth.get_data();
        
        % Get width and height of the depth frame
        width = depth.get_width();
        height = depth.get_height();
        
        % Reshape the data as a 16-bit grayscale image
        depth_image = typecast(data, 'uint16');
        depth_image = reshape(depth_image, [width, height])';
        
        % Convert the depth data to a grayscale image
        depth_image = mat2gray(depth_image);
        
        timestamp = datestr(now, 'yyyy_mm_dd_HH_MM_SS');
        filename = sprintf('%s_%s.png', name, timestamp);
        imwrite(depth_image, filename);

        disp(['Depth image saved as ' filename]);
        % Display depth image
        imshow(depth_image);
        title(sprintf("Depth frame from %s", name));
        pause(5);
    end
end
