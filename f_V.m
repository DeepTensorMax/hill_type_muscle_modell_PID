function f_V_val = f_V(V_CE_norm, F_max)
    %Function for Force - Velocity Relationship
    %simplified modell based on https://gist.github.com/jimfleming/00a8285d846fb25fe236
    
    a = 10;                         % assumption for fast twitch muscles 
    V_max = -sqrt(F_max/a);         % based on Computational Modelling of Biomechanics and Biotribology in the Musculoskeletal System. (2021). Elsevier. https://doi.org/10.1016/c2018-0-05410-9
    K = a / F_max * 100;            % based on Computational Modelling of Biomechanics and Biotribology in the Musculoskeletal System. (2021). Elsevier. https://doi.org/10.1016/c2018-0-05410-9
    N = 1.5;                        % dimensionless factor of F_Muskel / F_max based on https://gist.github.com/jimfleming/00a8285d846fb25fe236

    if V_CE_norm < 0
        f_V_val = (V_max - V_CE_norm) / (V_max + (K * V_CE_norm));                          %based on https://gist.github.com/jimfleming/00a8285d846fb25fe236
    else
        f_V_val = N + (N - 1) * ((V_max + V_CE_norm) / ((7.56 * K * V_CE_norm) - V_max));   %based on https://gist.github.com/jimfleming/00a8285d846fb25fe236
    end
end