function rtn = newells(func, x, y, z)
    if func == 'F' || func == 'f'
        rtn = newellsF(x, y, z);
    elseif func == 'G' || func == 'g'
        rtn = newellsG(x, y, z);
    else
        rtn = NaN;
    end
end


function rtn = newellsF(x, y, z)
    low_eps = 1e-18;
    x = abs(x); y = abs(y); z = abs(z);
    rtn = +(y/2.0)*(z^2 - x^2) * asinh( y /(sqrt(x^2 + z^2) + low_eps)) ...
          +(z/2.0)*(y^2 - x^2) * asinh( z / (sqrt(x^2 + y^2) + low_eps)) ...
          -x*y*z * atan( (y*z) / (x * sqrt(x^2 + y^2 + z^2) + low_eps)) ...
          + (1.0 / 6.0) * (2*x^2 - y^2 - z^2) * sqrt(x^2 + y^2 + z^2);
end


function rtn = newellsG(x, y, z)
    low_eps =  1e-18;
    z = abs(z);
    rtn = +x*y*z * asinh(z/(sqrt(x^2 + y^2) + low_eps))...
          +(y/6.0) * (3.0 * z^2 - y^2) * asinh(x /(sqrt(y^2 + z^2) + low_eps))...
          +(x/6.0) * (3.0 * z^2 - x^2) * asinh(y /(sqrt(x^2 + z^2) + low_eps))...
          -(z^3/6.0) * atan((x*y)/(z * sqrt(x^2 + y^2 + z^2) + low_eps))...
          -(z*y^2/2.0) * atan((x*z)/(y * sqrt(x^2 + y^2 + z^2) + low_eps))...
          -(z*x^2/2.0) * atan((y*z)/(x * sqrt(x^2 + y^2 + z^2) + low_eps))...
          -(x*y * sqrt(x^2 + y^2 + z^2))/3.0;
end