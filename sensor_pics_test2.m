function sensor_pics_test2()

    i = 1;
    while i <= 15
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
    
        % Select color frame (regular image)
        color = fs.get_color_frame();
    
        % Get actual data and convert into a format imshow can use
        data = color.get_data();
        img = permute(reshape(data',[3,color.get_width(),color.get_height()]),[3 2 1]);
        timestamp = datestr(now, 'yyyy_mm_dd_HH_MM_SS');
        filename = sprintf('%s_%s.png', name, timestamp);
        imwrite(img, filename);
    
        disp(['Image saved as ' filename]);
        % Display image
        imshow(img);
        title(sprintf("Color image from %s", name));
        pause(5);
    end
end

