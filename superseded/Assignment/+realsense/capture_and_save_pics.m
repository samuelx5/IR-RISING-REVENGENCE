function capture_and_save_pics()
    % Make Pipeline object to manage streaming
    pipe = realsense.pipeline();
    % Make Colorizer object to prettify depth output
    colorizer = realsense.colorizer();

    try
        while true
            % Start streaming on an arbitrary camera with default settings
            profile = pipe.start();

            % Get streaming device's name
            dev = profile.get_device();
            name = dev.get_info(realsense.camera_info.name);

            % Get frames. We discard the first couple to allow
            % the camera time to settle
            i = 1;
            while i <= 2
                i = i + 1;
                for j = 1:5
                    fs = pipe.wait_for_frames();
                end
            end

            % Stop streaming
            pipe.stop();

            % Select depth frame
            depth = fs.get_depth_frame();
            % Colorize depth frame
            color = colorizer.colorize(depth);

            % Get actual data and convert into a format for saving
            data = color.get_data();
            img = permute(reshape(data',[3,color.get_width(),color.get_height()]),[3 2 1]);

            % Save the image with a unique filename based on a timestamp
            timestamp = datestr(now, 'yyyy_mm_dd_HH_MM_SS');
            filename = sprintf('%s_%s.png', name, timestamp);
            imwrite(img, filename);

            disp(['Image saved as ' filename]);

            % Wait for 5 seconds before capturing the next image
            pause(5);
        end
    catch e
        disp(['Error: ' getReport(e)]);
    end
end
