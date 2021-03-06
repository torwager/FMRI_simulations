% Diagnostic testing
% Positive predictive value

% Take-homes:
% PPV is strongly driven by specificity and prevalence. Sensitivity has
% less impact.
% 
% Even if the sensitivity and specificity are both 98%, if the disease only
% affects 1% of the population, the PPV is 33%. That means that the chances
% of having the disease given a positive test is only 1 in 3.
%
% For rare diseases, a test must have almost perfect specificity to yield a
% reasonably high PPV. For example, with 100% sensitivity and 99.9%
% specificity, the PPV for a disease affecting 0.1% of the population (1 in
% 1000) is 0.5.  This makes testing for rare disorders impractical in many
% cases -- tests are expensive and likely to cause patients to worry
% unnecessarily, and in some cases make choices that cost them money or
% have other harmful health consequences.
%
% In common disorders, such as chronic pain, biomarkers with reasonably
% achievable values can yield useful PPVs, e.g., 70% PPV for 90% sensitivity and specificity.
% However, in 2019, the current average brain biomarkers for chronic pain
% are performing in the 80% specificity range against healthy controls, without
% considering specificity against other patient groups. This yields a more
% modest PPV of 50%, even without considering that biomarkers for more rare
% conditions will have substantially lower PPVs.  Clearly, more work in
% developing and testing the specificity of brain biomarkers is needed.



%% Example from Wikipedia:
% https://en.wikipedia.org/wiki/Positive_and_negative_predictive_values

tp = 20; fp = 180; fn = 10; tn = 1820;

sens = tp / (tp + fn)
spec = tn / (tn + fp)
ppv = tp / (tp + fp)

% prevalence or base rate

prev = (tp + fn) / (tp + fn + fp + tn)

% positive and negative predictive value

ppv = sens * prev / (sens * prev + (1-spec) * (1-prev))

npv = spec * (1 - prev) / ((1-sens) * prev + spec * (1 - prev) )

%% Some examples 

clear ppv_vals

calc_ppv = @(sens, spec, prev) sens * prev / (sens * prev + (1-spec) * (1-prev));

calc_ppv(.98, .98, .1)
calc_ppv(.98, .98, .05)
calc_ppv(.98, .98, .01)
calc_ppv(.98, .98, .001)
calc_ppv(.98, .999, .001)
calc_ppv(1, .999, .001)
calc_ppv(.9, .9, .2)

calc_ppv(.8, .8, .2)

%% A plot with 3 panels, showing various aspects of PPV

clear ppv_vals

sens_vals = [.8:.01:.99 .991:.001:.999 1];
spec = .98;
prev = [.5 .2 .1 .05 .01];

colors = custom_colors([.7 .5 .2], [1 .6 .2], length(prev));

% Fix specificity, plot PPV by Sensitivity, lines are Prevalence
% ---------------------------------------------------------------------

for i = 1:length(sens_vals)
    
    for j = 1:length(prev)
        
        ppv_vals(i, j) = calc_ppv(sens_vals(i), spec, prev(j));
        
    end
    
end

create_figure('ppv', 1, 3);
xlabel('Sensitivity')

for i = 1:size(ppv_vals, 2)
    plot(sens_vals, ppv_vals(:, i), 'LineWidth', 3, 'Color', colors{i});
end

clear mylegend
for i = 1:length(prev), mylegend{i} = sprintf('Prevalence %3.1f%%', 100*prev(i)); end
legend(mylegend, 'best')

ylabel('Positive predictive value (PPV)');
title('Specificity is 98%')




% Fix sensitivity, plot PPV by Specificity, lines are Prevalence
% ---------------------------------------------------------------------

sens = .98;
spec_vals = [.8:.01:.99 .991:.001:.999 1];
prev = [.5 .2 .1 .05 .01];


for i = 1:length(spec_vals)
    
    for j = 1:length(prev)
        
        ppv_vals(i, j) = calc_ppv(sens, spec_vals(i), prev(j));
        
    end
    
end

subplot(1, 3, 2);
xlabel('Specifity')

for i = 1:size(ppv_vals, 2)
    plot(spec_vals, ppv_vals(:, i), 'LineWidth', 3, 'Color', colors{i});
end

clear mylegend
for i = 1:length(prev), mylegend{i} = sprintf('Prevalence %3.1f%%', 100*prev(i)); end
% legend(mylegend)

ylabel('Positive predictive value (PPV)');
title('Sensitivity is 98%')


% Surface plot of PPV by prevalence and specificity
% ---------------------------------------------------------------------


clear ppv_vals

prev_vals = [.5:-.01:.01];
spec_vals = [.8:.01:.99  .991:.001:.999 1];
sens = .9;

for i = 1:length(prev_vals)
    
    for j = 1:length(spec_vals)
        
        ppv_vals(i, j) = calc_ppv(sens, spec_vals(j), prev_vals(i));
        
    end
    
end

subplot(1, 3, 3);

contourf(spec_vals, prev_vals, ppv_vals, 20)
xlabel('Specificity')
ylabel('Prevalence');

colorbar

%% Save

saveas(gcf, 'PPV_plots.svg');
saveas(gcf, 'PPV_plots.png');

