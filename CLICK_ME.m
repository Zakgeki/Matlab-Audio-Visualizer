 clc; clear all; close all;
[y,Fs] = audioread('misty.mp3');

player = audioplayer(y,Fs);
player.TimerPeriod=0.025;

player.play;

% information intialized here so it doesn't have to be reintialized throughout thte entire song


thetaArr = [ pi/2, 10.5*pi/5, 8.5*pi/5, 6.5*pi/5, 4.5*pi/5 ]; % array of thetas for pentagon

% x and y for static pentagon
q = 2.8571e-4;

xP = [ cos(thetaArr(1)) / q, cos(thetaArr(2)) / q, cos(thetaArr(3)) / q, cos(thetaArr(4)) / q, cos(thetaArr(5)) / q ];
yP = [ sin(thetaArr(1)) / q, sin(thetaArr(2)) / q, sin(thetaArr(3)) / q, sin(thetaArr(4)) / q, sin(thetaArr(5)) / q ];

xP1 = [ xP(2), xP(1) ];
yP1 = [ yP(2), yP(1) ];

xP2 = [ xP(3), xP(2) ];
yP2 = [ yP(3), yP(2) ];

xP3 = [ xP(4), xP(3) ];
yP3 = [ yP(4), yP(3) ];

xP4 = [ xP(5), xP(4) ];
yP4 = [ yP(5), yP(4) ];

xP5 = [ xP(1), xP(5) ];
yP5 = [ yP(1), yP(5) ];

while(player.isplaying)
   currentfft(player,y,Fs, thetaArr, xP1, yP1, xP2, yP2, xP3, yP3, xP4, yP4, xP5, yP5)
   drawnow;
end
