function main
    % Mesh and material constants
    global n
    n = [3 4 2]; %shape of the object
    global dx
    dx = [5e-9 5e-9 3e-9]; %dimensions of individual magnets
    global mu0
    mu0 = 4e-7 * pi;
    global gamma
    gamma = 2.211e5;
    global ms
    ms = 8e5;
    global A
    A = 1.3e-11;
    global alpha
    alpha = 1.0; % starts with 1 for relaxation

    global n_demag
    n_demag = zeros(n(1)*2-1,n(2)*2-1,n(3)*2-1,6);
    global m_pad
    m_pad = zeros(n(1)*2-1, n(2)*2-1, n(3)*2-1, 3);
    global f_n_demag

    
    % Calculate demag tensor. Elements | Permutation | Function to be used
    set_n_demag(1,[0 1 2]+1, 'f');
    set_n_demag(2,[0 1 2]+1, 'g');
    set_n_demag(3,[0 2 1]+1, 'g');
    set_n_demag(4,[1 2 0]+1, 'f');
    set_n_demag(5,[1 2 0]+1, 'g');
    set_n_demag(6,[2 0 1]+1, 'f');
    
    f_n_demag = n_demag;
    for i = 1:size(n,2)
       if n(i) > 1
          f_n_demag = fft(f_n_demag, [], i); 
       end
    end
   
   global m
   m = zeros(n(1), n(2), n(3), 3);
   m(n(1),:,:,2) = 1.0;
   m(1,:,:,2) = 1.0;
   m(2:n(1)-1,:,:,1) = 1.0;
   
   for i = 1:5000 % Call LLG 5000 times to relax
       llg(2e-13,0);  % args(m, dt, h_zee)
   end
   
   alpha = 0.02;
   dt = 5e-15;

   h_zee = zeros(size(n));
   for i = 1:n(1)
      for j = 1:n(2)
         for l = 1:n(3)
             h_zee(i,j,l,1) = -24.6e-3/mu0;
             h_zee(i,j,l,2) = 4.3e-3/mu0;
             h_zee(i,j,l,3) = 0.0;
         end
      end
   end
   
   fid = fopen('output.txt', 'w');
   for i = 0:(floor(1e-9/dt)-1)
       output_buffer = [(i*1e9*dt) mean(reshape(m(:,:,:,1),1,[])) mean(reshape(m(:,:,:,2),1,[])) mean(reshape(m(:,:,:,3),1,[]))];
       fprintf(fid, '%0.15f %0.15f %0.15f %0.15f \n', output_buffer);
       llg(dt,h_zee);
   end
   beep
end
