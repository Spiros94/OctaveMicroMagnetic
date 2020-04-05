function llg(dt,h_zee)
    global gamma
    global alpha
    global m
    
    h = h_eff() + h_zee;
    
    cros_m_h = cross(m, h, 4);
    termAG = gamma/(1+(alpha^2));
%    if strcmp(asp.DropDown.Value, 'Euler')
%        dmdt = (- termAG * cros_m_h) - (alpha*termAG)*cross(m, cros_m_h, 4);
%        %dmdt = (-(gamma/term) * cros_m_h) - ((alpha*gamma)/term)*cross(m, cros_m_h, 4);
%        m = m + dt*dmdt;
%    end
%    if strcmp(asp.DropDown.Value, 'RK')
        ka = dt*( -(termAG * cros_m_h) - (alpha*termAG)*cross(m, cros_m_h, 4) );
        tempKaTermA = m+(ka/2);
        tempKaTermB = cross(tempKaTermA, h);
        kb = dt*( - (termAG * tempKaTermB) - (alpha*termAG) * cross(tempKaTermA,tempKaTermB) );
        tempKbTermA = m+(kb/2);
        tempKbTermB = cross(tempKbTermA, h);
        kc = dt*( - (termAG * tempKbTermB) - (alpha*termAG) * cross(tempKbTermA,tempKbTermB) );
        tempKcTermA = m+kc;
        tempKcTermB = cross(tempKcTermA, h);
        kd = dt* (- (termAG * tempKcTermB) - (alpha*termAG) * cross(tempKcTermA,tempKcTermB) );
        m = m + (1/6)*(ka+2*kb+2*kc+kd);
%    end
    %m_sum = sum(m.*m, 4);
    %m_sum_sqrt = sqrt(m_sum);  % Compute the square root of each element
    %m_sum_sqrt = reshape(m_sum_sqrt, [1 numel(m_sum_sqrt)]); % Flatten the array to a vector
    %m_sum_sqrt = [m_sum_sqrt m_sum_sqrt m_sum_sqrt]; % Repeat the vector 3 times to match m's size
    %rtn = m./reshape( m_sum_sqrt, size(m) );
end