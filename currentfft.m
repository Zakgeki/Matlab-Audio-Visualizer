%current fft
function currentfft ( player, Y, FS )

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

    q = 1;
    s = 1;
    d = int16( length(p) );

    pNew = zeros( [ d/10, 1 ] );

    while q < d
        pNew(s) = p(q);
        q = q + 10;
        s = s + 1;
    end

    % try gaussian or rect functions instead of bandpass?

    p0 = abs( bandpass(pNew, [ 1 60 ], FS) );
    p1 = abs( bandpass(pNew, [ 60 250 ], FS) );
    p2 = abs( bandpass(pNew, [ 250 2e3 ], FS) );
    p3 = abs( bandpass(pNew, [ 2e3 8e3 ], FS) );
    p4 = abs( bandpass(pNew, [ 8e3 20e3 ], FS) );

    % length( p0 )
    % length( p1 )
    % length( p2 )
    % length( p3 )
    % length( p4 )

    pArr = [ p0, p1, p2, p3, p4 ];
    %freqArray = (0:nUniquePts-1) * (FS / n); % create the frequency array

    thetaArr = [ pi/2, 4.5*pi/5, 6.5*pi/5, 8.5*pi/5, 10.5*pi/5 ];



    x = cos(thetaArr) ./ pArr;
    y = sin(thetaArr) ./ pArr;

    % x1 = x(1);
    % x2 = x(2) - x(1);
    % x3 = x(3) - x(2);
    % x4 = x(4) - x(3);
    % x5 = x(5) - x(4);
    %
    % y1 = y(1);
    % y2 = y(2) - y(1);
    % y3 = y(3) - y(2);
    % y4 = y(4) - y(3);
    % y5 = y(5) - y(4);
    %
    % xArr = [ x1, x2, x3, x4, x5 ];
    % yArr = [ y1, y2, y3, y4, y5 ];
    %
    % m = yArr ./ xArr;
    %
    % yFin = m.*x;

    plot(x, y)
    xlabel('Frequency (Hz)')
    ylabel('Power (watts)')
    title('Frequency vs. Power')
    grid on;
    axis([-20e9 20e9 -20e9 20e9]);
