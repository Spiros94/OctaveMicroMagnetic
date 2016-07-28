function rtn = h_eff()
    global m_pad
    global n
    global f_n_demag
    global dx
    global ms
    global mu0
    global A
    global m
    
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
    
    for i = 0:5
        arr_index = mod(i,3)+1;
        dx_val = dx(arr_index)^2;
        
        if n(arr_index) == 1
            h_ex = h_ex + (m./dx_val);
        else 
            number = [(floor(i/3)*2) ones(1,(n(arr_index)-2)) (2-(floor(i/3)*2))];
            need_columns = [];
            for l = 1:length(number) % Select only columns you want from the current axis and/or duplicate them
               if l > 0
                  need_columns = [need_columns repmat(l,[1,number(l)])];
               end 
            end
            if arr_index == 1 % First axis
                h_ex = h_ex + m(need_columns,:,:,:)./dx_val;
            elseif arr_index == 2 % Second axis
                h_ex = h_ex + (m(:,need_columns,:,:))./dx_val;
            else % Third axis
                h_ex = h_ex + (m(:,:,need_columns,:))./dx_val;
            end
        end
    end
    
    rtn = ms*h_demag + ((2*A)/(mu0*ms))*h_ex;
end