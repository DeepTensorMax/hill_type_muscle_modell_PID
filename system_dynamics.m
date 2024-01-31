% Define the system dynamics including muscle activation, length, and velocity
function dydt = system_dynamics();
    % Unpack the state variables
    a = y(1);      % Muscle activation
    phi = y(2);    % Joint angle
    phi_dot = y(3); % Joint angular velocity
    % Calculate normalized muscle length and velocity
    l_CE_norm_1 = (m1 * phi + l_ref) / l_max; % Assuming l_max is the optimal muscle lengthh
    v_CE_norm_1 = m1 * phi_dot; % Muscle contraction velocity

    % Calculate muscle forces for both muscles
    F1 = muscle_force(l_CE_norm_1, v_CE_norm_1, a, F_max); % Muscle 1 force

    % Calculate joint torque for both muscles
    tau = -(m * F1); % The negative sign indicates a restoring torque

    % Differential equations
    da_dt = (u(t) - a) / Delta_t_a;
    dphi_dt = phi_dot;
    dphi_dot_dt = tau / I; % Newton's second law for rotational motion

    % Return the derivatives
    dydt = [da_dt; dphi_dt; dphi_dot_dt];
end