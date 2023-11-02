function qMatrix = applyRMRC(robot, initialPose, targetPose, steps)
    % Initialize the initial joint angles based on the initial pose
    q0 = robot.model.ikcon(initialPose);
    
    % Create joint trajectory from q0 to the target pose using jtraj
    qMatrix = jtraj(q0, robot.model.ikcon(targetPose), steps);
    
    % Allocate arrays for storing trajectory data and errors
    positionError = zeros(3, steps);
    angleError = zeros(3, steps);
    
    % RMRC parameters
    deltaT = 0.02;  % Control frequency
    epsilon = 0.1;  % Threshold value for manipulability/Damped Least Squares
    W = diag([1 1 1 0.1 0.1 0.1]);  % Weighting matrix for the velocity vector

    % Loop for RMRC
    for i = 1:steps-1
        % Get the current forward transformation
        T = robot.model.fkine(qMatrix(i, :)).T;

        % Calculate position error from the next waypoint
        deltaX = transl(targetPose) - T(1:3, 4);

        % Calculate rotation matrix error
        Rd = targetPose(1:3, 1:3);
        Ra = T(1:3, 1:3);
        Rdot = (1/deltaT) * (rpy2r(Rd) - Ra);
        S = Rdot*Ra';

        % Calculate linear and angular velocity
        linearVelocity = (1/deltaT) * deltaX;
        angularVelocity = [S(3,2);S(1,3);S(2,1)];

        % Calculate RMRC control
        xdot = W * [linearVelocity; angularVelocity];
        J = robot.model.jacob0(qMatrix(i, :));

        % Calculate manipulability measure
        m = sqrt(det(J * J'));

        % Apply RMRC only if manipulability is above the threshold
        if m >= epsilon
            lambda = 0;
            invJ = inv(J' * J + lambda * eye(6)) * J';
            qdot = (invJ * xdot)';
        else
            % Handle when manipulability is below the threshold
            lambda = (1 - m/epsilon) * 5E-2;
            invJ = inv(J' * J + lambda * eye(6)) * J';
            qdot = (invJ * xdot)';
        end

        % Update the next joint state based on joint velocities
        qMatrix(i + 1, :) = qMatrix(i, :) + deltaT * qdot;

        % Store position and angle errors for plotting
        positionError(:, i) = deltaX;
        angleError(:, i) = tr2rpy(Rd * Ra');
    end
end
