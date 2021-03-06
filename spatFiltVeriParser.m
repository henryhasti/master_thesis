%% DOA estimator verification master parser
% Parses data in master to be useful

%% Start with SIR (but a simple find and replace to work with SIR or SIR)
% master is stored as (angle, reverb, song, beamformer).SIR, SIR, SIR, perm
% Angle = 0 to 180º in 10º steps
% reverb = 0.01, 0.2, 0.4, 0.7 seconds
% songs from 1 to 10
% beamformer = basic, MaxRE, in-phase
close all
load spatFiltVerifyData.mat

drums=figure;
vocals=figure;
% We'll average across all songs for now
% fix reverb and beamformer type
angSep = 0:10:180;

beamType{1} = 'Basic';
beamType{2} = 'MaxRE';
beamType{3} = 'In phase';
reverb{1} = 0.01;
reverb{2} = 0.2;
reverb{3} = 0.4;
reverb{4} = 0.7;

% Plots beamformer shapes
el = 0;
az = deg2rad((0:10:180))';
azDOA = 0;
elDOA = 0;
weights(1).wt = [1,1,1,1];
weights(2).wt = [.775, .4, .4, .4];
weights(3).wt = [.5, .1, .1, .1];


grid on
for beamformer = 1:3
    
    beamPattern = abs(weights(beamformer).wt(1)*ones(size(az)) + ...
        weights(beamformer).wt(2)*sqrt(3)*sin(az)*sin(el2pol(el))*sqrt(3)*sin(azDOA)*sin(el2pol(elDOA)) + ...
        weights(beamformer).wt(3)*sqrt(3)*cos(el2pol(el))*sqrt(3)*cos(el2pol(elDOA)) + ...
        weights(beamformer).wt(4)*sqrt(3)*cos(az)*sin(el2pol(el))*sqrt(3)*cos(azDOA)*sin(el2pol(elDOA)));
    
    for maxlim = 1:4
        
        % Store SIRs for drums and vocal estimates, for every angle and for
        % every song
        SIRdrums = zeros(10, 19);
        SIRvocals = zeros(10, 19);
        
        
        for angleIdx = angSep/10 + 1
            
            for songIdx = 1:10
                
                SIRdrums(songIdx, angleIdx) = master(angleIdx, maxlim, songIdx, beamformer).SIR(1);
                SIRvocals(songIdx, angleIdx) = master(angleIdx, maxlim, songIdx, beamformer).SIR(2);
                
            end
        end
        
        if true % Do NOT plot beamformer shape in same window
            % Plot max, min, and average across the 10 songs, for both
            % instruments
            figure(drums)
            subplot(4, 3, (maxlim-1)*3 + beamformer)
            yyaxis left
            plot(angSep, mean(SIRdrums)-std(SIRdrums), 'r-', angSep, mean(SIRdrums)+std(SIRdrums), 'r-', angSep, mean(SIRdrums), 'k-')
            grid on
            grid minor
            title({
                [beamType{beamformer} ' beamformer']
            [num2str(reverb{maxlim}) ' s reverb']
            }, 'Color', 'k')
            ylabel('SIR (dB)', 'Color', 'k')
            set(gca,'ycolor','k')
            xlabel('Degrees between sources')
            xlim([0 180])
            ylim([-15 60])
            yyaxis right
            plot(angSep, beamPattern, 'b:')
            ylabel('Beamformer gain', 'Color', 'b')
            set(gca,'ycolor','b')
                        
            figure(vocals)
            subplot(4, 3, (maxlim-1)*3 + beamformer)
            plot(angSep, mean(SIRvocals)-std(SIRvocals), 'r-', angSep, mean(SIRvocals)+std(SIRvocals), 'r-', angSep, mean(SIRvocals), 'k-')
            grid on
            grid minor
            title({
                [beamType{beamformer} ' beamformer']
                [num2str(reverb{maxlim}) ' s reverb']
                }, 'Color', 'k')
            ylabel('SIR (dB)', 'Color', 'k')
            set(gca,'ycolor','k')
            xlabel('Degrees between sources')
            xlim([0 180])
            ylim([-15 60])
            yyaxis right
            plot(angSep, beamPattern, 'b:')
            ylabel('Beamformer gain', 'Color', 'b')
            set(gca,'ycolor','b')
            
        else % DO plot beamformer shape
            
            figure(drums)
            subplot(3, 5, (beamformer-1)*5 + maxlim+1)
            yyaxis left
            plot(angSep, min(SIRdrums), angSep, max(SIRdrums), angSep, mean(SIRdrums), angSep, zeros(size(angSep)))
            yyaxis right
            
            title({[beamType{beamformer} ' beamformer']; [num2str(reverb{maxlim}) ' s reverb']})
            ylabel('SIR (dB)')
            xlabel('Degrees between sources')
            xlim([0 180])
            ylim([-15 60])
            
            
            if true % For now, only drums
                figure(vocals)
                subplot(3, 5, (beamformer-1)*4 + maxlim)
                yyaxis left
                plot(angSep, min(SIRvocals), angSep, max(SIRvocals), angSep, mean(SIRvocals), angSep, zeros(size(angSep)))
                title([beamType{beamformer} ' beamformer and ' num2str(reverb{maxlim}) ' s reverb'])
                ylabel('SIR (dB)')
                xlabel('Degrees between sources')
                xlim([0 180])
                ylim([-15 60])
            end
            
        end
    end
end
figure(drums)
sgtitle('Drums mean SIR and error vs beamformer gain')

% Plot beamformer shapes
% el = 0;
% az = (0:0.01:pi)' + deg2rad(45);
% 
% weights(1).wt = [1,1,1,1];
% weights(2).wt = [.775, .4, .4, .4];
% weights(3).wt = [.5, .1, .1, .1];
% 
% 
% for idx = 1:3
%     
%     subplot(3,5,5*(idx-1)+1)
%     beamformer = weights(idx).wt(1)*ones(size(az)) + ...
%         weights(idx).wt(2)*sqrt(3)*sin(az)*sin(el2pol(el)) + ...
%         weights(idx).wt(3)*sqrt(3)*cos(el2pol(el)) + ...
%         weights(idx).wt(4)*sqrt(3)*cos(az)*sin(el2pol(el));
%     
%     plot(rad2deg(az)-45, abs(beamformer))
%     title('Beamformer gain')
%     xlabel('Degrees from DOA')
%     ylabel('Beamformer gain')
% end

figure(vocals)
sgtitle('Vocals mean SIR and error vs beamformer gain')

