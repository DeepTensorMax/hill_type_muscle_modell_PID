    function FP = f_P(l_CE_norm)
    %Function for Passiv Force Calculation, sadly couldnt figure out the original source, but the graph looks as expected
        k_pe = 5;                                   % Passive elastic coefficient
        l_CE_opt = 1;                               % optimal fiber length (normalized) choosen based on (l_max + l_min)/2
        
        if l_CE_norm > 1                            % Passive force only applies when muscle length is strechted
            FP = k_pe * (l_CE_norm - l_CE_opt)^2;   % simplified exponential formula
        else
            FP = 0;
        end
    end