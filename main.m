function main(app)
    global asp
    asp = app; %Random variable name
    statusLbl('Init');
    
    % Mesh and material constants
    global n
    n = eval(app.ObjShape.Value); %shape of the object
    app.ObjShape.Editable = 'off';
    
    global dx
    dx = eval(app.CellSize.Value); %dimensions of individual magnets
    app.CellSize.Editable = 'off';
    
    global mu0
    mu0 = eval(app.mu0.Value);
    app.mu0.Editable = 'off';
    
    global gamma
    gamma = app.Gamma.Value;
    app.Gamma.Editable = 'off';

    global ms
    ms = app.ms.Value;
    app.ms.Editable = 'off';
    
    global A
    A = 1.3e-11;
    
    global alpha
    alpha = app.RelaxAlpha.Value;
    app.RelaxAlpha.Editable = 'off';
    

    global n_demag
    n_demag = zeros(n(1)*2-1,n(2)*2-1,n(3)*2-1,6);
    global m_pad
    m_pad = zeros(n(1)*2-1, n(2)*2-1, n(3)*2-1, 3);
    global f_n_demag

    statusLbl('Calculating N Demag');
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
   
   statusLbl('Relaxation');
   statusLbl(strcat('Relaxation steps:',int2str(app.RelaxSteps.Value)));
   
   app.RelaxSteps.Editable = 'off';
   
   for i = 1:app.RelaxSteps.Value % Call LLG x times to relax
       llg(2e-13,0);  % args(m, dt, h_zee)
   end

   alpha = app.Alpha.Value;
   app.Alpha.Editable = 'off';
   
   dt = app.StepSize.Value;
   app.StepSize.Editable = 'off';
    
   statusLbl('Calculating Zeeman');
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
   
   statusLbl('Solving LLG');

   output_buffer = [];
   cnt = 0;
   for i = 0:(floor(1e-9/dt)-1)
       output_buffer = [output_buffer; (i*1e9*dt) mean(reshape(m(:,:,:,1),1,[])) mean(reshape(m(:,:,:,2),1,[])) mean(reshape(m(:,:,:,3),1,[]))];
       if mod(cnt,500) == 0 % draw graph every 500 steps
           plot(app.UIAxes, output_buffer(:,1), output_buffer(:,2), output_buffer(:,1), output_buffer(:,3), output_buffer(:,1), output_buffer(:,4));
           drawnow
       end
       cnt = cnt + 1;
       llg(dt,h_zee);
   end
   statusLbl('Simulation Finished');
   beep
   pause
end

function statusLbl(x)
    global asp
    asp.Label2.Text = x;
end
