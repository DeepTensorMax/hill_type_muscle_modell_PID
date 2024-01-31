function f_L_val = f_L(l_CE_norm)
    %Function for Force - Length Relationship
    L_CE_opt = 0.9;         % optimal fiber length (normalized) choosen based on (l_max + l_min)/2
    w = 0.35;               % asc / desc Bell width based on lecture / exercises
    w = 0.35;               % asc / desc Bell width based on lecture / exercises
    v_CElimb_des = 1.5;     % implement for ascending/ descending
    v_CElimb_asc = 3.0;     % implement for ascending/ descending
    f_L_val = exp(-((abs((l_CE_norm / L_CE_opt - 1) / w)) ^ v_CElimb_asc)); % based on (Häufle 2014) - Hill-type muscle model with serial damping and eccentric force-velocity relation    
end