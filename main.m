clc 
clear all

%Initalization
% Muscle parameters                                 
tspan = [0 2];              % 20 seconds of simulation time, chosen based on PID stabilization
l_max = 1.05;                % Maximum muscle-fiber length (normalized) based on (Wochner 2023) - Learning with Muscles: Benefits for Data-Efficiency and Robustness in Anthropomorphic Tasks
l_min = 0.75;                % Minimum muscle-fiber length (normalized) based on (Wochner 2023)
L_CE_opt = 0.9;              % optimal fiber length (normalized) choosen based on (l_max + l_min)/2
phi_max = pi/2;              % Maximum joint angle (radians) choosen as maximum 90 degree rotation of ellbow 
phi_min = -pi/4;             % Minimum joint angle (radians) choosen for slight negative rotation of ellbow
Delta_t_a = 0.01;            % Time constant (s) for ODE Solver - the lower the number the better the results
F_max = 600;                 % Maximum isometric force (N) assumption for usual theoretical peak force of biceps brachii
a_vmax = 10;                 % m/s^2 assumption for fast twitch muscles 
v_max = -sqrt(F_max/a_vmax); % m/s based on Computational Modelling of Biomechanics and Biotribology in the Musculoskeletal System. (2021). Elsevier. https://doi.org/10.1016/c2018-0-05410-
epsilon = 0.01;              % ensure stability (Wochner 2023)
phi1 = 0;                    % starting angle (radians) of ellbow joint = 0
v_CE = 0;                    % starting velocity (m/s) of ellbow joint = 0
initial_v_phi1 = 0;          % Assuming initial angular velocity is zero
% PID
integral_error = 0;          % Initialize integral of error
last_time = 0;               % Initialize last time

% Calculate moment arms and reference lengths for the muscle based on (Wochner 2023)
m1 = (l_max - l_min) / (phi_max - phi_min + epsilon);   % Moment arm for the muscle
l_ref1 = l_min - m1 * phi_min;                          % Reference length for the muscle
l_CE_norm = m1* -(phi1)+ l_ref1 /L_CE_opt;              % Normalized length of CE
v_CE_norm = v_CE /v_max;                                % Normalized velocity of CE

% Calculation of Inertia of the lower arm
m = 3;                  % kg
r = 0.05;               % meters
h = 0.3;                % meters
I = 1/12 *(m*r^2+h^2);  % based on https://study.com/skill/learn/how-to-calculate-the-moment-of-inertia-for-a-cylinder-explanation.html

% ODE solver for the muscle dynamic
[t, y] = ode45(@(t, y) muscleDynamics(t, y, F_max, v_max, Delta_t_a, m1, phi1, I), tspan, [l_CE_norm, v_CE_norm, 0, phi1, initial_v_phi1, integral_error]);
% Extracting results
l_CE_norm_vals = y(:, 1);
v_CE_norm_vals = y(:, 2);
activation_vals = y(:, 3);
phi1_vals = y(:, 4);
forces = arrayfun(@(l, v, a) muscle_force(l, v, a, F_max), l_CE_norm_vals, v_CE_norm_vals, activation_vals);

% Plotting results
figure;
subplot(2, 1, 1);
plot(t, forces);
title('Muscle Force over Time');
xlabel('Time (s)');
ylabel('Force (N)');

subplot(2, 1, 2);
plot(t, phi1_vals);
title('Joint Angle over Time');
xlabel('Time (s)');
ylabel('Angle (radians)');

% call Simulation loop
createRotatedArmModel(t, phi1_vals);