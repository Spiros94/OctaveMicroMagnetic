function main
    % Mesh and material constants
    n = [100 25 1]; %shape of the object
    dx = [5e-9 5e-9 3e-9]; %dimensions of individual magnets
    mu0 = 4e-7 * pi;
    gamma = 2.211e5;
    ms = 8e5;
    A = 1.3e-11;
    alpha = 0.02;

    n_demag = zeros(n(1)*2-1,n(2)*2-1,n(3)*2-1,6);
    m_pad = zeros(n(1)*2-1, n(2)*2-1, n(3)*2-1, 3);


    % Calculate demag tensor. Elements | Permutation | Function to be used
    set_n_demag(1,[0 1 2], 'f');
    set_n_demag(2,[0 1 2], 'g');
    set_n_demag(3,[0 2 1], 'g');
    set_n_demag(4,[1 2 0], 'f');
    set_n_demag(5,[1 2 0], 'g');
    set_n_demag(6,[2 0 1], 'f');

    f_n_demag = fftn(n_demag, n(n>1));
end
