function main()
  disp('Init');
  pkg load communications
     % Mesh and material constants
    global n
    n = [100 25 1]; % Object shape
 
    global dx
    dx = [5e-9 5e-9 3e-9]; %dimensions of individual magnets
    
    global mu0
    mu0 = 4e-7 * pi; % mu0
    
    global gamma
    gamma = 2.211e+5;

    global ms
    ms = 8e+05;
    
    global A
    A = 1.3e-11;
    
    global alpha
    alpha = 1;  % start with relaxation alpha
    
    relax_steps = 5000;
    

    global n_demag
    n_demag = zeros(n(1)*2-1,n(2)*2-1,n(3)*2-1,6);
    global m_pad
    m_pad = zeros(n(1)*2-1, n(2)*2-1, n(3)*2-1, 3);
    global f_n_demag

    disp('Calculating N Demag');
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
   
   disp('Relaxation');
   disp('Relax steps:');
   disp(relax_steps);
   
   for i = 1:relax_steps % Call LLG x times to relax
       llg(2e-13,0);  % args(m, dt, h_zee)
   end

   alpha = 1;
   
   dt = 5e-15;
    
   disp('Calculating Zeeman field');
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
   
   disp('Solving LLG');

   output_buffer = [];
   cnt = 0;
   for i = 0:(floor(1e-9/dt)-1)
       output_buffer = [output_buffer; (i*1e9*dt) mean(reshape(m(:,:,:,1),1,[])) mean(reshape(m(:,:,:,2),1,[])) mean(reshape(m(:,:,:,3),1,[]))];
       if mod(cnt,500) == 0 % draw graph every 500 steps
           plot(output_buffer(:,1), output_buffer(:,2), output_buffer(:,1), output_buffer(:,3), output_buffer(:,1), output_buffer(:,4));
           drawnow
       end
       cnt = cnt + 1;
       llg(dt,h_zee);
   end
   disp('Simulation Finished');
   beep
   pause
end

