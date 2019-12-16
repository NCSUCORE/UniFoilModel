clc
close all
preLoadCallback

p.azimuthNormalizationFactor = 10;
p.zenithNormalizationFactor = 1;

sim('RLSUpdate_th')

bp = basisParams_deg.data(trigger.data,:);
bpNorm = squeeze(normBasisParams.data(trigger.data,:));

w = linspace(min(bp(:,1)),max(bp(:,1)));
h = linspace(min(bp(:,2)),max(bp(:,2)));
[w,h] = meshgrid(w,h);

wNorm = linspace(min(bpNorm(:,1)),max(bpNorm(:,1)));
hNorm = linspace(min(bpNorm(:,2)),max(bpNorm(:,2)));
[wNorm,hNorm] = meshgrid(wNorm,hNorm);

iterationNum = iterationNumber.data(trigger.data);
J = performanceIndex.data(trigger.data);

fc = fitCoefficients.data(trigger.data,:);

figure
set(gca,'NextPlot','Add')
grid on
xlabel('Width')
ylabel('Height')
set(gca,'FontSize',24)

hand.title = title(sprintf('Iteration Number = %s',num2str(iterationNum(1))));
hand.currentPoint = scatter3(bp(1,1),bp(1,2),...
    truePerformanceIndex(bp(1,1),bp(1,2)),...
    'DisplayName','Current - True J',...
    'CData',[0 1 0],...
    'Marker','o','MarkerFaceColor','flat');

hand.trueSurf = surf(w,h,truePerformanceIndex(w,h),...
    'EdgeColor','none','DisplayName','True Surf');

for ii = 2:size(fc,1)-1
    if ii == 12
        hand.estSurf = surf(w,h,estPerformanceIndex(wNorm,hNorm,fc(ii,:)));
    elseif ii>12
       hand.estSurf.ZData =  estPerformanceIndex(wNorm,hNorm,fc(ii,:));
    end
    hand.title.String = sprintf('Iteration Number = %s',num2str(iterationNum(ii)));
    hand.currentPoint.XData = bp(ii,1);
    hand.currentPoint.YData = bp(ii,2);
    hand.currentPoint.ZData = truePerformanceIndex(bp(ii,1),bp(ii,2));
    drawnow
end

function J = estPerformanceIndex(w,h,coeff)
J = coeff(1) + coeff(2)*w + coeff(3)*w.^2 + coeff(4)*h + coeff(5)*h.^2;
end

