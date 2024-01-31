% Muscle dynamics function
function dydt = muscleDynamics(t, y, F_max, v_max, Delta_t_a, m1, phi1, I)
    
% save last angle of ellbow joint and last time
persistent last_phi last_t
    if isempty(last_t) % check for first iteration
        last_t = t;
        last_phi = phi1;
    end

    % Extract current state
    l_CE_norm       = y(1);
    v_CE_norm       = y(2);
    a               = y(3);
    phi1            = y(4);
    v_phi1          = y(5);         % Joint angular velocity
    integral_error  = y(6);         % Updated to reflect the new index

    %PID Controller
    setpoint        = pi/2;                                 % define setpoint
    dt = t - last_t;                                        % calculate of dt
    derivative = (phi1 - last_phi) / dt;                    % derivative error for PID
    current_error = setpoint - phi1;                        % calculate the current error
    integral_error = integral_error + current_error * dt;   % Update integral of error

    % Call PID controller
    axx = PIDController(current_error, integral_error, derivative);
    
    % calculate activation based on the control signal
    da_dt = activation_dynamics(a, axx, Delta_t_a);
    
    % Calculate muscle force based on activation
    F = muscle_force(l_CE_norm, v_CE_norm, a, F_max);

    % Calculate the torque and the angular acceleration of the joint
    tau = m1 * F;       % based on (Wochner 2023)
    a_phi1 = tau / I;   % based on http://dodo.fb06.fh-muenchen.de/lab_didaktik/pdf/web-massentraegheitsmoment.pdf
    
    %gravity influence
    tau_grav = - 2 * 9.81* 0.15 * sin(phi1);    % gravitational impact, 2kg, 0,3m long lower arm
    if phi1 > pi                                % check if gravitational impact should accelerate or deccelerate the joint
        a_grav   = - abs(tau_grav / I);         % based on http://dodo.fb06.fh-muenchen.de/lab_didaktik/pdf/web-massentraegheitsmoment.pdf
    else
        a_grav   = tau_grav / I;                % based on http://dodo.fb06.fh-muenchen.de/lab_didaktik/pdf/web-massentraegheitsmoment.pdf
    end

    a_phi1 = a_phi1 + a_grav;                   % combined acceleration of the ellbow joint

    % New approach for integration
    dydt = zeros(6, 1);       % Update the size to accommodate new state variables
    dydt(1) = -m1 * (v_CE_norm * v_max) / m1; % Change in normalized muscle length
    dydt(2) = ((a_phi1 * m1) / v_max);        % Change in normalized muscle velocity
    dydt(3) = da_dt;                          % Activation dynamics
    dydt(4) = y(5);                           % Angular velocity (first derivative of joint angle)
    dydt(5) = a_phi1;                         % Angular acceleration (second derivative of joint angle)
    dydt(6) = integral_error;                 % Integral error for PID control

    % Compile the derivatives into a column vector for next iteration
    last_phi = phi1;
    last_t = t;
end