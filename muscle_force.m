function F = muscle_force(l_CE_norm, v_CE_norm, a, F_max)
% Muscle force calculation function
    % Calculate the active force component using force-length and force-velocity relationships
    F_active = f_L(l_CE_norm) * f_V(v_CE_norm, F_max) * a * F_max;
    % Calculate the passive force component
    F_passive = f_P(l_CE_norm);
    % Total muscle force
    F = F_active + F_passive;
end