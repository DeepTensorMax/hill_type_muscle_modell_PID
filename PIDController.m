function u = PIDController(current_error, integral_error, derivative)
    Kp = 0.0005;    % Proportional gain (needs further optimization)
    Ki = 2000;      % Integral gain (needs further optimization)
    Kd = 0.0001;    % Derivative gain (needs further optimization)

    P = Kp * current_error;     % Proportional term
    I = Ki * integral_error;    % Integral term
    D = Kd * derivative;        % Derivative term

    u_unbounded = P + I + D;    % Compute the control output
    
    if isnan(u_unbounded)       % Check for NaN, ODE solver seems to have difficulties
        u_unbounded = 0;        %Set activation to zero if NaN is detected  
    end

    % Constrain the output based to fit real activation level between 0 and 0.75
    u = max(0, min(u_unbounded, 0.75));
end