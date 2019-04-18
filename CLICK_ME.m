 clc;
[y,Fs] = audioread('Misty johnny mathis (with lyrics).mp3');

player = audioplayer(y,Fs);
player.TimerPeriod=0.025;

player.play;

while(player.isplaying)
   currentfft(player,y,Fs)
   drawnow;
end
