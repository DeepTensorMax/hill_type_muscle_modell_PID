function createRotatedArmModel(t, phi1_vals)
    % Create a new figure window with parameters
    figure;
    hold on;
    axis equal;
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Rotated Arm Model');
    view(3);
    
    % Arm dimensions
    lowerArmLength = 0.3; % meters
    upperArmLength = 0.3; % meters
    armDiameter = 0.1;    % meters

    % Create upper arm (cylinder)
    [X, Y, Z] = cylinder(armDiameter/2, 20);
    Z = Z * upperArmLength; % Scale cylinder to upper arm length
    surf(X, Y, Z, 'FaceColor', 'red', 'EdgeColor', 'none');

    % Create lower arm (cylinder) at the correct position
    [X_lower, Y_lower, Z_lower] = cylinder(armDiameter/2, 20);
    Z_lower = Z_lower * lowerArmLength - upperArmLength; % Position the lower arm on top of the upper arm
    
    % Save Initial Positions
    X_lower_initial = X_lower;
    Y_lower_initial = Y_lower;
    Z_lower_initial = Z_lower;

    for k = 1:1000:length(t)
        surf(X, Y, Z, 'FaceColor', 'red', 'EdgeColor', 'none');
        % Rotation matrix around the Y-axis with rotation matrix
        rotation_angle = phi1_vals(k);
        rotationMatrix = makehgtform('yrotate', rotation_angle);
        rotationMatrix = rotationMatrix(1:3, 1:3); % Extract the rotation part of the matrix
        
        % Apply rotation to the vertices of the lower arm
        for i = 1:size(X_lower, 1)
            for j = 1:size(X_lower, 2)               
            % Original point (from initial coordinates)
            originalPoint = [X_lower_initial(i, j); Y_lower_initial(i, j); Z_lower_initial(i, j)];
            % Rotated point
            rotatedPoint = rotationMatrix * originalPoint;
            % Update coordinates
            X_lower(i, j) = rotatedPoint(1);
            Y_lower(i, j) = rotatedPoint(2);
            Z_lower(i, j) = rotatedPoint(3);
            end
        end
        
        % Draw the rotated lower arm and static upper arm
        hold on 
        surf(X, Y, Z, 'FaceColor', 'red', 'EdgeColor', 'none');
        surf(X_lower, Y_lower, Z_lower, 'FaceColor', 'blue', 'EdgeColor', 'none');
        axis equal;
        hold off;
        pause(0.1);
    end
end