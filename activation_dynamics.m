function da_dt = activation_dynamics(a, u, Delta_t_a)
% Define the ODE function for activation dynamics
    % Simple activation dynamic, a more complex one could be more optimal
    da_dt = (u - a) / Delta_t_a; % based on (Wochner 2023)
end