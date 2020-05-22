function mel = f2mel(freq)

% Basic function. Converts input frequency to mel scale (from wikipedia)

mel = 2595*log10(1+freq/700);

end