function rtn = llg(m, dt, h_zee)
    global gamma
    global alpha
    
    h = h_eff(m) + h_zee;
    cros_m_h = cross(m, h, 4);
    term = (1+(alpha^2));
    dmdt = (-(gamma/term) * cros_m_h) - ((alpha*gamma)/term)*cross(m, cros_m_h, 4);
    m = m + dt*dmdt;
    m_sum = sum(m.*m, 4);
    m_sum_sqrt = sqrt(m_sum);  % Compute the square root of each element
    m_sum_sqrt = reshape(m_sum_sqrt, [1 numel(m_sum_sqrt)]); % Flatten the array to a vector
    m_sum_sqrt = [m_sum_sqrt m_sum_sqrt m_sum_sqrt]; % Repeat the vector 3 times to match m's size
    rtn = m./reshape( m_sum_sqrt, size(m) );
end