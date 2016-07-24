function rtn = allclose(a,b)
    % Compare two same size arrays with presicion
    % Defined in numpy http://docs.scipy.org/doc/numpy/reference/generated/numpy.allclose.html
    % Thanks to: http://stackoverflow.com/a/28975920/6149123
    rtol = 1e-05;
    atol = 1e-08;
    rtn = all( abs(a(:)-b(:)) <= atol+rtol*abs(b(:)) );
end