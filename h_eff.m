function rtn = h_eff(m)
    global m_pad
    global n
    global f_n_demag
    global dx
    
    m_pad(1:n(1),1:n(2),1:n(3),:) = m;
    f_m_pad = m_pad;
    for i = 1:size(n,2) % Compute FFT on axes greater than 1
       if n(i) > 1
          f_m_pad = fft(f_m_pad, [], i); 
       end
    end
    
    f_h_demag_pad = zeros(size(f_m_pad),'like',f_m_pad);
    f_h_demag_pad(:,:,:,1) = sum( (f_n_demag(:,:,:,[1 2 3]).*f_m_pad) , 4);
    f_h_demag_pad(:,:,:,2) = sum( (f_n_demag(:,:,:,[2 4 5]).*f_m_pad) , 4);
    f_h_demag_pad(:,:,:,3) = sum( (f_n_demag(:,:,:,[3 5 6]).*f_m_pad) , 4);
    
    
    h_demag = f_h_demag_pad;
    for i = 1:size(n,2)
       if n(i) > 1
          h_demag = ifft(h_demag, [], i); 
       end
    end
    
    h_demag = real(h_demag(1:n(1), 1:n(2), 1:n(3),:));
    
    dx_sum = 0.;
    for i = 1:length(dx)
        dx_sum = dx_sum + 1/(dx(i)^2);
    end
    
    h_ex = -2 * m * dx_sum;
    
    arr_index = 1;
    for i = 1:6
        dx_num = dx( (mod(i,3))+1 )^2;
        if arr_index == 3, arr_index = 1; else arr_index = arr_index +1; end
    end
    
    
    breaker_point = 0;
end