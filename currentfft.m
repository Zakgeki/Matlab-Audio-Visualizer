%current fft
function currentfft ( player, Y, FS, thetaArr, xP1, yP1, xP2, yP2, xP3, yP3, xP4, yP4, xP5, yP5 )

    sampleNumber = get( player, 'CurrentSample' );
    timerVal = get( player, 'TimerPeriod' );

    %Get channel one values for our window around the current sample number
    s1 = Y(floor(sampleNumber-((timerVal*FS)/2)):floor(sampleNumber+((timerVal*FS)/2)),1);

    n = length(s1);
    p = fft(s1); % take the fourier transform

    nUniquePts = ceil((n+1)/2);
    p = p(1:nUniquePts);    % select just the first half since the second half
    			            % is a mirror image of the first

    p = abs(p);             % take the absolute value, or the magnitude

    p = p/n;                % scale by the number of points so that
                            % the magnitude does not depend on the length
                            % of the signal or on its sampling frequency

    p = p.^2;               % square it to get the power

    % multiply by two
    if rem(n, 2) % odd nfft excludes Nyquist point
        p(2:end) = p(2:end)*2;
    else
        p(2:end -1) = p(2:end -1)*2;
    end

    % summing specific bands of frequen together
    p0 = sum(p((floor(1*n/FS)+1):(floor(60*n/FS)+1)));
    p1 = sum(p((floor(60*n/FS)+1):(floor(250*n/FS)+1)));
    p2 = sum(p((floor(250*n/FS)+1):(floor(2e3*n/FS)+1)));
    p3 = sum(p((floor(2e3*n/FS)+1):(floor(8e3*n/FS)+1)));
    p4 = sum(p((floor(8e3*n/FS)+1):(floor(20e3*n/FS)+1)));

    pArr = [ p0, p1, p2 , p3, p4 ];
    % freqArray = (0:nUniquePts-1) * (FS / n); % create the frequency array

    x = [ cos(thetaArr(1)) / pArr(1), cos(thetaArr(2)) / pArr(2), cos(thetaArr(3)) / pArr(3), cos(thetaArr(4)) / pArr(4), cos(thetaArr(5)) / pArr(5) ];

    y = [ sin(thetaArr(1)) / pArr(1), sin(thetaArr(2)) / pArr(2), sin(thetaArr(3)) / pArr(3), sin(thetaArr(4)) / pArr(4), sin(thetaArr(5)) / pArr(5) ];

    % attenuating certain frequencies so it appears on the graph better
    x(1) = x(1) * 0.1;
    x(2) = x(2) * 0.75;
    x(3) = x(3);
    x(4) = x(4) * 0.01;
    x(5) = x(5) * 0.001;

    y(1) = y(1) * 0.1;
    y(2) = y(2) * 0.75;
    y(3) = y(3);
    y(4) = y(4) * 0.01;
    y(5) = y(5) * 0.001;


    % viewing range
    high = 7.5e3;
    low = -7.5e3;

    % removing undefined regions
    for a = 1:5
        if y(a) == Inf || y(a) == -Inf
            y(a) = 0;
        end
        if x(a) == Inf || x(a) == -Inf
            x(a) = 0;
        end
    end


    % edges of the pentagon
    xLine1 = [ x(2), x(1) ];
    yLine1 = [ y(2), y(1) ];

    xLine2 = [ x(3), x(2) ] ;
    yLine2 = [ y(3), y(2) ] ;

    xLine3 = [ x(4), x(3) ] ;
    yLine3 = [ y(4), y(3) ] ;

    xLine4 = [ x(5), x(4) ];
    yLine4 = [ y(5), y(4) ];

    xLine5 = [ x(1), x(5) ];
    yLine5 = [ y(1), y(5) ];

    % radius of the pentagon
    xR1 = [ 0, x(1) ];
    yR1 = [ 0, y(1) ];

    xR2 = [ 0, x(2) ];
    yR2 = [ 0, y(2) ];

    xR3 = [ 0, x(3) ];
    yR3 = [ 0, y(3) ];

    xR4 = [ 0, x(4) ];
    yR4 = [ 0, y(4) ];

    xR5 = [ 0, x(5) ];
    yR5 = [ 0, y(5) ];

    % plotting radius
    plot(xR1, yR1, 'b')
    hold on;
    grid on;
    plot(xR2, yR2, 'r')
    plot(xR3, yR3, 'y')
    plot(xR4, yR4, 'g')
    plot(xR5, yR5, 'm')

    % plotting visualizer pentagon
    plot( xLine1, yLine1, 'k' )
    plot( xLine2, yLine2, 'k' )
    plot( xLine3, yLine3, 'k' )
    plot( xLine4, yLine4, 'k' )
    plot( xLine5, yLine5, 'k' )

    %plotting stock pentagon
    plot( xP1, yP1, 'c' )
    plot( xP2, yP2, 'c' )
    plot( xP3, yP3, 'c' )
    plot( xP4, yP4, 'c' )
    plot( xP5, yP5, 'c' )
    hold off;
    legend('0 Hz - 60 Hz', '60 Hz - 250 Hz', '250 - 2 kHz', '2 kHz - 8 kHz', '8 kHz -20 kHz' )
    axis([ low high low high ]);
